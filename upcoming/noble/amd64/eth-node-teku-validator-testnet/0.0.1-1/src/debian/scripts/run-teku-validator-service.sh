#!/usr/bin/env bash 


exec /usr/lib/eth-node-teku-validator-testnet/bin/run-teku-validator.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-teku-validator-testnet/teku-validator.conf