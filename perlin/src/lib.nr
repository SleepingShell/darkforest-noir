use dep::std;

// TODO: Generic
struct Coords {
    x: u120,
    y: u120,
}

struct Signed {
    x: u120,
    is_neg: bool,
}

impl Signed {
    fn add(self, other: Self) -> Self {
        let mut val: u120 = 0;
        let mut is_neg = false;

        if (!(self.is_neg ^ other.is_neg)) {
            val = self.x + other.x;
            is_neg = self.is_neg;
        } else {
            //TODO: Handle when equal (0 should be not negative)
            if (self.x > other.x) {
                val = self.x - other.x;
                if (self.is_neg) {
                    is_neg = true;
                } else {
                    is_neg = false;
                }
            } else {
                val = other.x - self.x;
                if (self.is_neg) {
                    is_neg = false;
                } else {
                    is_neg = true;
                }
            }
        }

        Self {
            x: val,
            is_neg: is_neg,
        }
    }

    fn sub(self, other: Self) -> Self {
        if (self.x >= other.x) {
            Self {
                x: self.x-other.x,
                is_neg: false
            }
        } else {
            Self {
                x: other.x-self.x,
                is_neg: true
            }
        }
    }

    fn mul(self, other: Self) -> Self {
        Self {
            x: self.x * other.x,
            is_neg: self.is_neg ^ other.is_neg,
        }
    }

    fn div(self, other: Self) -> Self {
        Self {
            x: self.x / other.x,
            is_neg: self.is_neg ^ other.is_neg,
        }
    }

    fn muli(self, other: u120) -> Self {
        Self {
            x: self.x * other,
            is_neg: self.is_neg,
        }
    }

    fn zero() -> Self {
        Self {
            x: 0,
            is_neg: false,
        }
    }
}

fn toSigned(val: u120) -> Signed {
    Signed {
        x: val,
        is_neg: false,
    }
}

impl Coords {
    fn diff(self, other: Self) -> Self {
        let mut diffx: u120 = 0;
        let mut diffy: u120 = 0;
        if self.x > other.x {
            diffx = self.x - other.x;
        } else {
            diffx = other.x - self.x;
        }

        if (self.y > other.y) {
            diffy = self.y - other.y;
        } else {
            diffy = other.y - self.y;
        }
        Self {
            x: diffx,
            y: diffy
        }
    }
}

global DENOMINATOR = 1125899906842624; //2^50
global PERLIN_MAX = 64;
// curve group order / 2
global HALF_ORDER = 10944121435919637611123202872628637544274182200208017171849102093287904247808;

fn is_negative(x: Field) -> bool {
    x > HALF_ORDER
}

fn is_direction_negative(x: u120) -> bool {
    x > VEC_DENOMINATOR
}

// Return a psuedorandom integer in [0, 15]
fn random(x: u120, y: u120, scale: u120, seed: Field) -> u4 {
    let t = std::hash::mimc_bn254([x as Field, y as Field, scale as Field, seed]);

    let bits = t.to_le_bits(32);
    8*(bits[3] as u4) + 4*(bits[2] as u4) + 2*(bits[1] as u4) + (bits[0] as u4)
}

fn random_gradient_at(point: Coords, scale: u120, seed: Field) -> (Signed, Signed) {
    let DIRECTIONS: [(Signed, Signed); 16] = [
        (Signed { x: 1000, is_neg: false }, Signed { x: 0, is_neg: false }),
        (Signed { x: 923, is_neg: false }, Signed { x: 382, is_neg: false }),
        (Signed { x: 707, is_neg: false }, Signed { x: 707, is_neg: false }),
        (Signed { x: 382, is_neg: false }, Signed { x: 923, is_neg: false }),
        (Signed { x: 0, is_neg: false }, Signed { x: 1000, is_neg: false }),
        (Signed { x: 383, is_neg: true }, Signed { x: 923, is_neg: false }),
        (Signed { x: 708, is_neg: true }, Signed {x: 707, is_neg: false }),
        (Signed { x: 924, is_neg: true }, Signed { x: 382, is_neg: false}),
        (Signed { x: 1000, is_neg: true }, Signed { x: 0, is_neg: false }),
        (Signed { x: 924, is_neg: true }, Signed { x: 383, is_neg: true }),
        (Signed { x: 708, is_neg: true }, Signed { x: 708, is_neg: true }),
        (Signed { x: 383, is_neg: true }, Signed { x: 924, is_neg: true }),
        (Signed { x: 1, is_neg: true }, Signed { x: 1000, is_neg: true }),
        (Signed { x: 382, is_neg: false }, Signed { x: 924, is_neg: true }),
        (Signed { x: 707, is_neg: false }, Signed { x: 708, is_neg: true }),
        (Signed { x: 923, is_neg: false }, Signed { x: 383, is_neg: true }),
    ];
    let rand = random(point.x, point.y, scale, seed);

    let mut direction = (Signed::zero(), Signed::zero());
    for i in 0..16 {
        if (i as u4 == rand) {
            direction = DIRECTIONS[i];
        }
    };

    (direction.0.muli(point.x), direction.1.muli(point.y))
}

fn get_weight(corner: Coords, point: Coords, scale: u120) -> u120 {
    let diff = corner.diff(point);
    let res = (scale - diff.x) * (scale - diff.y);

    res
}

fn get_corners(point: Coords, scale: u120) -> [Coords; 4] {
    let bottom_left = Coords {
        x: (point.x / scale) * scale,
        y: (point.y / scale) * scale,
    };

    [
        Coords { x: bottom_left.x, y: bottom_left.y },                  // BL
        Coords { x: bottom_left.x + scale, y: bottom_left.y },          // BR
        Coords { x: bottom_left.x, y: bottom_left.y + scale},           // TL
        Coords { x: bottom_left.x + scale, y: bottom_left.y + scale},   // TR
    ]
}

fn single_scale_perlin(point: Coords, scale: u120, seed: Field) -> Signed {
    let corners = get_corners(point, scale);

    let mut numerator = toSigned(0);
    for i in 0..4 {
        let corner = corners[i];
        let offsetx = toSigned(point.x).sub(toSigned(corner.x));
        let offsety = toSigned(point.y).sub(toSigned(corner.y));
        let offset = Coords {
            x: offsetx.x,
            y: offsety.x,
        };
        
        let gradient = random_gradient_at(offset, scale, seed);
        let dotx = gradient.0.muli(offset.x);
        let doty = gradient.1.muli(offset.y);
        let dot = dotx.add(doty);
        let weight = get_weight(corner, point, scale);

        let t = dot.muli(weight);
        numerator = numerator.add(t);
    }

    numerator.div(toSigned(scale * scale * scale))
}

fn compute_perlin(point: Coords, scale: u120, seed: Field) -> Signed {
    let mut perlin = toSigned(0);

    perlin = perlin.add(single_scale_perlin(point, scale, seed));
    perlin = perlin.add(single_scale_perlin(point, scale*2, seed));
    perlin = perlin.add(single_scale_perlin(point, scale*4, seed));
    perlin = perlin.add(single_scale_perlin(point, scale*4, seed));

    perlin = perlin.add(single_scale_perlin(point, scale, seed));
    perlin = perlin.div(toSigned(4));

    //(perlin * (PERLIN_MAX)/2) + (PERLIN_MAX / 2)
    perlin = perlin.muli(PERLIN_MAX/2).add(toSigned(PERLIN_MAX/2));
    perlin
}

#[test]
fn test_random() {
    let (gx, gy) = random_gradient_at(Coords {x: 10, y: 20},4,16);
    
    let gxx = gx.x;
    let gyx = gy.x;
    std::println(gxx);
    std::println(gyx);

    let perl1 = compute_perlin(Coords {x: 145, y: 20}, 20, 10).x;
    std::println(perl1);

    let perl2 = compute_perlin(Coords {x: 151, y: 18}, 20, 10).x;
    std::println(perl2);

    let perl3 = compute_perlin(Coords {x: 141, y: 20}, 20, 10).x;
    std::println(perl3);
}