#!/usr/bin/env bash 


exec /usr/lib/eth-node-geth-testnet/bin/run-geth.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-geth-testnet/geth-testnet.conf