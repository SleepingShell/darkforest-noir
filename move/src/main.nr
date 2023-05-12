
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
    commit1: pub Field,
    commit2: pub Field
) {
    
}

#[test]
fn test_main() {

}
