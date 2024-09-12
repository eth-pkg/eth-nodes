#!/usr/bin/env bash 


exec /usr/lib/eth-node-reth-testnet/bin/run-reth.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-reth-testnet/reth-testnet.conf