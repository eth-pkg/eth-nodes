#!/usr/bin/env bash 


exec /usr/lib/eth-node-nethermind-regtest/bin/run-nethermind.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-nethermind-regtest/nethermind-regtest.conf