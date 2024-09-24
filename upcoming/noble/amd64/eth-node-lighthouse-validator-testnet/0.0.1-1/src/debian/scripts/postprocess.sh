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

echo "Creating /var/lib/eth-node-testnet/lighthouse-validator directory"
mkdir -p /var/lib/eth-node-testnet/lighthouse-validator

mkdir -p /var/lib/eth-node-testnet/lighthouse-validator/logs

echo "Setting ownership of /var/lib/eth-node-testnet/lighthouse-validator to eth-node-lighthouse-val-testnet"
chown -R eth-node-lighthouse-val-testnet:eth-node-lighthouse-val-testnet /var/lib/eth-node-testnet/lighthouse-validator
chown -R eth-node-lighthouse-val-testnet:eth-node-lighthouse-val-testnet /var/lib/eth-node-testnet/lighthouse-validator/logs

echo "Adding eth-node-lighthouse-testnet to eth-node-testnet group"
usermod -aG eth-node-testnet eth-node-lighthouse-val-testnet || true 

exit 0
