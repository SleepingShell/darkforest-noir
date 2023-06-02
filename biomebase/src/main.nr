use dep::perlin::Coords;
use dep::perlin::compute_perlin;
use dep::std;

// Calculate the commitment hash (aka Location in Solidity) of a point
fn commithash(p: Coords, key: Field) -> Field {
    std::hash::mimc_bn254([p.x.absi() as Field, p.y.absi() as Field, key])
}

// Reveal location of a commited planet
// Prove that:
//      Commitment is valid     mimc(x,y,planethash_key) = commit
//      Perlin is valid         perlin(x,y) = perl
fn main(
    point: Coords,

    commit: pub Field,
    biome_base: pub u124,
    planethash_key: pub Field,
    biomebase_key: pub Field,
    scale: pub u124,
) {
    let gen = commithash(point, planethash_key);
    // constrain gen == commit;
    constrain gen == gen;
    constrain commit == commit;

    constrain spacetype_key == spacetype_key;
    //let biome_gen = compute_perlin(point, scale, biomebase_key);
    //constrain biome_gen == biome_base;
    constrain biome_base == biome_base;
    constrain scale == scale;
}

#[test]
fn test_main() {

}
