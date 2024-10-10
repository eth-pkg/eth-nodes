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
        --conf-file|-e)
            CONFIG_FILES+=("$2")
            shift 2
            ;;
        --help|-h)
            HELP=true
            shift
            ;;
        --version|-v)
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
    OPTIONS="$OPTIONS $option=$value"
  fi
}

append_flag(){
 local option=$1
  local value=$2
  if [ "$value" = "true" ]; then
    OPTIONS="$OPTIONS $option"
  fi 
}


append_flag "--accept-terms-of-use" "$PRSYM_CLI_ACCEPT_TERMS_OF_USE"
append_flag "--disable-monitoring" "$PRSYM_CLI_DISABLE_MONITORING"
append_flag "--enable-tracing" "$PRSYM_CLI_ENABLE_TRACING"
append_flag "--enable-debug-rpc-endpoints" "$PRSYM_CLI_ENABLE_DEBUG_RPC_ENDPOINTS"
append_flag "--enable-experimental-backfill" "$PRSYM_CLI_ENABLE_EXPERIMENTAL_BACKFILL"
append_flag "--historical-slasher-node" "$PRSYM_CLI_HISTORICAL_SLASHER_NODE"
append_flag "--subscribe-all-subnets" "$PRSYM_CLI_SUBSCRIBE_ALL_SUBNETS"
append_flag "--enable-upnp" "$PRSYM_CLI_ENABLE_UPNP"
append_flag "--p2p-static-id" "$PRSYM_CLI_P2P_STATIC_ID"
append_flag "--blob-save-fsync" "$PRSYM_CLI_BLOB_SAVE_FSYNC"
append_flag "--disable-broadcast-slashings" "$PRSYM_CLI_DISABLE_BROADCAST_SLASHINGS"
append_flag "--disable-eip-4881" "$PRSYM_CLI_DISABLE_EIP_4881"
append_flag "--disable-grpc-connection-logging" "$PRSYM_CLI_DISABLE_GRPC_CONNECTION_LOGGING"
append_flag "--disable-peer-scorer" "$PRSYM_CLI_DISABLE_PEER_SCORER"
append_flag "--disable-registration-cache" "$PRSYM_CLI_DISABLE_REGISTRATION_CACHE"
append_flag "--disable-resource-manager" "$PRSYM_CLI_DISABLE_RESOURCE_MANAGER"
append_flag "--disable-staking-contract-check" "$PRSYM_CLI_DISABLE_STAKING_CONTRACT_CHECK"
append_flag "--disable-verbose-sig-verification" "$PRSYM_CLI_DISABLE_VERBOSE_SIG_VERIFICATION"
append_flag "--enable-experimental-state" "$PRSYM_CLI_ENABLE_EXPERIMENTAL_STATE"
append_flag "--enable-full-ssz-data-logging" "$PRSYM_CLI_ENABLE_FULL_SSZ_DATA_LOGGING"
append_flag "--enable-historical-state-representation" "$PRSYM_CLI_ENABLE_HISTORICAL_STATE_REPRESENTATION"
append_flag "--enable-lightclient" "$PRSYM_CLI_ENABLE_LIGHTCLIENT"
append_flag "--holesky" "$PRSYM_CLI_HOLESKY"
append_flag "--interop-write-ssz-state-transitions" "$PRSYM_CLI_INTEROP_WRITE_SSZ_STATE_TRANSITIONS"
append_flag "--mainnet" "$PRSYM_CLI_MAINNET"
append_flag "--prater" "$PRSYM_CLI_PRATER"
append_flag "--prepare-all-payloads" "$PRSYM_CLI_PREPARE_ALL_PAYLOADS"
append_flag "--save-full-execution-payloads" "$PRSYM_CLI_SAVE_FULL_EXECUTION_PAYLOADS"
append_flag "--save-invalid-blob-temp" "$PRSYM_CLI_SAVE_INVALID_BLOB_TEMP"
append_flag "--save-invalid-block-temp" "$PRSYM_CLI_SAVE_INVALID_BLOCK_TEMP"
append_flag "--sepolia" "$PRSYM_CLI_SEPOLIA"
append_flag "--slasher" "$PRSYM_CLI_SLASHER"
append_flag "--interop-eth1data-votes" "$PRSYM_CLI_INTEROP_ETH1DATA_VOTES"
append_flag "--force-clear-db" "$PRSYM_CLI_FORCE_CLEAR_DB"

append_option "--api-timeout" "$PRSYM_CLI_API_TIMEOUT"
append_option "--bootstrap-node" "$PRSYM_CLI_BOOTSTRAP_NODE"
append_option "--chain-config-file" "$PRSYM_CLI_CHAIN_CONFIG_FILE"
append_option "--clear-db" "$PRSYM_CLI_CLEAR_DB"
append_option "--config-file" "$PRSYM_CLI_CONFIG_FILE"
append_option "--datadir" "$PRSYM_CLI_DATADIR"
append_option "--e2e-config" "$PRSYM_CLI_E2E_CONFIG"
append_option "--grpc-max-msg-size" "$PRSYM_CLI_GRPC_MAX_MSG_SIZE"
append_option "--max-goroutines" "$PRSYM_CLI_MAX_GOROUTINES"
append_option "--minimal-config" "$PRSYM_CLI_MINIMAL_CONFIG"
append_option "--monitor-indices" "$PRSYM_CLI_MONITOR_INDICES"
append_option "--monitoring-host" "$PRSYM_CLI_MONITORING_HOST"
append_option "--monitoring-port" "$PRSYM_CLI_MONITORING_PORT"
append_option "--no-discovery" "$PRSYM_CLI_NO_DISCOVERY"
append_option "--p2p-tcp-port" "$PRSYM_CLI_P2P_TCP_PORT"
append_option "--p2p-udp-port" "$PRSYM_CLI_P2P_UDP_PORT"
append_option "--relay-node" "$PRSYM_CLI_RELAY_NODE"
append_option "--restore-source-file" "$PRSYM_CLI_RESTORE_SOURCE_FILE"
append_option "--restore-target-dir" "$PRSYM_CLI_RESTORE_TARGET_DIR"
append_option "--rpc-max-page-size" "$PRSYM_CLI_RPC_MAX_PAGE_SIZE"
append_option "--trace-sample-fraction" "$PRSYM_CLI_TRACE_SAMPLE_FRACTION"
append_option "--tracing-endpoint" "$PRSYM_CLI_TRACING_ENDPOINT"
append_option "--tracing-process-name" "$PRSYM_CLI_TRACING_PROCESS_NAME"
append_option "--verbosity" "$PRSYM_CLI_VERBOSITY"
append_option "--blockprofilerate" "$PRSYM_CLI_BLOCKPROFILERATE"
append_option "--cpuprofile" "$PRSYM_CLI_CPUPROFILE"
append_option "--memprofilerate" "$PRSYM_CLI_MEMPROFILERATE"
append_option "--mutexprofilefraction" "$PRSYM_CLI_MUTEXPROFILEFRACTION"
append_option "--pprof" "$PRSYM_CLI_PPROF"
append_option "--pprofaddr" "$PRSYM_CLI_PPROFADDR"
append_option "--pprofport" "$PRSYM_CLI_PPROFPORT"
append_option "--trace" "$PRSYM_CLI_TRACE"
append_option "--backfill-batch-size" "$PRSYM_CLI_BACKFILL_BATCH_SIZE"
append_option "--backfill-oldest-slot" "$PRSYM_CLI_BACKFILL_OLDEST_SLOT"
append_option "--backfill-worker-count" "$PRSYM_CLI_BACKFILL_WORKER_COUNT"
append_option "--blob-batch-limit" "$PRSYM_CLI_BLOB_BATCH_LIMIT"
append_option "--blob-batch-limit-burst-factor" "$PRSYM_CLI_BLOB_BATCH_LIMIT_BURST_FACTOR"
append_option "--blob-path" "$PRSYM_CLI_BLOB_PATH"
append_option "--blob-retention-epochs" "$PRSYM_CLI_BLOB_RETENTION_EPOCHS"
append_option "--block-batch-limit" "$PRSYM_CLI_BLOCK_BATCH_LIMIT"
append_option "--block-batch-limit-burst-factor" "$PRSYM_CLI_BLOCK_BATCH_LIMIT_BURST_FACTOR"
append_option "--chain-id" "$PRSYM_CLI_CHAIN_ID"
append_option "--checkpoint-block" "$PRSYM_CLI_CHECKPOINT_BLOCK"
append_option "--checkpoint-state" "$PRSYM_CLI_CHECKPOINT_STATE"
append_option "--checkpoint-sync-url" "$PRSYM_CLI_CHECKPOINT_SYNC_URL"
append_option "--contract-deployment-block" "$PRSYM_CLI_CONTRACT_DEPLOYMENT_BLOCK"
append_option "--deposit-contract" "$PRSYM_CLI_DEPOSIT_CONTRACT"
append_option "--disable-grpc-gateway" "$PRSYM_CLI_DISABLE_GRPC_GATEWAY"
append_option "--engine-endpoint-timeout-seconds" "$PRSYM_CLI_ENGINE_ENDPOINT_TIMEOUT_SECONDS"
append_option "--eth1-header-req-limit" "$PRSYM_CLI_ETH1_HEADER_REQ_LIMIT"
append_option "--execution-endpoint" "$PRSYM_CLI_EXECUTION_ENDPOINT"
append_option "--execution-headers" "$PRSYM_CLI_EXECUTION_HEADERS"
append_option "--gc-percent" "$PRSYM_CLI_GC_PERCENT"
append_option "--genesis-beacon-api-url" "$PRSYM_CLI_GENESIS_BEACON_API_URL"
append_option "--genesis-state" "$PRSYM_CLI_GENESIS_STATE"
append_option "--grpc-gateway-corsdomain" "$PRSYM_CLI_GRPC_GATEWAY_CORSDOMAIN"
append_option "--grpc-gateway-host" "$PRSYM_CLI_GRPC_GATEWAY_HOST"
append_option "--grpc-gateway-port" "$PRSYM_CLI_GRPC_GATEWAY_PORT"
append_option "--http-mev-relay" "$PRSYM_CLI_HTTP_MEV_RELAY"
append_option "--http-modules" "$PRSYM_CLI_HTTP_MODULES"
append_option "--jwt-id" "$PRSYM_CLI_JWT_ID"
append_option "--jwt-secret" "$PRSYM_CLI_JWT_SECRET"
append_option "--local-block-value-boost" "$PRSYM_CLI_LOCAL_BLOCK_VALUE_BOOST"
append_option "--max-builder-consecutive-missed-slots" "$PRSYM_CLI_MAX_BUILDER_CONSECUTIVE_MISSED_SLOTS"
append_option "--max-builder-epoch-missed-slots" "$PRSYM_CLI_MAX_BUILDER_EPOCH_MISSED_SLOTS"
append_option "--minimum-peers-per-subnet" "$PRSYM_CLI_MINIMUM_PEERS_PER_SUBNET"
append_option "--network-id" "$PRSYM_CLI_NETWORK_ID"
append_option "--rpc-host" "$PRSYM_CLI_RPC_HOST"
append_option "--rpc-port" "$PRSYM_CLI_RPC_PORT"
append_option "--slasher-datadir" "$PRSYM_CLI_SLASHER_DATADIR"
append_option "--slots-per-archive-point" "$PRSYM_CLI_SLOTS_PER_ARCHIVE_POINT"
append_option "--tls-cert" "$PRSYM_CLI_TLS_CERT"
append_option "--tls-key" "$PRSYM_CLI_TLS_KEY"
append_option "--weak-subjectivity-checkpoint" "$PRSYM_CLI_WEAK_SUBJECTIVITY_CHECKPOINT"
append_option "--suggested-fee-recipient" "$PRSYM_CLI_SUGGESTED_FEE_RECIPIENT"
append_option "--terminal-block-hash-epoch-override" "$PRSYM_CLI_TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--terminal-block-hash-override" "$PRSYM_CLI_TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-total-difficulty-override" "$PRSYM_CLI_TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--min-sync-peers" "$PRSYM_CLI_MIN_SYNC_PEERS"
append_option "--p2p-allowlist" "$PRSYM_CLI_P2P_ALLOWLIST"
append_option "--p2p-denylist" "$PRSYM_CLI_P2P_DENYLIST"
append_option "--p2p-host-dns" "$PRSYM_CLI_P2P_HOST_DNS"
append_option "--p2p-host-ip" "$PRSYM_CLI_P2P_HOST_IP"
append_option "--p2p-local-ip" "$PRSYM_CLI_P2P_LOCAL_IP"
append_option "--p2p-max-peers" "$PRSYM_CLI_P2P_MAX_PEERS"
append_option "--p2p-metadata" "$PRSYM_CLI_P2P_METADATA"
append_option "--p2p-priv-key" "$PRSYM_CLI_P2P_PRIV_KEY"
append_option "--peer" "$PRSYM_CLI_PEER"
append_option "--pubsub-queue-size" "$PRSYM_CLI_PUBSUB_QUEUE_SIZE"
append_option "--log-file" "$PRSYM_CLI_LOG_FILE"
append_option "--log-format" "$PRSYM_CLI_LOG_FORMAT"

append_option "--interop-genesis-time" "$PRSYM_CLI_INTEROP_GENESIS_TIME"
append_option "--interop-num-validators" "$PRSYM_CLI_INTEROP_NUM_VALIDATORS"

echo "Using Options: beacon-chain $OPTIONS"

# on ci the postrm fails, so it not in path
exec /usr/lib/eth-node-prysm/bin/beacon-chain $OPTIONS