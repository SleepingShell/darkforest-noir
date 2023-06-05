#!/bin/sh

circuits=(Biomebase Init Move Reveal Whitelist)
for circuit in "${circuits[@]}"
do
  lower=$(echo "$circuit" | awk '{print tolower($0)}')
  path="$lower/contract/plonk_vk.sol"
  newpath="eth/contracts/verifiers/${lower}_vk.sol"

  # Generate the contract
  cd $lower
  nargo codegen-verifier
  cd ..
  
  cp $path $newpath
  sed -i "s/UltraVerificationKey/UltraVerificationKey${circuit}/g" $newpath
  sed -i "s/\<UltraVerifier\>/UltraVerifier${circuit}/g" $newpath
done