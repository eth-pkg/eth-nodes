#!/bin/bash

set -E

EL_CLIENTS=(
    "besu"
    "erigon"
    "geth"
    "nethermind"
    "reth"
)

CL_CLIENTS=(
    "lighthouse"
    "lodestar"
    "nimbus-eth2"
    "prysm"
    "teku"
)

REBUILD=false
PACKAGE_DIR=$HOME/.pkg-builder/packages/bookworm
ARCH=amd64
SERVE_DIR=$HOME/debs/bookworm-testing
ETH_NODE_CONFIG_VERSION=0.0.1-1
ETH_MAINNET_SERVICE_EL_VERSION=0.0.1-1
ETH_MAINNET_SERVICE_CL_VERSION=0.0.1-1

# rm -rf $HOME/debs/bookworm-testing/*

cd eth-node-mainnet/1.0.0-1
pkg-builder verify
cd ../..

cd eth-node-mainnet-config/1.0.0-1
pkg-builder verify
cd ../..

cd eth-node-config/$ETH_NODE_CONFIG_VERSION
pkg-builder verify
cd ../..

cd eth-node-mainnet-service-cl/$ETH_MAINNET_SERVICE_CL_VERSION
pkg-builder verify
cd ../..

cd eth-node-mainnet-service-el/$ETH_MAINNET_SERVICE_EL_VERSION
pkg-builder verify
cd ../..


echo "Copy built binaries"

cp "$PACKAGE_DIR/eth-node-mainnet-1.0.0-1/eth-node-mainnet_1.0.0-1_$ARCH.deb" "$SERVE_DIR"
cp "$PACKAGE_DIR/eth-node-mainnet-config-1.0.0-1/eth-node-mainnet-config_1.0.0-1_$ARCH.deb" "$SERVE_DIR"
cp "$PACKAGE_DIR/eth-node-config-$ETH_NODE_CONFIG_VERSION/eth-node-config_$ETH_NODE_CONFIG_VERSION_$ARCH.deb" "$SERVE_DIR"
cp "$PACKAGE_DIR/eth-node-mainnet-service-config-$ETH_MAINNET_SERVICE_EL_VERSION/eth-node-mainnet-config-el_$ETH_MAINNET_SERVICE_EL_VERSION_$ARCH.deb" "$SERVE_DIR"
cp "$PACKAGE_DIR/eth-node-mainnet-service-config-cl-$ETH_MAINNET_SERVICE_CL_VERSION/eth-node-mainnet-config-cl_$ETH_MAINNET_SERVICE_CL_VERSION_$ARCH.deb" "$SERVE_DIR"

# copy eth-node-config-{variant} configs
for client in "${EL_CLIENTS[@]}"; do
    cp "$PACKAGE_DIR/eth-node-config-$ETH_NODE_CONFIG_VERSION/eth-node-config-${client}_$ETH_NODE_CONFIG_VERSION_$ARCH.deb" "$SERVE_DIR"
done

for client in "${CL_CLIENTS[@]}"; do
    cp "$PACKAGE_DIR/eth-node-config-$ETH_NODE_CONFIG_VERSION/eth-node-config-${client}_$ETH_NODE_CONFIG_VERSION_$ARCH.deb" "$SERVE_DIR"
done

for client in "${EL_CLIENTS[@]}"; do
    cp "$PACKAGE_DIR/eth-node-mainnet-service-el-$ETH_MAINNET_SERVICE_EL_VERSION/eth-node-mainnet-service-${client}_$ETH_MAINNET_SERVICE_EL_VERSION_$ARCH.deb" "$SERVE_DIR"
done

for client in "${CL_CLIENTS[@]}"; do
    cp "$PACKAGE_DIR/eth-node-mainnet-service-cl-$ETH_MAINNET_SERVICE_CL_VERSION/eth-node-mainnet-service-${client}_$ETH_MAINNET_SERVICE_EL_VERSION_$ARCH.deb" "$SERVE_DIR"
done

