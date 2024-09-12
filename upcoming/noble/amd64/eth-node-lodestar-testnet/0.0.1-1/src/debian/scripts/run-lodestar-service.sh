#!/usr/bin/env bash 


exec /usr/lib/eth-node-lodestar-testnet/bin/run-lodestar.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-lodestar-testnet/lodestar-testnet.conf