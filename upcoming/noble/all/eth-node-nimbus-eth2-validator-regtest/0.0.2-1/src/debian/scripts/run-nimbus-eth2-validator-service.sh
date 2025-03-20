#!/usr/bin/env bash 


exec /usr/lib/eth-node-nimbus-eth2-validator-regtest/bin/run-nimbus-eth2-validator.sh \
    --conf-file /etc/eth-node-regtest-config/regtest.conf \
    --conf-file /etc/eth-node-nimbus-eth2-validator-regtest/nimbus-eth2-validator.conf