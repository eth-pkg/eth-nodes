#!/usr/bin/env bash 


exec /usr/lib/eth-node-prysm-validator-testnet/bin/run-prysm-validator.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-prysm-validator-testnet/prysm-validator.conf