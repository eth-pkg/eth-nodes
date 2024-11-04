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
    "regtest"
)

REBUILD=false
PACKAGE_DIR=$HOME/.pkg-builder/packages/noble
ARCH=amd64
SERVE_DIR=$HOME/debs/noble-testing
NETWORK_CONFIG_VERSION=0.0.2-1
EL_SERVICE_VERSION=0.0.2-1
CL_SERVICE_VERSION=0.0.2-1
NETWORK=regtest

display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --network mainnet|regtest, -n mainnet|regtest Name of network to build the eth-node packages"   
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

# rm -rf $HOME/debs/noble-testing/*

# cd eth-node-$NETWORK/0.0.2-1
# pkg-builder verify
# cd ../..

# # network configs, not the same as client configs
# cd eth-node-$NETWORK-config/0.0.2-1
# pkg-builder verify
# cd ../..


# for client in "${EL_CLIENTS[@]}"; do
#     cd eth-node-${client}-$NETWORK/$CL_SERVICE_VERSION
#     pkg-builder verify
#     cd ../..

# done

# for client in "${CL_CLIENTS[@]}"; do
#     cd eth-node-${client}-$NETWORK/$EL_SERVICE_VERSION
#     pkg-builder verify
#     cd ../..
# done

# for client in "${CL_CLIENTS[@]}"; do
#     cd eth-node-${client}-validator-$NETWORK/$EL_SERVICE_VERSION
#     pkg-builder verify
#     cd ../..
# done



echo "Copy built binaries"

mkdir -p $SERVE_DIR 
cp "$PACKAGE_DIR/eth-node-$NETWORK-0.0.2-1/eth-node-${NETWORK}_0.0.2-1_all.deb" "$SERVE_DIR"
cp "$PACKAGE_DIR/eth-node-$NETWORK-config-0.0.2-1/eth-node-$NETWORK-config_0.0.2-1_all.deb" "$SERVE_DIR"


for client in "${CL_CLIENTS[@]}"; do
    cp "$PACKAGE_DIR/eth-node-${client}-$NETWORK-$CL_SERVICE_VERSION/eth-node-${client}-${NETWORK}_${EL_SERVICE_VERSION}_all.deb" "$SERVE_DIR"
done

# for client in "${EL_CLIENTS[@]}"; do
#     cp "$PACKAGE_DIR/eth-node-${client}-$NETWORK-$EL_SERVICE_VERSION/eth-node-${client}-${NETWORK}_${EL_SERVICE_VERSION}_all.deb" "$SERVE_DIR"
# done


for client in "${CL_CLIENTS[@]}"; do
    cp "$PACKAGE_DIR/eth-node-${client}-validator-$NETWORK-$CL_SERVICE_VERSION/eth-node-${client}-validator-${NETWORK}_${CL_SERVICE_VERSION}_all.deb" "$SERVE_DIR"
done

