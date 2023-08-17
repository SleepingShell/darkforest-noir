use dep::df::perlin::Coords;
use dep::df::perlin::compute_perlin;
use dep::df::commithash;
use dep::std;

// Prove that I know the correct biome of a planet:
// Prove that:
//      Commitment is valid     mimc(x,y,planethash_key) == commit
//      Biome is valid (perlin w/ biomebase_key)    perlin(x,y) == biome_base
fn main(
    point: Coords,

    commit: pub Field,
    biome_base: pub u124,
    planethash_key: pub Field,
    biomebase_key: pub Field,
    scale: pub u124,
) {
    let gen = commithash(point, planethash_key);
    assert (gen == commit);

    let biome_gen = compute_perlin(point, scale, biomebase_key);
    assert (biome_gen == biome_base);
}

#[test]
fn test_main() {

}
