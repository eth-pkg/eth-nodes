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

append_option() {
    local option=$1
    local value=$2
    if [ -n "$value" ]; then
        OPTIONS="$OPTIONS $option $value"
    fi
}

append_flag() {
    local option=$1
    local value=$2
    if [ "$value" = "true" ]; then
        OPTIONS="$OPTIONS $option"
    fi
}

# weak subjectivity
append_option "--checkpointSyncUrl" "$LODESTAR_CHECKPOINT_SYNC_URL"
append_option "--checkpointState" "$LODESTAR_CHECKPOINT_STATE"
append_option "--wssCheckpoint" "$LODESTAR_WSS_CHECKPOINT"
append_flag "--forceCheckpointSync" "$LODESTAR_FORCE_CHECKPOINT_SYNC"

# api
append_flag "--rest" "$LODESTAR_REST"
append_option "--rest.namespace" "$LODESTAR_REST_NAMESPACE"
append_option "--rest.cors" "$LODESTAR_REST_CORS"
append_option "--rest.address" "$LODESTAR_REST_ADDRESS"
append_option "--rest.port" "$LODESTAR_REST_PORT"
append_flag "--rest.swaggerUI" "$LODESTAR_REST_SWAGGER_UI"

# chain
append_option "--suggestedFeeRecipient" "$LODESTAR_SUGGESTED_FEE_RECIPIENT"
append_flag "--emitPayloadAttributes" "$LODESTAR_EMIT_PAYLOAD_ATTRIBUTES"
append_option "--chain.archiveBlobEpochs" "$LODESTAR_CHAIN_ARCHIVE_BLOB_EPOCHS"

# eth1
append_flag "--eth1" "$LODESTAR_ETH1"
append_option "--eth1.providerUrls" "$LODESTAR_ETH1_PROVIDER_URLS"

# execution
append_option "--execution.urls" "$LODESTAR_EXECUTION_URLS"
append_option "--execution.timeout" "$LODESTAR_EXECUTION_TIMEOUT"
append_option "--execution.retries" "$LODESTAR_EXECUTION_RETRIES"
append_option "--execution.retryDelay" "$LODESTAR_EXECUTION_RETRY_DELAY"
append_flag "--execution.engineMock" "$LODESTAR_EXECUTION_ENGINE_MOCK"
append_option "--jwtSecret" "$LODESTAR_JWT_SECRET"
append_option "--jwtId" "$LODESTAR_JWT_ID"

# builder
append_flag "--builder" "$LODESTAR_BUILDER"
append_option "--builder.url" "$LODESTAR_BUILDER_URL"
append_option "--builder.timeout" "$LODESTAR_BUILDER_TIMEOUT"
append_option "--builder.faultInspectionWindow" "$LODESTAR_BUILDER_FAULT_INSPECTION_WINDOW"
append_option "--builder.allowedFaults" "$LODESTAR_BUILDER_ALLOWED_FAULTS"

# metrics
append_flag "--metrics" "$LODESTAR_METRICS"
append_option "--metrics.port" "$LODESTAR_METRICS_PORT"
append_option "--metrics.address" "$LODESTAR_METRICS_ADDRESS"

# monitoring
append_option "--monitoring.endpoint" "$LODESTAR_MONITORING_ENDPOINT"
append_option "--monitoring.interval" "$LODESTAR_MONITORING_INTERVAL"

# network
append_flag "--discv5" "$LODESTAR_DISCV5"
append_option "--listenAddress" "$LODESTAR_LISTEN_ADDRESS"
append_option "--port" "$LODESTAR_PORT"
append_option "--discoveryPort" "$LODESTAR_DISCOVERY_PORT"
append_option "--listenAddress6" "$LODESTAR_LISTEN_ADDRESS6"
append_option "--port6" "$LODESTAR_PORT6"
append_option "--discoveryPort6" "$LODESTAR_DISCOVERY_PORT6"
append_option "--bootnodes" "$LODESTAR_BOOTNODES"
append_option "--targetPeers" "$LODESTAR_TARGET_PEERS"
append_flag "--subscribeAllSubnets" "$LODESTAR_SUBSCRIBE_ALL_SUBNETS"
append_flag "--disablePeerScoring" "$LODESTAR_DISABLE_PEER_SCORING"
append_flag "--mdns" "$LODESTAR_MDNS"

# enr
append_option "--enr.ip" "$LODESTAR_ENR_IP"
append_option "--enr.tcp" "$LODESTAR_ENR_TCP"
append_option "--enr.udp" "$LODESTAR_ENR_UDP"
append_option "--enr.ip6" "$LODESTAR_ENR_IP6"
append_option "--enr.tcp6" "$LODESTAR_ENR_TCP6"
append_option "--enr.udp6" "$LODESTAR_ENR_UDP6"
append_flag "--nat" "$LODESTAR_NAT"

# options
append_option "--dataDir" "$LODESTAR_DATA_DIR"
append_option "--network" "$LODESTAR_NETWORK"
append_option "--paramsFile" "$LODESTAR_PARAMS_FILE"
append_option "--terminal-total-difficulty-override" "$LODESTAR_TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--terminal-block-hash-override" "$LODESTAR_TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-block-hash-epoch-override" "$LODESTAR_TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--rcConfig" "$LODESTAR_RC_CONFIG"
append_flag "--private" "$LODESTAR_PRIVATE"
append_flag "--validatorMonitorLogs" "$LODESTAR_VALIDATOR_MONITOR_LOGS"
append_flag "--disableLightClientServer" "$LODESTAR_DISABLE_LIGHT_CLIENT_SERVER"
append_option "--logLevel" "$LODESTAR_LOG_LEVEL"
append_option "--logFile" "$LODESTAR_LOG_FILE"
append_option "--logFileLevel" "$LODESTAR_LOG_FILE_LEVEL"
append_option "--logFileDailyRotate" "$LODESTAR_LOG_FILE_DAILY_ROTATE"

# if [ "$LODESTAR_CLI_DEV_REST_NAMESPACE" == "*" ]; then
#     OPTIONS="$OPTIONS --rest.namespace '*'"
# else
append_option "--rest.namespace" "$LODESTAR_LODESTAR_CLI_DEV_REST_NAMESPACE"
# fi

# TODO lodestar undocumented options
append_option "--eth1.depositContractDeployBlock" "$LODESTAR_ETH1_DEPOSIT_CONTRACT_DEPLOY_BLOCK"
append_option "--network.connectToDiscv5Bootnodes" "$LODESTAR_NETWORK_CONNECT_TO_DISCV5_BOOTNODES"
append_option "--genesisStateFile" "$LODESTAR_GENESIS_STATE_FILE"

append_option "--chain.persistInvalidSszObjects" "true"

echo "Starting lodestar beacon $OPTIONS"

# on ci the postrm fails, so it not in path
exec /usr/lib/eth-node-lodestar/bin/lodestar beacon $OPTIONS
