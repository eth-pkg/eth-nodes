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

echo "Creating /var/lib/eth-node-testnet/erigon directory"
mkdir -p /var/lib/eth-node-testnet/erigon 

echo "Setting ownership of /var/lib/eth-node-testnet/erigon to eth-node-erigon-testnet"
chown -R eth-node-erigon-testnet:eth-node-erigon-testnet /var/lib/eth-node-testnet/erigon

echo "Adding eth-node-erigon-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-erigon-testnet || true 

exit 0
