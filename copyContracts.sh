#!/bin/sh

cp init/contract/plonk_vk.sol eth/contracts/verifiers/init_vk.sol
#cp move/contract/plonk_vk.sol eth/contracts/verifiers/move_vk.sol
cp reveal/contract/plonk_vk.sol eth/contracts/verifiers/reveal_vk.sol

sed -i 's/UltraVerificationKey/UltraVerificationKeyInit/g' eth/contracts/verifiers/init_vk.sol
sed -i 's/\<UltraVerifier\>/UltraVerifierInit/g' eth/contracts/verifiers/init_vk.sol
sed -i 's/UltraVerificationKey/UltraVerificationKeyReveal/g' eth/contracts/verifiers/reveal_vk.sol
sed -i 's/\<UltraVerifier\>/UltraVerifierReveal/g' eth/contracts/verifiers/reveal_vk.sol