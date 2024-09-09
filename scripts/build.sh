#!/bin/bash

set -euo pipefail

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
ALLOWED_NETWORKS=(
    "mainnet"
    "testnet"
)

REBUILD=false
PACKAGE_DIR="$HOME/.pkg-builder/packages/bookworm"
ARCH=amd64
SERVE_DIR="$HOME/packages/"
NETWORK_CONFIG_VERSION=0.0.1-1
EL_SERVICE_VERSION=0.0.1-1
CL_SERVICE_VERSION=0.0.1-1
NETWORK=mainnet

display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --network mainnet|testnet, -n mainnet|testnet Name of network to build the eth-node packages"   
    echo "  --version, -v                 Displays the version and exits."
    exit 0
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --network|-n)
            NETWORK=("$2")
            shift 2
            ;;
        --help|-h)
            HELP=true
            shift
            ;;
        *)
            echo "Error: Unknown option $1"
            display_help
            ;;
    esac
done

if [[ " ${ALLOWED_NETWORKS[@]} " =~ " ${NETWORK} " ]]; then
    :
else
    display_help
fi

mkdir -p $SERVE_DIR

cd upcoming/bookworm/amd64

cd eth-node-$NETWORK/1.0.0-1
pkg-builder verify
cd ../..

# network configs, not the same as client configs
cd eth-node-$NETWORK-config/1.0.0-1
pkg-builder verify
cd ../..

# build client configs 
cd eth-node-config-$NETWORK/$NETWORK_CONFIG_VERSION
pkg-builder verify
cd ../..


for client in "${EL_CLIENTS[@]}"; do
    cd eth-node-$NETWORK-service-${client}/$CL_SERVICE_VERSION
    pkg-builder verify
    cd ../..

done

for client in "${CL_CLIENTS[@]}"; do
    cd eth-node-$NETWORK-service-${client}/$EL_SERVICE_VERSION
    pkg-builder verify
    cd ../..
done

cp_or_fail() {
    local sourcefile="$1"
    local destination="$2"

    if [ ! -f "$sourcefile" ]; then
        echo "Error: $sourcefile does not exist."
        return 1  
    fi

    cp "$sourcefile" "$destination"
    
    if [ $? -eq 0 ]; then
        echo "$sourcefile copied successfully."
    else
        echo "Error: Failed to copy the file."
        return 1
    fi
}

echo "Copying built binaries"

cp_or_fail "$PACKAGE_DIR/eth-node-$NETWORK-1.0.0-1/eth-node-${NETWORK}_1.0.0-1_$ARCH.deb" "$SERVE_DIR"
cp_or_fail "$PACKAGE_DIR/eth-node-$NETWORK-config-1.0.0-1/eth-node-$NETWORK-config_1.0.0-1_$ARCH.deb" "$SERVE_DIR"

# copy eth-node-config-{variant} configs
for client in "${EL_CLIENTS[@]}"; do
    cp_or_fail "$PACKAGE_DIR/eth-node-config-$NETWORK-$NETWORK_CONFIG_VERSION/eth-node-config-$NETWORK-${client}_${NETWORK_CONFIG_VERSION}_$ARCH.deb" "$SERVE_DIR"
done

for client in "${CL_CLIENTS[@]}"; do
    cp_or_fail "$PACKAGE_DIR/eth-node-config-$NETWORK-$NETWORK_CONFIG_VERSION/eth-node-config-$NETWORK-${client}_${NETWORK_CONFIG_VERSION}_$ARCH.deb" "$SERVE_DIR"
done

for client in "${CL_CLIENTS[@]}"; do
    cp_or_fail "$PACKAGE_DIR/eth-node-$NETWORK-service-${client}-$CL_SERVICE_VERSION/eth-node-$NETWORK-service-${client}_${EL_SERVICE_VERSION}_all.deb" "$SERVE_DIR"
done

for client in "${EL_CLIENTS[@]}"; do
    cp_or_fail "$PACKAGE_DIR/eth-node-$NETWORK-service-${client}-$EL_SERVICE_VERSION/eth-node-$NETWORK-service-${client}_${EL_SERVICE_VERSION}_all.deb" "$SERVE_DIR"
done

ls -al $SERVE_DIR

