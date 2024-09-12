#!/usr/bin/env bash 


exec /usr/lib/eth-node-nethermind-testnet/bin/run-nethermind.sh \
    --conf-file /etc/eth-node-testnet-config/testnet.conf \
    --conf-file /etc/eth-node-nethermind-testnet/nethermind-testnet.conf