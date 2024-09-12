#!/usr/bin/env bash 


exec /usr/lib/eth-node-nimbus-eth2-validator-testnet/bin/run-nimbus-eth2-validator.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-nimbus-eth2-validator-testnet/nimbus-eth2-validator.conf