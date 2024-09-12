#!/usr/bin/env bash 


exec /usr/lib/eth-node-lighthouse-validator-testnet/bin/run-lighthouse-validator.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-lighthouse-validator-testnet/lighthouse-validator.conf