use dep::std;

struct Coords {
    x: Field,
    y: Field,
}

impl Coords {
    fn diff(self, other: Self) -> Self {
        Self {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }

    fn print(self) {
        let x = self.x;
        let y = self.y;
        std::println("{");
        std::println(x);
        std::println(y);
        std::println("}");
    }
}

global DENOMINATOR = 1125899906842624; //2^50
global PERLIN_MAX = 64;
global HALF_R = 10944121435919637611123202872628637544274182200208017171849102093287904247808;
global NEG_1 = 21888242871839275222246405745257275088548364400416034343698204186575808495616;

// Return a psuedorandom integer in [0, 15]
fn random(x: Field, y: Field, scale: Field, seed: Field) -> u4 {
    let t = std::hash::mimc_bn254([x, y, scale as Field, seed]);

    let bits = t.to_le_bits(32);
    8*(bits[3] as u4) + 4*(bits[2] as u4) + 2*(bits[1] as u4) + (bits[0] as u4)
}

fn random_gradient_at(point: Coords, scale: Field, seed: Field) -> (Field, Field) {
    let DIRECTIONS: [(Field, Field); 16] = [
        (1000, 0),
        (923, 382),
        (707, 707),
        (382, 923),
        (0, 1000),
        (0-383, 923),
        (0-708, 707),
        (0-924, 382),
        (0-1000, 0),
        (0-924, 0-383),
        (0-708, 0-708),
        (0-383, 0-924),
        (0-1, 0-1000),
        (382, 0-924),
        (707, 0-708),
        (923, 0-383)
    ];
    let rand = random(point.x, point.y, scale, seed);
    let mut direction = (0,0);
    for i in 0..16 {
        if (i as u4 == rand) {
            direction = DIRECTIONS[i];
        }
    };

    //TODO: handle neg ( > HALF_P)

    (direction.0 * point.x, direction.1 * point.y)
}

fn get_weight(corner: Coords, point: Coords, scale: Field) -> Field {
    let diff = corner.diff(point);
    std::println("===");
    corner.print();
    point.print();
    diff.print();
    let res = (scale - diff.x) * (scale - diff.y);

    //let mut res = 1;
    //if (corner.x > point.x) {
    //    res *= (scale - (corner.x - point.x));
    //} else {
    //    res *= (scale - (point.x - corner.x));
    //}

    //if (corner.y > point.y) {
    //    res *= (scale - (corner.y - point.y));
    //} else {
    //    res *= (scale - (point.y - corner.y));
    //}

    res
}

fn get_corners(point: Coords, scale: Field) -> [Coords; 4] {
    // TODO: Need to use modulus when available
    let bottom_left = Coords {
        x: (point.x / scale) * scale,
        y: (point.y / scale) * scale,
    };

    [
        Coords { x: bottom_left.x, y: bottom_left.y },                          // BL
        Coords { x: bottom_left.x + scale, y: bottom_left.y },               // BR
        Coords { x: bottom_left.x, y: bottom_left.y + scale },               // TL
        Coords { x: bottom_left.x + scale, y: bottom_left.y + scale },    // TR
    ]
}

fn single_scale_perlin(point: Coords, scale: Field, seed: Field) -> Field {
    let corners = get_corners(point, scale);

    let mut numerator = 0;
    for i in 0..4 {
        let corner = corners[i];
        let offsetx = point.x - corner.x;
        let offsety = point.y - corner.y;
        let offset = Coords {
            x: offsetx,
            y: offsety,
        };
        
        let gradient = random_gradient_at(corner, scale, seed);
        let dotx = gradient.0 * offset.x;
        let doty = gradient.1 * offset.y;
        let dot = dotx + doty;
        let weight = get_weight(corner, point, scale);

        let t = dot * weight;
        numerator += t;
    }

    numerator / (scale * scale * scale)
}

fn compute_perlin(point: Coords, scale: Field, seed: Field) -> Field {
    let mut perlin = 0;

    perlin += (single_scale_perlin(point, scale, seed) *2);
    perlin += (single_scale_perlin(point, scale*2, seed));
    perlin += (single_scale_perlin(point, scale*4, seed));
    perlin += (single_scale_perlin(point, scale*8, seed));
    perlin /= 4;
    //perlin = (perlin * (PERLIN_MAX/2)) + PERLIN_MAX/2;
    perlin
}

#[test]
fn test_perlin() {
    let scale = 10;
    let seed = 1;

    let p1 = Coords { x: 101, y: 250 };
    let p2 = Coords { x: 105, y: 240 };

    let perl1 = compute_perlin(p1, scale, seed);
    let perl2 = compute_perlin(p2, scale, seed);
    std::println(perl1);
    std::println(perl2);
}