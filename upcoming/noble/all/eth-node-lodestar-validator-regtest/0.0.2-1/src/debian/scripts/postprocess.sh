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

echo "Creating /var/lib/eth-node-regtest/lodestar-validator directory"
mkdir -p /var/lib/eth-node-regtest/lodestar-validator

mkdir -p /var/lib/eth-node-regtest/lodestar-validator/logs

echo "Setting ownership of /var/lib/eth-node-regtest/lodestar-validator to eth-node-lodestar-val-regtest"
chown -R eth-node-lodestar-val-regtest:eth-node-lodestar-val-regtest /var/lib/eth-node-regtest/lodestar-validator
chown -R eth-node-lodestar-val-regtest:eth-node-lodestar-val-regtest /var/lib/eth-node-regtest/lodestar-validator/logs

mkdir -p /var/logs/eth-node-regtest/lodestar-validator 
chown -R eth-node-lodestar-val-regtest:eth-node-lodestar-val-regtest /var/logs/eth-node-regtest/lodestar-validator


echo "Adding eth-node-lodestar-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-lodestar-val-regtest || true 

exit 0
