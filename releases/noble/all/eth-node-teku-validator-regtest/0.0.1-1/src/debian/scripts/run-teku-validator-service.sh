#!/usr/bin/env bash 


exec /usr/lib/eth-node-teku-validator-regtest/bin/run-teku-validator.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-teku-validator-regtest/teku-validator.conf