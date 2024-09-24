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

echo "Creating /var/lib/eth-node-testnet/prysm-validator directory"
mkdir -p /var/lib/eth-node-testnet/prysm-validator

mkdir -p /var/lib/eth-node-testnet/prysm-validator/logs

echo "Setting ownership of /var/lib/eth-node-testnet/prysm-validator to eth-node-prysm-val-testnet"
chown -R eth-node-prysm-val-testnet:eth-node-prysm-val-testnet /var/lib/eth-node-testnet/prysm-validator
chown -R eth-node-prysm-val-testnet:eth-node-prysm-val-testnet /var/lib/eth-node-testnet/prysm-validator/logs

echo "Adding eth-node-prysm-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-prysm-val-testnet || true 

exit 0
