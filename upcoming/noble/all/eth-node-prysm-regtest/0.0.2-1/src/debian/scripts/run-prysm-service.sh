#!/usr/bin/env bash 


exec /usr/lib/eth-node-prysm-regtest/bin/run-prysm.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-prysm-regtest/prysm-regtest.conf