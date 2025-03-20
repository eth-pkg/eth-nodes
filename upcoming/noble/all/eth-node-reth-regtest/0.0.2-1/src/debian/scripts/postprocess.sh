#!/bin/bash
set -e
set -o pipefail 

trap 'echo "Error: Command \"$BASH_COMMAND\" failed with exit code $?"' ERR

echo "Creating user and group eth-node-regtest"
adduser --system --quiet --group eth-node-regtest || true


echo "Creating /var/lib/eth-node-regtest directory"
mkdir -p /var/lib/eth-node-regtest 

echo "Setting ownership of /var/lib/eth-node-regtest to eth-node-regtest"
chown eth-node-regtest:eth-node-regtest /var/lib/eth-node-regtest 

echo "Creating /var/lib/eth-node-regtest/reth directory"
mkdir -p /var/lib/eth-node-regtest/reth 

echo "Setting ownership of /var/lib/eth-node-regtest/reth to eth-node-reth-regtest"
chown -R eth-node-reth-regtest:eth-node-reth-regtest /var/lib/eth-node-regtest/reth

mkdir -p /var/logs/eth-node-regtest/reth 
chown -R eth-node-reth-regtest:eth-node-reth-regtest /var/logs/eth-node-regtest/reth

echo "Adding eth-node-reth-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-reth-regtest || true 

exit 0
