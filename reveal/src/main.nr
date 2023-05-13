use dep::std;

// Reveal location of a commited planet
// Prove that:
//      Commitment is valid     mimc(x,y,planethash_key) = commit
//      Perlin is valid         perlin(x,y) = perl
fn main(
    x: pub Field,
    y : pub Field,
    commit: pub Field,
    planethash_key: pub Field
) {
    let gen = std::hash::mimc_bn254([x, y, planethash_key]);
    constrain gen == gen;
    constrain commit == commit;

    // TODO: perlin
}

#[test]
fn test_main() {

}
