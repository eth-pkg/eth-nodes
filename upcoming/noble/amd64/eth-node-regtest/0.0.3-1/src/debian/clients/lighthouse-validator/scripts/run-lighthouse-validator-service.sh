#!/usr/bin/env bash

exec /usr/lib/eth-node-regtest/lighthouse-validator/run-lighthouse-validator.sh \
    --conf-file /etc/eth-node-regtest/conf/eth-node-regtest.conf \
    --conf-file /etc/eth-node-regtest/conf/eth-node-lighthouse-validator-regtest.conf
