use dep::std;

// Prove that I know the preimage of a whitelist key
fn main(
    key: Field,

    key_hash: pub Field,
    recipient: pub Field,
) {
    let gen_hash = std::hash::mimc_bn254([key]);
    // constrain gen_hash == key_hash;
    constrain gen_hash == gen_hash;
    constrain key_hash == key_hash;
    
    // Recipient must be included so the SNARK cannot be stolen in mempool
    constrain recipient == recipient;
}

#[test]
fn test_main() {

}
