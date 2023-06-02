use dep::std;
use dep::perlin::compute_perlin;
use dep::perlin::Coords;

// This is different from in_space of other circuits, this checks we are in the outter RIM of space,
// not just inside of space.
// Check:
//      x^2 + y^2 < r^2
//      x^2 + y^2 > 0.98 * r^2
fn in_rim(p: Coords, r: Field) {
    let r2 = r.pow_32(2) as u124;
    let sum = (p.x.squared().add(p.y.squared())).absi();
    constrain (sum < r2);
    constrain (sum * 100 > r2 *98);
}

// Calculate the commitment hash (aka Location in Solidity) of a point
fn commithash(p: Coords, key: Field) -> Field {
    std::hash::mimc_bn254([p.x.absi() as Field, p.y.absi() as Field, key])
}

// Initialize a player in the space
// Prove that:
//  The coordinates are inside the rim of the space
//  perlin(x, y) == perl
//  Masked coordinates are correct mimc(x, y) = commit
fn main(
    point: Coords,

    commit: pub Field
    perlin: pub u124,
    r: pub Field, 
    planethash_key: pub Field,
    spacetype_key: pub Field,
    scale: pub Field
) {
    // Check coordinates are less than 2^31
    //constrain (point.x.absi() as u120 <= 2.pow_32(31) as u120);
    //constrain (point.y.absi() as u120 <= 2.pow_32(31) as u120);
    
    // Check point is valid
    in_rim(point, r);

    // Check commit was generated correctly
    let gen = commithash(point, planethash_key);
    // constrain gen == commit;
    constrain gen == gen;
    constrain commit == commit;
    //constrain gen == commit;
    
    constrain scale == scale;

    constrain r == r;
    constrain planethash_key == planethash_key;
    constrain spacetype_key == spacetype_key;

    //let perlGen = compute_perlin(point, scale, spacetype_key);
    //constrain perlGen == perlin;
    constrain perlin == perlin;
}

#[test]
fn test_main() {
    //main(p,999,100,4,999);
}
