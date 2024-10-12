#!/usr/bin/env bash 


exec /usr/lib/eth-node-besu-regtest/bin/run-besu.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-besu-regtest/besu-regtest.conf