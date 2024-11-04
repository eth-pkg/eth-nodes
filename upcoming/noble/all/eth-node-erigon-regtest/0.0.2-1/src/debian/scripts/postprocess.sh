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

echo "Creating /var/lib/eth-node-regtest/erigon directory"
mkdir -p /var/lib/eth-node-regtest/erigon 

echo "Setting ownership of /var/lib/eth-node-regtest/erigon to eth-node-erigon-regtest"
chown -R eth-node-erigon-regtest:eth-node-erigon-regtest /var/lib/eth-node-regtest/erigon

mkdir -p /var/logs/eth-node-regtest/erigon 
chown -R eth-node-erigon-regtest:eth-node-erigon-regtest /var/logs/eth-node-regtest/erigon

echo "Adding eth-node-erigon-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-erigon-regtest || true 


echo "Importing genesis state"
sudo -u eth-node-erigon-regtest erigon init --datadir "/var/lib/eth-node-regtest/erigon" "/var/lib/eth-node-regtest/regtest/genesis/genesis.json"


exit 0
