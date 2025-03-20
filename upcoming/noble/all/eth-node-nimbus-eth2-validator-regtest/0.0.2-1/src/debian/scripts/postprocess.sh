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

echo "Creating /var/lib/eth-node-regtest/nimbus-eth2-validator directory"
mkdir -p /var/lib/eth-node-regtest/nimbus-eth2-validator

mkdir -p /var/lib/eth-node-regtest/nimbus-eth2-validator/logs

echo "Setting ownership of /var/lib/eth-node-regtest/nimbus-eth2-validator to eth-node-nimbus-eth2-val-regtest"
chown -R eth-node-nimbus-eth2-val-regtest:eth-node-nimbus-eth2-val-regtest /var/lib/eth-node-regtest/nimbus-eth2-validator
chown -R eth-node-nimbus-eth2-val-regtest:eth-node-nimbus-eth2-val-regtest /var/lib/eth-node-regtest/nimbus-eth2-validator/logs

mkdir -p /var/logs/eth-node-regtest/nimbus-eth2-validator 
chown -R eth-node-nimbus-eth2-val-regtest:eth-node-nimbus-eth2-val-regtest /var/logs/eth-node-regtest/nimbus-eth2-validator


echo "Adding eth-node-nimbus-eth2-regtest to eth-node-regtest group"
usermod -aG eth-node-regtest eth-node-nimbus-eth2-val-regtest || true 

exit 0
