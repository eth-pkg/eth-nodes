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

echo "Creating /var/lib/eth-node-testnet/nethermind directory"
mkdir -p /var/lib/eth-node-testnet/nethermind 

echo "Setting ownership of /var/lib/eth-node-testnet/nethermind to eth-node-nethermind-testnet"
chown -R eth-node-nethermind-testnet:eth-node-nethermind-testnet /var/lib/eth-node-testnet/nethermind

echo "Adding eth-node-nethermind-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-nethermind-testnet || true 

exit 0
