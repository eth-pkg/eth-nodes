#!/bin/bash

set -E

CLIENTS=(
    "besu"
    "erigon"
    "geth"
    "lighthouse"
    "lodestar"
    "nethermind"
    "nimbus-eth2"
    "prysm"
    "reth"
    "teku"
)

REBUILD=false
PACKAGE_DIR=$HOME/.pkg-builder/packages/bookworm
ARCH=amd64
SERVE_DIR=$HOME/debs/bookworm-testing

# rm -rf $HOME/debs/bookworm-testing/*

cd eth-node-mainnet/1.0.0-1
pkg-builder verify
cd ../..

cd eth-node-mainnet-config/1.0.0-1
pkg-builder verify
cd ../..

echo "Start building configs"

for client in "${CLIENTS[@]}"; do
    if [ -e "$PACKAGE_DIR/eth-node-config-$client-1.0.0-1/eth-node-mainnet-$client-1.0.0-1_$ARCH.deb" ] && [ "$REBUILD" == "false" ]; then
        echo "Skipping rebuild as file exists, and no REBUILD flag specified"
    else
        cd eth-node-config-$client/1.0.0-1
        pkg-builder verify
        cd ../..
    fi
done

echo "Start building services"

for client in "${CLIENTS[@]}"; do
    if [ -e "$PACKAGE_DIR/eth-node-mainnet-service-$client-1.0.0-1/eth-node-service-$client-1.0.0-1_$ARCH.deb" ] && [ "$REBUILD" == "false" ]; then
        echo "Skipping rebuild as file exists, and no REBUILD flag specified"
    else
        cd eth-node-mainnet-service-$client/1.0.0-1
        pkg-builder verify
        cd ../..
    fi
done

echo "Copy built binaries"

cp "$PACKAGE_DIR/eth-node-mainnet-1.0.0-1/eth-node-mainnet_1.0.0-1_$ARCH.deb" "$SERVE_DIR"
cp "$PACKAGE_DIR/eth-node-mainnet-config-1.0.0-1/eth-node-mainnet-config_1.0.0-1_$ARCH.deb" "$SERVE_DIR"

for client in "${CLIENTS[@]}"; do
    cp "$PACKAGE_DIR/eth-node-config-$client-1.0.0-1/eth-node-config-${client}_1.0.0-1_$ARCH.deb" "$SERVE_DIR"
done

for client in "${CLIENTS[@]}"; do
    cp "$PACKAGE_DIR/eth-node-mainnet-service-$client-1.0.0-1/eth-node-mainnet-service-${client}_1.0.0-1_all.deb" "$SERVE_DIR"
done
