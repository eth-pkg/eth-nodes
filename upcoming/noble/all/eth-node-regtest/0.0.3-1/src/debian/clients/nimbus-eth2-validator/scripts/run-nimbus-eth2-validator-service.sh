#!/usr/bin/env bash

CLIENT="nimbus-eth2-validator"

exec /usr/lib/eth-node-regtest/${CLIENT}/run-${CLIENT}.sh \
    --conf-file /etc/eth-node-regtest/conf/eth-node-regtest.conf \
    --conf-file /etc/eth-node-regtest/conf/eth-node-${CLIENT}-regtest.conf
