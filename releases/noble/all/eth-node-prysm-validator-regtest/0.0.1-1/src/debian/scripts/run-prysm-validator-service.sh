#!/usr/bin/env bash 


exec /usr/lib/eth-node-prysm-validator-regtest/bin/run-prysm-validator.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-prysm-validator-regtest/prysm-validator.conf