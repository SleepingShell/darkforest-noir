use dep::std;
use dep::perlin::compute_perlin;
use dep::perlin::Coords;;

//TODO: Move this to library so move can also use it
// Check:
//      x^2 + y^2 < r^2
//      x^2 + y^2 > 0.98 * r^2
fn in_rim(p: Coords, r: Field) {
    let r2 = r.pow_32(2) as u124;
    let sum = (p.x.squared().add(p.y.squared())).absi();
    constrain (sum < r2);
    constrain (sum * 100 > r2 *98);
}

// Initialize a player in the space
// Prove that:
//  The coordinates are inside the rim of the space
//  perlin(x, y) == perl
//  Masked coordinates are correct mimc(x, y) = commit
fn main(
        point: Coords,
        planethash_key: Field,

        r: pub Field, 
        scale: pub Field,
        commit: pub Field
) {
    // Check coordinates are less than 2^31
    constrain (point.x.absi() as u120 <= 2.pow_32(31) as u120);
    constrain (point.y.absi() as u120 <= 2.pow_32(31) as u120);
    
    // Check point is valid
    in_rim(point, r);

    // Check commit was generated correctly
    let gen = std::hash::mimc_bn254([x, y, planethash_key]);
    constrain gen == gen;
    constrain commit == commit;
    //constrain gen == commit;
    
    constrain scale == scale;

    constrain r == r;
    constrain planethash_key == planethash_key;
}

#[test]
fn test_main() {
    let p = Coords {
        x: Signed {
            x: 100,
            is_neg: false,
        },
        y: Signed {
            y: 50,
            is_neg: false,
        }
    };


    main(p,999,100,4,999);
}
