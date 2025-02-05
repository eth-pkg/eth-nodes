#!/usr/bin/env bash 


exec /usr/lib/eth-node-lodestar-regtest/bin/run-lodestar.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-lodestar-regtest/lodestar-regtest.conf