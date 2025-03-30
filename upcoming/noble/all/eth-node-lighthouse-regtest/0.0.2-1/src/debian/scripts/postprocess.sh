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

echo "Creating /var/lib/eth-node-regtest/lighthouse directory"
mkdir -p /var/lib/eth-node-regtest/lighthouse 

echo "Setting ownership of /var/lib/eth-node-regtest/lighthouse to eth-node-lighthouse-regtest"
chown -R eth-node-lighthouse-regtest:eth-node-lighthouse-regtest /var/lib/eth-node-regtest/lighthouse

mkdir -p /var/logs/eth-node-regtest/lighthouse 
chown -R eth-node-lighthouse-regtest:eth-node-lighthouse-regtest /var/logs/eth-node-regtest/lighthouse

echo "Adding eth-node-lighthouse-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-lighthouse-regtest || true 

exit 0
