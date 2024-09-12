#!/usr/bin/env bash 


exec /usr/lib/eth-node-lodestar-validator-testnet/bin/run-lodestar-validator.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-lodestar-validator-testnet/lodestar-validator.conf