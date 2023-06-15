use dep::df::perlin::Coords;
use dep::df::perlin::compute_perlin;
use dep::df::signed::Signed;
use dep::df::commithash;
use dep::std;

// Reveal location of a commited planet
// Prove that:
//      Commitment is valid     mimc(x,y,planethash_key) = commit
//      Perlin is valid         perlin(x,y) = perl
fn main(
    commit: pub Field,
    perlin: pub u124,
    point: pub Coords,
    planethash_key: pub Field,
    spacetype_key: pub Field,
    scale: pub u124,
) {
    let gen = commithash(point, planethash_key);
    std::println(gen);
    //assert (commit == commit);
    assert (commit == gen);

    let perlGen = compute_perlin(point, scale, spacetype_key);
    std::println(perlGen);
    assert (perlGen == perlin);
    //assert (perlin == perlin);
}

#[test]
fn test_main() {
    let p = Coords {
        x: Signed {
            x: 876,
            is_neg: false
        },
        y: Signed {
            x: 949,
            is_neg: false
        }
    };

    main(0x0000802bc4d6d6db6e2c80c476949ab73fdf9a1100d9bed50d4c24ab1e31d003, 0x10, p, 115, 116, 16384);
}

#[test]
fn test_find_perlin() {
    let p = Coords {
        x: Signed {
            x: 89577,
            is_neg: false
        },
        y: Signed {
            x: 67865,
            is_neg: false
        }
    };

    let perlGen = compute_perlin(p, 16384, 116);
    std::println(perlGen);

    let gen = commithash(p, 115);
    std::println(gen);
}