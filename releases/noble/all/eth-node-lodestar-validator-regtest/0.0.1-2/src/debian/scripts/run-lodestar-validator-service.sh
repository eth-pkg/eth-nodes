#!/usr/bin/env bash 


exec /usr/lib/eth-node-lodestar-validator-regtest/bin/run-lodestar-validator.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-lodestar-validator-regtest/lodestar-validator.conf