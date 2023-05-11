use dep::std;
use df::perlin::Random;

// Check:
//      x^2 + y^2 < r^2
//      x^2 + y^2 > 0.98 * r^2
fn inRim(x: Field, y: Field, r: Field) {
    let r2 = r.pow_32(2) as u120;
    let sum = (x.pow_32(2) + y.pow_32(2)) as u120;
    constrain (sum < r2);
    constrain (sum * 100 > r2 *98);
}

// Initialize a player in the space
// Prove that:
//  The coordinates are inside the rim of the space
//  perlin(x, y) == perl
//  Masked coordinates are correct mimc(x, y) = commit
//TODO: Add planet key. 
fn main(x: Field, 
        y: Field,
        planethash_key: Field,
        r: pub Field, 
        scale: pub Field,
        commit: pub Field
) {
    // Check coordinates are less than 2^31
    constrain (x as u120 <= 2.pow_32(31) as u120);
    constrain (y as u120 <= 2.pow_32(31) as u120);
    
    // Check point is valid
    inRim(x, y, r);

    // Check commit was generated correctly
    let gen = std::hash::mimc_bn254([x, y, planethash_key]);
    constrain gen == gen;
    constrain commit == commit;
    //constrain gen == commit;
    
    constrain scale == scale;
}

#[test]
fn test_main() {
    main(55,83,999, 100,4,999);
}
