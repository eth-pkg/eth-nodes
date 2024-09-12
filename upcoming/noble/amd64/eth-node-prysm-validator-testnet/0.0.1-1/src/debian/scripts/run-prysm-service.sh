#!/usr/bin/env bash 


exec /usr/lib/eth-node-prysm-testnet/bin/run-prysm.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-prysm-testnet/prysm-testnet.conf