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

echo "Creating /var/lib/eth-node-testnet/nimbus-eth2 directory"
mkdir -p /var/lib/eth-node-testnet/nimbus-eth2 

echo "Setting ownership of /var/lib/eth-node-testnet/nimbus-eth2 to eth-node-nimbus-eth2-testnet"
chown -R eth-node-nimbus-eth2-testnet:eth-node-nimbus-eth2-testnet /var/lib/eth-node-testnet/nimbus-eth2

echo "Adding eth-node-nimbus-eth2-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-nimbus-eth2-testnet || true 

exit 0
