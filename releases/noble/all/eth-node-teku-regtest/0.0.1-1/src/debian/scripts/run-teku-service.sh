#!/usr/bin/env bash 


exec /usr/lib/eth-node-teku-regtest/bin/run-teku.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-teku-regtest/teku-regtest.conf