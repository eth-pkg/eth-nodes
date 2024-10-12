#!/usr/bin/env bash 


exec /usr/lib/eth-node-reth-regtest/bin/run-reth.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-reth-regtest/reth-regtest.conf