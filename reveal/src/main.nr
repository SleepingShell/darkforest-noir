use dep::perlin::Coords;
use dep::std;

fn commithash(p: Coords, key: Field) -> Field {
    std::hash::mimc_bn254([p.x.absi() as Field, p.y.absi() as Field, key])
}

// Reveal location of a commited planet
// Prove that:
//      Commitment is valid     mimc(x,y,planethash_key) = commit
//      Perlin is valid         perlin(x,y) = perl
fn main(
    point: pub Coords,
    commit: pub Field,
    planethash_key: pub Field
) {
    let gen = commithash(point, planethash_key);
    constrain gen == gen;
    constrain commit == commit;

    // TODO: perlin
}

#[test]
fn test_main() {

}
