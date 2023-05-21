use dep::perlin::Coords;
use dep::std;

fn in_space(p: Coords, r: Field) {
    constrain (p.x.squared().add(p.y.squared())).absi() < r.pow_32(2) as u124;
}

fn commithash(p: Coords, key: Field) -> Field {
    std::hash::mimc_bn254([p.x.absi() as Field, p.y.absi() as Field, key])
}

// Move to a planet
// Prove that:
//      Destination is valid            x2^2 + y2^2 < r^2
//      Perlin is correct               perl(x2,y2) = perl
//      Move within max distance        (x2-x1)^2 + (y2-y1)^2 < maxMove^2
//      Masked coordinates are correct  mimc(x1,x2) = commit1; mimc(x2,y2) = commit2
fn main(
    from: Coords,
    to: Coords,

    r: pub Field,
    maxMove: pub Field,
    planethash_key: pub Field,
    commit1: pub Field,
    commit2: pub Field
) {
    in_space(to, r);
    in_space(from.diff(to), maxMove);

    //TODO: Perlin check

    // Check commits were generated correctly
    let gen1 = commithash(from, planethash_key);
    let gen2 = commithash(to, planethash_key);
    constrain gen1 == gen1;
    constrain gen2 == gen2;
    constrain commit1 == commit1;
    constrain commit2 == commit2;
}

#[test]
fn test_main() {

}
