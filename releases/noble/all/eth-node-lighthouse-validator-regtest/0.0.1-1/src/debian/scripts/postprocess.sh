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

echo "Creating /var/lib/eth-node-regtest/lighthouse-validator directory"
mkdir -p /var/lib/eth-node-regtest/lighthouse-validator

mkdir -p /var/lib/eth-node-regtest/lighthouse-validator/logs

echo "Setting ownership of /var/lib/eth-node-regtest/lighthouse-validator to eth-node-lighthouse-val-regtest"
chown -R eth-node-lighthouse-val-regtest:eth-node-lighthouse-val-regtest /var/lib/eth-node-regtest/lighthouse-validator
chown -R eth-node-lighthouse-val-regtest:eth-node-lighthouse-val-regtest /var/lib/eth-node-regtest/lighthouse-validator/logs


mkdir -p /var/logs/eth-node-regtest/lighthouse-validator
chown -R eth-node-lighthouse-val-regtest:eth-node-lighthouse-val-regtest /var/logs/eth-node-regtest/lighthouse-validator

echo "Adding eth-node-lighthouse-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-lighthouse-val-regtest || true 

exit 0
