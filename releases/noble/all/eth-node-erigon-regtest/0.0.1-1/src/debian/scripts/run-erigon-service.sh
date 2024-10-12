#!/usr/bin/env bash 


exec /usr/lib/eth-node-erigon-regtest/bin/run-erigon.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-erigon-regtest/erigon-regtest.conf