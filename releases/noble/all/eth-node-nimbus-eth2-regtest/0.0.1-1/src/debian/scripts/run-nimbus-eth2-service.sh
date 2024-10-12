#!/usr/bin/env bash 


exec /usr/lib/eth-node-nimbus-eth2-regtest/bin/run-nimbus-eth2.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-nimbus-eth2-regtest/nimbus-eth2-regtest.conf