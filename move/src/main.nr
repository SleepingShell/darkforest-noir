use dep::std;

fn in_space(x: Field, y: Field, r: Field) {
    constrain (x.pow_32(2) + y.pow_32(2)) as u120 < r.pow_32(2) as u120;
}

// Move to a planet
// Prove that:
//      Destination is valid            x2^2 + y2^2 < r^2
//      Perlin is correct               perl(x2,y2) = perl
//      Move within max distance        (x2-x1)^2 + (y2-y1)^2 < maxMove^2
//      Masked coordinates are correct  mimc(x1,x2) = commit1; mimc(x2,y2) = commit2
fn main(
    x1: Field,
    y1: Field,
    x2: Field,
    y2: Field,

    r: pub Field,
    maxMove: pub Field,
    planethash_key: pub Field,
    commit1: pub Field,
    commit2: pub Field
) {
    in_space(x2, y2, r);
    //TODO: Check negative?
    in_space(x2 - x1, y2 - y1, maxMove);

    //TODO: Perlin check

    // Check commits were generated correctly
    let gen1 = std::hash::mimc_bn254([x1, y1, planethash_key]);
    let gen2 = std::hash::mimc_bn254([x2, y2, planethash_key]);
    constrain gen1 == gen1;
    constrain gen2 == gen2;
    constrain commit1 == commit1;
    constrain commit2 == commit2;
}

#[test]
fn test_main() {

}
