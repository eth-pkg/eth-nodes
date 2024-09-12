#!/bin/bash
set -e
set -o pipefail 

trap 'echo "Error: Command \"$BASH_COMMAND\" failed with exit code $?"' ERR

echo "Creating user and group eth-node-testnet"
adduser --system --quiet --group eth-node-testnet || true


echo "Creating /var/lib/eth-node-testnet directory"
mkdir -p /var/lib/eth-node-testnet 

echo "Setting ownership of /var/lib/eth-node-testnet to eth-node-testnet"
chown eth-node-testnet:eth-node-testnet /var/lib/eth-node-testnet 

echo "Creating /var/lib/eth-node-testnet/geth directory"
mkdir -p /var/lib/eth-node-testnet/geth 

touch /var/lib/eth-node-testnet/geth/geth_password.txt
touch /var/lib/eth-node-testnet/geth/sk.json

echo "2e0834786285daccd064ca17f1654f67b4aef298acbb82cef9ec422fb4975622" | tee -a /var/lib/eth-node-testnet/geth/sk.json

echo "Setting ownership of /var/lib/eth-node-testnet/geth to eth-node-geth-testnet"
chown -R eth-node-geth-testnet:eth-node-geth-testnet /var/lib/eth-node-testnet/geth

echo "Adding eth-node-geth-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-geth-testnet || true 

exit 0
