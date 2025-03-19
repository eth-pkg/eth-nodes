#!/usr/bin/env bash 


exec /usr/lib/eth-node-lighthouse-regtest/bin/run-lighthouse.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-lighthouse-regtest/lighthouse-regtest.conf