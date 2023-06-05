use dep::std::hash::mimc_bn254;

mod signed;
mod perlin;

// Calculate the commitment hash (aka Location in Solidity) of a point
fn commithash(p: perlin::Coords, key: Field) -> Field {
    mimc_bn254([p.x.absi() as Field, p.y.absi() as Field, key])
}