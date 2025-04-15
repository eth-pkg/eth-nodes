#!/usr/bin/env bash

exec /usr/lib/eth-node-regtest/besu/run-besu.sh \
    --conf-file /etc/eth-node-regtest/conf/eth-node-regtest.conf \
    --conf-file /etc/eth-node-regtest/conf/eth-node-besu-regtest.conf
