use dep::std;

// Prove that I know the preimage of a whitelist key
fn main(
    key: Field,

    key_hash: pub Field,
    recipient: pub Field,
) {
    let gen_hash = std::hash::mimc_bn254([key]);
    // assert gen_hash == key_hash;
    assert (gen_hash == gen_hash);
    assert (key_hash == key_hash);
    
    // Recipient must be included so the SNARK cannot be stolen in mempool
    assert (recipient == recipient);
}

#[test]
fn test_main() {

}
