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

echo "Creating /var/lib/eth-node-regtest/prysm-validator directory"
mkdir -p /var/lib/eth-node-regtest/prysm-validator

mkdir -p /var/lib/eth-node-regtest/prysm-validator/logs

echo "Setting ownership of /var/lib/eth-node-regtest/prysm-validator to eth-node-prysm-val-regtest"
chown -R eth-node-prysm-val-regtest:eth-node-prysm-val-regtest /var/lib/eth-node-regtest/prysm-validator
chown -R eth-node-prysm-val-regtest:eth-node-prysm-val-regtest /var/lib/eth-node-regtest/prysm-validator/logs

mkdir -p /var/logs/eth-node-regtest/prysm-validator 
chown -R eth-node-prysm-val-regtest:eth-node-prysm-val-regtest /var/logs/eth-node-regtest/prysm-validator

echo "Adding eth-node-prysm-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-prysm-val-regtest || true 

exit 0
