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

echo "Creating /var/lib/eth-node-testnet/reth directory"
mkdir -p /var/lib/eth-node-testnet/reth 

echo "Setting ownership of /var/lib/eth-node-testnet/reth to eth-node-reth-testnet"
chown -R eth-node-reth-testnet:eth-node-reth-testnet /var/lib/eth-node-testnet/reth

echo "Adding eth-node-reth-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-reth-testnet || true 

exit 0
