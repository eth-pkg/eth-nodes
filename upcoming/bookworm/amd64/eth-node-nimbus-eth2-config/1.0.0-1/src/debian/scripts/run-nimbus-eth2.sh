#!/usr/bin/env bash

set -e

display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --conf-file FILE, -e FILE   Path to .conf formatted configuration file."
    echo "  --help, -h                    Displays this help text and exits."
    echo "  --version, -v                 Displays the version and exits."
    exit 0
}

display_version() {
    local version=$(basename "$(dirname "$(realpath "$0")")")
    echo "$0 version $version"
    exit 0
}

CONFIG_FILES=()
HELP=false
VERSION=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
    --conf-file | -e)
        CONFIG_FILES+=("$2")
        shift 2
        ;;
    --help | -h)
        HELP=true
        shift
        ;;
    --version | -v)
        VERSION=true
        shift
        ;;
    *)
        echo "Error: Unknown option $1"
        display_help
        ;;
    esac
done

if [ "$HELP" = true ]; then
    display_help
fi

if [ "$VERSION" = true ]; then
    display_version
fi

if [[ ${#CONFIG_FILES[@]} -eq 0 ]]; then
    echo "Error: At least one --conf-file option is required"
    display_help
fi

for CONFIG_FILE in "${CONFIG_FILES[@]}"; do
    if [[ -f "$CONFIG_FILE" ]]; then
        echo "Starting with configuration from $CONFIG_FILE"
        source "$CONFIG_FILE"
    else
        echo "Error: Configuration file $CONFIG_FILE not found."
        exit 1
    fi
done

OPTIONS=""

add_option() {
    local option=$1
    local value=$2
    if [ -n "$value" ]; then
        if [ "$value" == "" ]; then
            OPTIONS="$OPTIONS $option"
        else
            OPTIONS="$OPTIONS $option=$value"
        fi
    fi
}

add_option "--config-file" "$NIMBUS_ETH2_CONFIG_FILE"
add_option "--log-level" "$NIMBUS_ETH2_LOG_LEVEL"
add_option "--log-file" "$NIMBUS_ETH2_LOG_FILE"
add_option "--network" "$NIMBUS_ETH2_NETWORK"
add_option "--data-dir" "$NIMBUS_ETH2_DATA_DIR"
add_option "--validators-dir" "$NIMBUS_ETH2_VALIDATORS_DIR"
add_option "--verifying-web3-signer-url" "$NIMBUS_ETH2_VERIFYING_WEB3_SIGNER_URL"
add_option "--proven-block-property" "$NIMBUS_ETH2_PROVEN_BLOCK_PROPERTY"
add_option "--web3-signer-url" "$NIMBUS_ETH2_WEB3_SIGNER_URL"
add_option "--web3-signer-update-interval" "$NIMBUS_ETH2_WEB3_SIGNER_UPDATE_INTERVAL"
add_option "--secrets-dir" "$NIMBUS_ETH2_SECRETS_DIR"
add_option "--wallets-dir" "$NIMBUS_ETH2_WALLETS_DIR"
add_option "--web3-url" "$NIMBUS_ETH2_WEB3_URL"
add_option "--el" "$NIMBUS_ETH2_EL"
add_option "--no-el" "$NIMBUS_ETH2_NO_EL"
add_option "--non-interactive" "$NIMBUS_ETH2_NON_INTERACTIVE"
add_option "--netkey-file" "$NIMBUS_ETH2_NETKEY_FILE"
add_option "--insecure-netkey-password" "$NIMBUS_ETH2_INSECURE_NETKEY_PASSWORD"
add_option "--agent-string" "$NIMBUS_ETH2_AGENT_STRING"
add_option "--subscribe-all-subnets" "$NIMBUS_ETH2_SUBSCRIBE_ALL_SUBNETS"
add_option "--num-threads" "$NIMBUS_ETH2_NUM_THREADS"
add_option "--jwt-secret" "$NIMBUS_ETH2_JWT_SECRET"
add_option "--bootstrap-node" "$NIMBUS_ETH2_BOOTSTRAP_NODE"
add_option "--bootstrap-file" "$NIMBUS_ETH2_BOOTSTRAP_FILE"
add_option "--listen-address" "$NIMBUS_ETH2_LISTEN_ADDRESS"
add_option "--tcp-port" "$NIMBUS_ETH2_TCP_PORT"
add_option "--udp-port" "$NIMBUS_ETH2_UDP_PORT"
add_option "--max-peers" "$NIMBUS_ETH2_MAX_PEERS"
add_option "--hard-max-peers" "$NIMBUS_ETH2_HARD_MAX_PEERS"
add_option "--nat" "$NIMBUS_ETH2_NAT"
add_option "--enr-auto-update" "$NIMBUS_ETH2_ENR_AUTO_UPDATE"
add_option "--weak-subjectivity-checkpoint" "$NIMBUS_ETH2_WEAK_SUBJECTIVITY_CHECKPOINT"
add_option "--external-beacon-api-url" "$NIMBUS_ETH2_EXTERNAL_BEACON_API_URL"
add_option "--sync-light-client" "$NIMBUS_ETH2_SYNC_LIGHT_CLIENT"
add_option "--trusted-block-root" "$NIMBUS_ETH2_TRUSTED_BLOCK_ROOT"
add_option "--trusted-state-root" "$NIMBUS_ETH2_TRUSTED_STATE_ROOT"
add_option "--finalized-checkpoint-state" "$NIMBUS_ETH2_FINALIZED_CHECKPOINT_STATE"
add_option "--genesis-state" "$NIMBUS_ETH2_GENESIS_STATE"
add_option "--genesis-state-url" "$NIMBUS_ETH2_GENESIS_STATE_URL"
add_option "--finalized-deposit-tree-snapshot" "$NIMBUS_ETH2_FINALIZED_DEPOSIT_TREE_SNAPSHOT"
add_option "--node-name" "$NIMBUS_ETH2_NODE_NAME"
add_option "--graffiti" "$NIMBUS_ETH2_GRAFFITI"
add_option "--metrics" "$NIMBUS_ETH2_METRICS"
add_option "--metrics-address" "$NIMBUS_ETH2_METRICS_ADDRESS"
add_option "--metrics-port" "$NIMBUS_ETH2_METRICS_PORT"
add_option "--status-bar" "$NIMBUS_ETH2_STATUS_BAR"
add_option "--status-bar-contents" "$NIMBUS_ETH2_STATUS_BAR_CONTENTS"
add_option "--rest" "$NIMBUS_ETH2_REST"
add_option "--rest-port" "$NIMBUS_ETH2_REST_PORT"
add_option "--rest-address" "$NIMBUS_ETH2_REST_ADDRESS"
add_option "--rest-allow-origin" "$NIMBUS_ETH2_REST_ALLOW_ORIGIN"
add_option "--rest-statecache-size" "$NIMBUS_ETH2_REST_STATECACHE_SIZE"
add_option "--rest-statecache-ttl" "$NIMBUS_ETH2_REST_STATECACHE_TTL"
add_option "--rest-request-timeout" "$NIMBUS_ETH2_REST_REQUEST_TIMEOUT"
add_option "--rest-max-body-size" "$NIMBUS_ETH2_REST_MAX_BODY_SIZE"
add_option "--rest-max-headers-size" "$NIMBUS_ETH2_REST_MAX_HEADERS_SIZE"
add_option "--keymanager" "$NIMBUS_ETH2_KEYMANAGER"
add_option "--keymanager-port" "$NIMBUS_ETH2_KEYMANAGER_PORT"
add_option "--keymanager-address" "$NIMBUS_ETH2_KEYMANAGER_ADDRESS"
add_option "--keymanager-allow-origin" "$NIMBUS_ETH2_KEYMANAGER_ALLOW_ORIGIN"
add_option "--keymanager-token-file" "$NIMBUS_ETH2_KEYMANAGER_TOKEN_FILE"
add_option "--light-client-data-serve" "$NIMBUS_ETH2_LIGHT_CLIENT_DATA_SERVE"
add_option "--light-client-data-import-mode" "$NIMBUS_ETH2_LIGHT_CLIENT_DATA_IMPORT_MODE"
add_option "--light-client-data-max-periods" "$NIMBUS_ETH2_LIGHT_CLIENT_DATA_MAX_PERIODS"
add_option "--in-process-validators" "$NIMBUS_ETH2_IN_PROCESS_VALIDATORS"
add_option "--discv5" "$NIMBUS_ETH2_DISCV5"
add_option "--dump" "$NIMBUS_ETH2_DUMP"
add_option "--direct-peer" "$NIMBUS_ETH2_DIRECT_PEER"
add_option "--doppelganger-detection" "$NIMBUS_ETH2_DOPPELGANGER_DETECTION"
add_option "--validator-monitor-auto" "$NIMBUS_ETH2_VALIDATOR_MONITOR_AUTO"
add_option "--validator-monitor-pubkey" "$NIMBUS_ETH2_VALIDATOR_MONITOR_PUBKEY"
add_option "--validator-monitor-details" "$NIMBUS_ETH2_VALIDATOR_MONITOR_DETAILS"
add_option "--suggested-fee-recipient" "$NIMBUS_ETH2_SUGGESTED_FEE_RECIPIENT"
add_option "--suggested-gas-limit" "$NIMBUS_ETH2_SUGGESTED_GAS_LIMIT"
add_option "--payload-builder" "$NIMBUS_ETH2_PAYLOAD_BUILDER"
add_option "--payload-builder-url" "$NIMBUS_ETH2_PAYLOAD_BUILDER_URL"
add_option "--local-block-value-boost" "$NIMBUS_ETH2_LOCAL_BLOCK_VALUE_BOOST"
add_option "--history" "$NIMBUS_ETH2_HISTORY"


echo "Using Options: nimbus_beacon_node $OPTIONS"

# hack to download state before starting client
if [ -n "$NIMBUS_ETH2_FINALIZED_CHECKPOINT_STATE" ]; then
    echo "Downloading checkpoint state for nimbus-eth2"
    echo "curl -o $NIMBUS_ETH2_FINALIZED_CHECKPOINT_STATE \
            -H 'Accept: application/octet-stream' \
            $BASE_CONFIG_CL_CHECKPPOINT_SYNC_URLr/eth/v2/debug/beacon/states/finalized"
    if [ "$NIMBUS_ETH2_FINALIZED_CHECKPOINT_STATE" != "" ]; then
        curl -o $NIMBUS_ETH2_FINALIZED_CHECKPOINT_STATE \
            -H 'Accept: application/octet-stream' \
            $BASE_CONFIG_CL_CHECKPPOINT_SYNC_URL/eth/v2/debug/beacon/states/finalized

    fi
fi

# on ci the postrm fails, so it not in path
exec /usr/lib/eth-node-nimbus-eth2/bin/nimbus_beacon_node $OPTIONS
