#!/usr/bin/env bash 


exec /usr/lib/eth-node-lighthouse-validator-regtest/bin/run-lighthouse-validator.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-lighthouse-validator-regtest/lighthouse-validator.conf