#!/usr/bin/env bash 


exec /usr/lib/eth-node-erigon-testnet/bin/run-erigon.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-erigon-testnet/erigon-testnet.conf