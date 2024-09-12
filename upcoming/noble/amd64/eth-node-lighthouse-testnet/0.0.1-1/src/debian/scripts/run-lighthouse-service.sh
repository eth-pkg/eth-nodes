#!/usr/bin/env bash 


exec /usr/lib/eth-node-lighthouse-testnet/bin/run-lighthouse.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-lighthouse-testnet/lighthouse-testnet.conf