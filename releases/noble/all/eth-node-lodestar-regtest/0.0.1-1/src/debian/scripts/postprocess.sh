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

echo "Creating /var/lib/eth-node-regtest/lodestar directory"
mkdir -p /var/lib/eth-node-regtest/lodestar 

echo "Setting ownership of /var/lib/eth-node-regtest/lodestar to eth-node-lodestar-regtest"
chown -R eth-node-lodestar-regtest:eth-node-lodestar-regtest /var/lib/eth-node-regtest/lodestar

mkdir -p /var/logs/eth-node-regtest/lodestar 
chown -R eth-node-lodestar-regtest:eth-node-lodestar-regtest /var/logs/eth-node-regtest/lodestar

echo "Adding eth-node-lodestar-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-lodestar-regtest || true 

exit 0
