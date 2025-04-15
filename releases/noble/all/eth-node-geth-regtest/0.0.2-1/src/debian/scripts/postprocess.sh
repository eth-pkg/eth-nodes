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

echo "Creating /var/lib/eth-node-regtest/geth directory"
mkdir -p /var/lib/eth-node-regtest/geth 

touch /var/lib/eth-node-regtest/geth/geth_password.txt
touch /var/lib/eth-node-regtest/geth/sk.json

echo "2e0834786285daccd064ca17f1654f67b4aef298acbb82cef9ec422fb4975622" | tee -a /var/lib/eth-node-regtest/geth/sk.json

echo "Setting ownership of /var/lib/eth-node-regtest/geth to eth-node-geth-regtest"
chown -R eth-node-geth-regtest:eth-node-geth-regtest /var/lib/eth-node-regtest/geth

mkdir -p /var/logs/eth-node-regtest/geth 
chown -R eth-node-geth-regtest:eth-node-geth-regtest /var/logs/eth-node-regtest/geth

echo "Adding eth-node-geth-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-geth-regtest || true 

exit 0
