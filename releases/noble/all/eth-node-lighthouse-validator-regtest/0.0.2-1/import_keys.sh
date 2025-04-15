#!/bin/bash

## using custom script for devnet, regtest
## this is for testing purposes only,
## on production you would not use local_keystore with password in plain textfile
##
mkdir -p src/debian/validator/validators

output_file="src/debian/validator/validator_definitions.yml"
touch "$output_file"
echo "# Validator definitions" >"$output_file"

for json_file in src/debian/validator/keys/*.json; do
  pubkey=$(jq -r '.pubkey' "$json_file")
  pubkey="0x$pubkey"
  json_filename=$(basename "$json_file")

  mkdir -p "src/debian/validator/validators/$pubkey"
  cp "$json_file" "src/debian/validator/validators/$pubkey/"

  cat <<EOF >>"$output_file"
- enabled: true
  voting_public_key: $pubkey
  description: ''
  type: local_keystore
  voting_keystore_path: /var/lib/eth-node-regtest/lighthouse-validator/validators/$pubkey/$json_filename
  voting_keystore_password: test test
EOF
done

echo "Done! YAML generated in $output_file"
