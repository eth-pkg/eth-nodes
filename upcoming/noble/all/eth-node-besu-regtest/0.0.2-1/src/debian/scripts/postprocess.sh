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

echo "Creating /var/lib/eth-node-regtest/besu directory"
mkdir -p /var/lib/eth-node-regtest/besu 

echo "Setting ownership of /var/lib/eth-node-regtest/besu to eth-node-besu-regtest"
chown -R eth-node-besu-regtest:eth-node-besu-regtest /var/lib/eth-node-regtest/besu

mkdir -p /var/logs/eth-node-regtest/besu 
chown -R eth-node-besu-regtest:eth-node-besu-regtest /var/logs/eth-node-regtest/besu


echo "Adding eth-node-besu-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-besu-regtest || true 

exit 0
