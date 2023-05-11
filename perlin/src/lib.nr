use dep::std;

// Taken from darkforest-eth, nefgatives were mod 1000
global DIRECTIONS: [(Field, Field); 16] = [(1000,0),(923,382),(707,707),(382,923),(0,1000),(617,923),(292,707),(76,382),(0,0),(76,617),(292,292),(617,76),(999,0),(382,76),(707,292),(923,617)];
//global DENOMINATOR = 1125899906842624000;
global DENOMINATOR = 1125899906842624;

// Return a psuedorandom integer in [0, 15]
fn Random(x : Field, y : Field, scale : Field) -> u4 {
    let t = std::hash::mimc_bn254([x, y, scale]);
    std::println(t);

    let bits = t.to_le_bits(32);
    8*(bits[3] as u4) + 4*(bits[2] as u4) + 2*(bits[1] as u4) + (bits[0] as u4)
    //((t as u120) & 0x0f) as Field
}

fn RandomGradientAt(x: Field, y: Field, scale: Field) -> (Field, Field) {
    let rand = Random(x, y, scale);

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

#[test]
fn test_Random() {
    let r = Random(1, 3, 16);
    std::println(r);

    let (gx, gy) = RandomGradientAt(1,4,16);
    std::println(gx);
    std::println(gy);
}