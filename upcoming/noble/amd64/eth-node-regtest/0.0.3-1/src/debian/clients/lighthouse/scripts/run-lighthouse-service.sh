#!/usr/bin/env bash

exec /usr/lib/eth-node-regtest/lighthouse/run-lighthouse.sh \
    --conf-file /etc/eth-node-regtest/conf/eth-node-regtest.conf \
    --conf-file /etc/eth-node-regtest/conf/eth-node-lighthouse-regtest.conf
