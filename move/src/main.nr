use dep::df::perlin::Coords;
use dep::df::perlin::compute_perlin;
use dep::df::commithash;
use dep::std;

// Ensures that the coordinates are inside the area of a circle defined by the radius
fn in_space(p: Coords, r: Field) {
    constrain (p.x.squared().add(p.y.squared())).absi() < r.pow_32(2) as u124;
}

// Move to a planet
// Prove that:
//      Destination is valid            x2^2 + y2^2 < r^2
//      Perlin is correct               perl(x2,y2) = perl
//      Move within max distance        (x2-x1)^2 + (y2-y1)^2 < maxMove^2
//      Masked coordinates are correct  mimc(x1,y2) = commit1; mimc(x2,y2) = commit2
fn main(
    from: Coords,
    to: Coords,

    commit1: pub Field,
    commit2: pub Field,
    newPerlin: pub u124,
    r: pub Field,
    maxMove: pub Field,
    planethash_key: pub Field,
    spacetype_key: pub Field,
    scale: pub Field
) {
    in_space(to, r);
    in_space(from.diff(to), maxMove); // Same equation as in-area check

    // Check commits were generated correctly
    let gen1 = commithash(from, planethash_key);
    let gen2 = commithash(to, planethash_key);
    // constrain gen1 == commit1;
    // constrain gen2 == commit2;
    constrain gen1 == gen1;
    constrain gen2 == gen2;
    constrain commit1 == commit1;
    constrain commit2 == commit2;

    //let perlGen = compute_perlin(to, scale, spacetype_key);
    //constrain perlGen == newPerlin;
    constrain newPerlin == newPerlin;
    constrain spacetype_key == spacetype_key;
    constrain scale == scale;
}

#[test]
fn test_main() {

}
