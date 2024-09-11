#!/usr/bin/env bash 


exec /usr/lib/eth-node-besu-testnet/bin/run-besu.sh \
    --conf-file /etc/eth-node-testnet/conf.d/testnet.conf \
    --conf-file /etc/eth-node-besu-testnet/besu-testnet.conf