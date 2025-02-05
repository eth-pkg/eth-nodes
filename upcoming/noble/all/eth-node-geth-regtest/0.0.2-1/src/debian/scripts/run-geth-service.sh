#!/usr/bin/env bash 


exec /usr/lib/eth-node-geth-regtest/bin/run-geth.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-geth-regtest/eth-node-geth-regtest.conf