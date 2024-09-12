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

echo "Creating /var/lib/eth-node-testnet/lodestar directory"
mkdir -p /var/lib/eth-node-testnet/lodestar 

echo "Setting ownership of /var/lib/eth-node-testnet/lodestar to eth-node-lodestar-testnet"
chown -R eth-node-lodestar-testnet:eth-node-lodestar-testnet /var/lib/eth-node-testnet/lodestar

echo "Adding eth-node-lodestar-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-lodestar-testnet || true 

exit 0
