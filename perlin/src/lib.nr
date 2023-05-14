use dep::std;

// Taken from darkforest-eth, nefgatives were mod 1000
global DIRECTIONS: [(Field, Field); 16] = [(1000,0),(923,382),(707,707),(382,923),(0,1000),(617,923),(292,707),(76,382),(0,0),(76,617),(292,292),(617,76),(999,0),(382,76),(707,292),(923,617)];
//global DENOMINATOR = 1125899906842624000;
global DENOMINATOR = 1125899906842624;

// curve group order / 2
global HALF_ORDER = 10944121435919637611123202872628637544274182200208017171849102093287904247808;

fn is_negative(x: Field) -> bool {
    x > HALF_ORDER
}

// Return a psuedorandom integer in [0, 15]
fn random(x : Field, y : Field, scale : Field) -> u4 {
    let t = std::hash::mimc_bn254([x, y, scale]);
    std::println(t);

    let bits = t.to_le_bits(32);
    8*(bits[3] as u4) + 4*(bits[2] as u4) + 2*(bits[1] as u4) + (bits[0] as u4)
    //((t as u120) & 0x0f) as Field
}

// TODO: Since we cannot have negative numbers, should maybe make negative direction > 1000 and mod
fn random_gradient_at(x: Field, y: Field, scale: Field) -> (Field, Field) {
    let rand = random(x, y, scale);

    let mut direction = (0,0);
    for i in 0..15 {
        if (i as u4 == rand) {
            direction = DIRECTIONS[i];
        }
    }

    let x = direction.0;
    let y = direction.1;

    (x * DENOMINATOR , y * DENOMINATOR)
}

struct Coords {
    x: Field,
    y: Field,
}

// TODO: Maybe this should accept integers and we should be casting earlier
fn get_corners_and_grad_vectors(x: Field, y: Field, scale: Field) -> ([(Field, Field); 4], [(Field, Field); 4]) {
    let xint = x as u120;
    let yint = y as u120;

    let bottom_left_coords = Coords {
        x: xint - (xint % scale),
        y: yint - (yint % scale),
    }

    let bottom_right_coords = Coords {
        x: bottom_left_coords.x + scale,
        y: bottom_left_coords.y,
    }

    let top_left_coords = Coords {
        x: bottom_left_coords.x,
        y: bottom_left_coords.y + scale,
    }

    let top_right_coords = Coords {
        x: bottom_right_coords.x,
        y: top_left_coords.y
    }

    //TODO: Make either everything a tuple or everything Coords type
    let mut res = random_gradient_at(bottom_left_coords.x as Field, bottom_left_coords.y as Field, scale);
    let bottom_left_gradient = Coords { x: res.0, y: res.1 };

    res = random_gradient_at(bottom_right_coords.x as Field, bottom_right_coords.y as Field, scale);
    let bottom_right_gradient = Coords { x: res.0, y: res.1 };

    res = random_gradient_at(top_left_coords.x as Field, top_left_coords.y as Field, scale);
    let top_left_gradient = Coords { x: res.0, y: res.1 };

    res = random_gradient_at(top_right_coords.x as Field, top_right_coords.y as Field, scale);
    let top_right_gradient = Coords { x: res.0, y: res.1 };

    
}

#[test]
fn test_random() {
    let r = random(1, 3, 16);
    std::println(r);

    let (gx, gy) = random_gradient_at(1,4,16);
    std::println(gx);
    std::println(gy);
}