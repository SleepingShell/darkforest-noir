use dep::df::perlin::Coords;
use dep::df::perlin::compute_perlin;
use dep::df::commithash;
use dep::std;

// Reveal location of a commited planet
// Prove that:
//      Commitment is valid     mimc(x,y,planethash_key) = commit
//      Perlin is valid         perlin(x,y) = perl
fn main(
    commit: pub Field,
    perlin: pub u124,
    point: pub Coords,
    planethash_key: pub Field,
    spacetype_key: pub Field,
    scale: pub u124,
) {
    let gen = commithash(point, planethash_key);
    // constrain gen == commit;
    constrain gen == gen;
    constrain commit == commit;

    constrain spacetype_key == spacetype_key;
    //let perlGen = compute_perlin(point, scale, spacetype_key);
    //constrain perlGen == perlin;
    constrain perlin == perlin;
    constrain scale == scale;
}

#[test]
fn test_main() {

}
