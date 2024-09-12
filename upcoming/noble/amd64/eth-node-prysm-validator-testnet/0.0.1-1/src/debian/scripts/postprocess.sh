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

echo "Creating /var/lib/eth-node-testnet/prysm directory"
mkdir -p /var/lib/eth-node-testnet/prysm 

echo "Setting ownership of /var/lib/eth-node-testnet/prysm to eth-node-prysm-testnet"
chown -R eth-node-prysm-testnet:eth-node-prysm-testnet /var/lib/eth-node-testnet/prysm

echo "Adding eth-node-prysm-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-prysm-testnet || true 

exit 0
