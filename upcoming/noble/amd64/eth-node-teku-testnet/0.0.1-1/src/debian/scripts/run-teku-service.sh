#!/usr/bin/env bash 


exec /usr/lib/eth-node-teku-testnet/bin/run-teku.sh \
    --conf-file /etc/eth-node-testnet/conf.d/testnet.conf \
    --conf-file /etc/eth-node-teku-testnet/teku-testnet.conf