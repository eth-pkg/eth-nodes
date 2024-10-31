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

echo "Creating /var/lib/eth-node-regtest/nethermind directory"
mkdir -p /var/lib/eth-node-regtest/nethermind 

echo "Setting ownership of /var/lib/eth-node-regtest/nethermind to eth-node-nethermind-regtest"
chown -R eth-node-nethermind-regtest:eth-node-nethermind-regtest /var/lib/eth-node-regtest/nethermind

mkdir -p /var/logs/eth-node-regtest/nethermind 
chown -R eth-node-nethermind-regtest:eth-node-nethermind-regtest /var/logs/eth-node-regtest/nethermind

echo "Adding eth-node-nethermind-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-nethermind-regtest || true 

exit 0
