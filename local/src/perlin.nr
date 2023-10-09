use dep::std;
use crate::signed::Signed;

struct Coords {
    x: Signed,
    y: Signed,
}

impl Coords {
    fn diff(self, other: Self) -> Self {
        Self {
            x: self.x.sub(other.x),
            y: self.y.sub(other.y),
        }
    }
}

global DENOMINATOR = 1125899906842624; //2^50
global PERLIN_MAX = 32;
global pow123: u124 = 10633823966279326983230456482242756608; //2^123

// Return a psuedorandom integer in [0, 15]
fn random(x: u124, y: u124, scale: u124, seed: Field) -> u4 {
    let t = std::hash::mimc_bn254([x as Field, y as Field, scale as Field, seed]);

    t as u4
}

// Return a deterministicly random direction of the gradient vector
fn random_gradient_at(point: Coords, scale: u124, seed: Field) -> (Signed, Signed) {
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
    
    // If this isn't done, the points reflected across the axes will have the same randomness
    let mut x = point.x.absi();
    let mut y = point.y.absi();
    if (point.x.is_neg) {
        x += pow123;
    }
    if (point.y.is_neg) {
        y += pow123;
    }

    let rand = random(x,y,scale,seed);

    let mut direction = (Signed::zero(), Signed::zero());
    for i in 0..16 {
        if (i as u4 == rand) {
            direction = DIRECTIONS[i];
        }
    };

    (direction.0, direction.1)
}

// The closer a point is to a gradient, the more influental that gradient is on the value
// Returns a value with scale**2 denominator
fn get_weight(corner: Coords, point: Coords, scale: u124) -> u124 {
    let diff = corner.diff(point);
    let res = (scale - diff.x.absi()) * (scale - diff.y.absi());

    res
}

// Get the coordinates of the corners of the grid cell the point exists in
fn get_corners(point: Coords, scale: u124) -> [Coords; 4] {
    let scaleS = Signed::to_signed(scale);

    let bottom_left = Coords {
        x: point.x.div(scaleS).mul(scaleS),
        y: point.y.div(scaleS).mul(scaleS),
    };

    [
        Coords { x: bottom_left.x, y: bottom_left.y },                          // BL
        Coords { x: bottom_left.x.add(scaleS), y: bottom_left.y },               // BR
        Coords { x: bottom_left.x, y: bottom_left.y.add(scaleS) },               // TL
        Coords { x: bottom_left.x.add(scaleS), y: bottom_left.y.add(scaleS) },    // TR
    ]
}

// Do product of the graduent and offset
fn dot(offset: Coords, gradient: (Signed, Signed)) -> Signed {
    let dotx = gradient.0.mul(offset.x);
    let doty = gradient.1.mul(offset.y);
    dotx.add(doty)
}

// Returns a perlin value that is equal to [return val / scale]
// This number should be interpreted as [-1.0, 1.0]
// A value of 0 would then result in PERLIN_MAX/2
fn single_scale_perlin(point: Coords, scale: u124, seed: Field) -> Signed {
    let corners = get_corners(point, scale);

    let mut numerator = Signed::to_signed(0);
    for i in 0..4 {
        let corner = corners[i];

        // Denominator: scale
        let offset = point.diff(corner);
        
        // Denominator: 1000
        let gradient = random_gradient_at(corner, scale, seed);
        
        // Denominator: 1000*scale
        let d = dot(offset, gradient); 

        // Denominator: scale**2
        let weight = get_weight(corner, point, scale);

        // Denominator: 1000*scale**3 
        let t = d.muli(weight);
        numerator = numerator.add(t);
    }

    // Denominator: scale
    numerator.div(Signed::to_signed(1000*scale*scale))
}

// Compute the perlin value, and consider the effects of gradients of further intersection points
fn compute_perlin(point: Coords, scale: u124, seed: Field) -> u124 {
    let mut perlin = Signed::to_signed(0);

    perlin = perlin.add(single_scale_perlin(point, scale, seed).mul(Signed::to_signed(2)));
    perlin = perlin.add(single_scale_perlin(point, scale*2, seed));
    perlin = perlin.add(single_scale_perlin(point, scale*4, seed));
    perlin = perlin.add(single_scale_perlin(point, scale*8, seed));

    perlin = perlin.div(Signed::to_signed(4));
    perlin = perlin.muli(PERLIN_MAX/2);

    //(perlin.absi() / scale) + (PERLIN_MAX/2)
    perlin.div(Signed::to_signed(scale)).add(Signed::to_signed(PERLIN_MAX/2)).absi()
}

#[test]
fn test_perlin() {
    let perl1 = compute_perlin(Coords {x: Signed::to_signed(145), y: Signed::to_signed(10)}, 128, 10);
    std::println(perl1);

    let perl2 = compute_perlin(Coords {x: Signed::to_signed(146), y: Signed::to_signed(20)}, 128, 10);
    std::println(perl2);

    let perl3 = compute_perlin(Coords {x: Signed::to_signed(147), y: Signed::to_signed(20)}, 128, 10);
    std::println(perl3);

    let perl4 = compute_perlin(Coords {x: Signed::to_signed(55502045), y: Signed::to_signed(2222200)}, 128, 10);
    std::println(perl4);

    let perl5 = compute_perlin(Coords {x: Signed::to_signed(7589282), y: Signed::to_signed(41241)}, 128, 10);
    std::println(perl5);
}