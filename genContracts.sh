#!/bin/sh

circuits=(Biomebase Init Move Reveal Whitelist)
for circuit in "${circuits[@]}"
do
  lower=$(echo "$circuit" | awk '{print tolower($0)}')
  path="$lower/contract/${lower}/plonk_vk.sol"
  newpath="eth/contracts/verifiers/${lower}_vk.sol"
  json="$lower/target/$lower.json"
  newjson="eth/test/circuits/$lower.json"

  # Generate the contract
  cd $lower
  nargo codegen-verifier
  cd ..
  
  cp $path $newpath
  cp $json $newjson
  sed -i "s/UltraVerificationKey/UltraVerificationKey${circuit}/g" $newpath
  sed -i "s/\<UltraVerifier\>/UltraVerifier${circuit}/g" $newpath
done