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

echo "Creating /var/lib/eth-node-testnet/lighthouse directory"
mkdir -p /var/lib/eth-node-testnet/lighthouse 

echo "Setting ownership of /var/lib/eth-node-testnet/lighthouse to eth-node-lighthouse-testnet"
chown -R eth-node-lighthouse-testnet:eth-node-lighthouse-testnet /var/lib/eth-node-testnet/lighthouse

echo "Adding eth-node-lighthouse-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-lighthouse-testnet || true 

exit 0
