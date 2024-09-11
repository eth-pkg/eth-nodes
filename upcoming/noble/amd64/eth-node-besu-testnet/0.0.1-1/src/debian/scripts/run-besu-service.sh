#!/usr/bin/env bash 


exec /usr/lib/eth-node-besu-testnet/bin/run-besu.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-besu-testnet/besu-testnet.conf