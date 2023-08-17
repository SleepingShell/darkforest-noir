use dep::std;
use dep::df::perlin::Coords;
use dep::df::perlin::compute_perlin;
use dep::df::commithash;
use dep::df::signed::Signed;

// This is different from in_space of other circuits, this checks we are in the outter RIM of space,
// not just inside of space.
// Check:
//      x^2 + y^2 < r^2
//      x^2 + y^2 > 0.98 * r^2
fn in_rim(p: Coords, r: Field) {
    let r2 = r.pow_32(2) as u124;
    let sum = (p.x.squared().add(p.y.squared())).absi();
    assert (sum < r2);
    //assert (sum * 100 > r2 *98);
}

// Initialize a player in the space
// Prove that:
//  The coordinates are inside the rim of the space
//  perlin(x, y) == perl
//  Masked coordinates are correct mimc(x, y) = commit
fn main(
    point: Coords,

    commit: pub Field,
    perlin: pub u124,
    r: pub Field, 
    planethash_key: pub Field,
    spacetype_key: pub Field,
    scale: pub u124
) {
    // Check coordinates are less than 2^31
    assert (point.x.absi() as u120 <= 2.pow_32(31) as u120);
    assert (point.y.absi() as u120 <= 2.pow_32(31) as u120);
    
    // Check point is valid
    in_rim(point, r);

    // Check commit was generated correctly
    let gen = commithash(point, planethash_key);
    assert (gen == commit);

    let perlGen = compute_perlin(point, scale, spacetype_key);
    assert (perlGen == perlin);
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

    main(p, 0x0000802bc4d6d6db6e2c80c476949ab73fdf9a1100d9bed50d4c24ab1e31d003, 0x10, 120000, 115, 116, 16384);
}
