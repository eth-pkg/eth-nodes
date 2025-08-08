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
        OPTIONS="$OPTIONS $option=$value"
    fi
}

append_flag() {
    local option=$1
    local value=$2
    if [ "$value" = "true" ]; then
        OPTIONS="$OPTIONS $option"
    fi
}

# Global options
append_flag "--accept-terms-of-use" "$PRYSM_ACCEPT_TERMS_OF_USE"
append_option "--api-timeout" "$PRYSM_API_TIMEOUT"
append_option "--bootstrap-node" "$PRYSM_BOOTSTRAP_NODE"
append_option "--chain-config-file" "$PRYSM_CHAIN_CONFIG_FILE"
append_flag "--clear-db" "$PRYSM_CLEAR_DB"
append_option "--config-file" "$PRYSM_CONFIG_FILE"
append_option "--datadir" "$PRYSM_DATADIR"
append_flag "--disable-monitoring" "$PRYSM_DISABLE_MONITORING"
append_flag "--e2e-config" "$PRYSM_E2E_CONFIG"
append_flag "--enable-tracing" "$PRYSM_ENABLE_TRACING"
append_flag "--force-clear-db" "$PRYSM_FORCE_CLEAR_DB"
append_option "--grpc-max-msg-size" "$PRYSM_GRPC_MAX_MSG_SIZE"
append_option "--max-goroutines" "$PRYSM_MAX_GOROUTINES"
append_flag "--minimal-config" "$PRYSM_MINIMAL_CONFIG"
append_option "--monitor-indices" "$PRYSM_MONITOR_INDICES"
append_option "--monitoring-host" "$PRYSM_MONITORING_HOST"
append_option "--monitoring-port" "$PRYSM_MONITORING_PORT"
append_flag "--no-discovery" "$PRYSM_NO_DISCOVERY"
append_option "--p2p-quic-port" "$PRYSM_P2P_QUIC_PORT"
append_option "--p2p-tcp-port" "$PRYSM_P2P_TCP_PORT"
append_option "--p2p-udp-port" "$PRYSM_P2P_UDP_PORT"
append_option "--relay-node" "$PRYSM_RELAY_NODE"
append_option "--restore-source-file" "$PRYSM_RESTORE_SOURCE_FILE"
append_option "--restore-target-dir" "$PRYSM_RESTORE_TARGET_DIR"
append_option "--rpc-max-page-size" "$PRYSM_RPC_MAX_PAGE_SIZE"
append_option "--trace-sample-fraction" "$PRYSM_TRACE_SAMPLE_FRACTION"
append_option "--tracing-endpoint" "$PRYSM_TRACING_ENDPOINT"
append_option "--tracing-process-name" "$PRYSM_TRACING_PROCESS_NAME"
append_option "--verbosity" "$PRYSM_VERBOSITY"

# debug options
append_option "--blockprofilerate" "$PRYSM_BLOCKPROFILERATE"
append_option "--cpuprofile" "$PRYSM_CPUPROFILE"
append_option "--memprofilerate" "$PRYSM_MEMPROFILERATE"
append_option "--mutexprofilefraction" "$PRYSM_MUTEXPROFILEFRACTION"
append_flag "--pprof" "$PRYSM_PPROF"
append_option "--pprofaddr" "$PRYSM_PPROFADDR"
append_option "--pprofport" "$PRYSM_PPROFPORT"
append_option "--trace" "$PRYSM_TRACE"

# beacon chain options
append_option "--backfill-batch-size" "$PRYSM_BACKFILL_BATCH_SIZE"
append_option "--backfill-oldest-slot" "$PRYSM_BACKFILL_OLDEST_SLOT"
append_option "--backfill-worker-count" "$PRYSM_BACKFILL_WORKER_COUNT"
append_option "--blob-batch-limit" "$PRYSM_BLOB_BATCH_LIMIT"
append_option "--blob-batch-limit-burst-factor" "$PRYSM_BLOB_BATCH_LIMIT_BURST_FACTOR"
append_option "--blob-path" "$PRYSM_BLOB_PATH"
append_option "--blob-retention-epochs" "$PRYSM_BLOB_RETENTION_EPOCHS"
append_option "--block-batch-limit" "$PRYSM_BLOCK_BATCH_LIMIT"
append_option "--block-batch-limit-burst-factor" "$PRYSM_BLOCK_BATCH_LIMIT_BURST_FACTOR"
append_option "--chain-id" "$PRYSM_CHAIN_ID"
append_option "--checkpoint-block" "$PRYSM_CHECKPOINT_BLOCK"
append_option "--checkpoint-state" "$PRYSM_CHECKPOINT_STATE"
append_option "--checkpoint-sync-url" "$PRYSM_CHECKPOINT_SYNC_URL"
append_option "--contract-deployment-block" "$PRYSM_CONTRACT_DEPLOYMENT_BLOCK"
append_option "--deposit-contract" "$PRYSM_DEPOSIT_CONTRACT"
append_flag "--disable-debug-rpc-endpoints" "$PRYSM_DISABLE_DEBUG_RPC_ENDPOINTS"
append_flag "--disable-grpc-gateway" "$PRYSM_DISABLE_GRPC_GATEWAY"
append_flag "--enable-experimental-backfill" "$PRYSM_ENABLE_EXPERIMENTAL_BACKFILL"
append_option "--engine-endpoint-timeout-seconds" "$PRYSM_ENGINE_ENDPOINT_TIMEOUT_SECONDS"
append_option "--eth1-header-req-limit" "$PRYSM_ETH1_HEADER_REQ_LIMIT"
append_option "--execution-endpoint" "$PRYSM_EXECUTION_ENDPOINT"
append_option "--execution-headers" "$PRYSM_EXECUTION_HEADERS"
append_option "--gc-percent" "$PRYSM_GC_PERCENT"
append_option "--genesis-beacon-api-url" "$PRYSM_GENESIS_BEACON_API_URL"
append_option "--genesis-state" "$PRYSM_GENESIS_STATE"
append_option "--grpc-gateway-corsdomain" "$PRYSM_GRPC_GATEWAY_CORSDOMAIN"
append_option "--grpc-gateway-host" "$PRYSM_GRPC_GATEWAY_HOST"
append_option "--grpc-gateway-port" "$PRYSM_GRPC_GATEWAY_PORT"
append_flag "--historical-slasher-node" "$PRYSM_HISTORICAL_SLASHER_NODE"
append_option "--http-host" "$PRYSM_HTTP_HOST"
append_option "--http-cors-domain" "$PRYSM_HTTP_CORS_DOMAIN"
append_option "--http-port" "$PRYSM_HTTP_PORT"
append_option "--http-mev-relay" "$PRYSM_HTTP_MEV_RELAY"
append_option "--http-modules" "$PRYSM_HTTP_MODULES"
append_flag "--interop-eth1data-votes" "$PRYSM_INTEROP_ETH1DATA_VOTES"
append_option "--jwt-id" "$PRYSM_JWT_ID"
append_option "--jwt-secret" "$PRYSM_JWT_SECRET"
append_option "--local-block-value-boost" "$PRYSM_LOCAL_BLOCK_VALUE_BOOST"
append_option "--max-builder-consecutive-missed-slots" "$PRYSM_MAX_BUILDER_CONSECUTIVE_MISSED_SLOTS"
append_option "--max-builder-epoch-missed-slots" "$PRYSM_MAX_BUILDER_EPOCH_MISSED_SLOTS"
append_option "--max-concurrent-dials" "$PRYSM_MAX_CONCURRENT_DIALS"
append_option "--min-builder-bid" "$PRYSM_MIN_BUILDER_BID"
append_option "--min-builder-to-local-difference" "$PRYSM_MIN_BUILDER_TO_LOCAL_DIFFERENCE"
append_option "--minimum-peers-per-subnet" "$PRYSM_MINIMUM_PEERS_PER_SUBNET"
append_option "--network-id" "$PRYSM_NETWORK_ID"
append_option "--rpc-host" "$PRYSM_RPC_HOST"
append_option "--rpc-port" "$PRYSM_RPC_PORT"
append_option "--slasher-datadir" "$PRYSM_SLASHER_DATADIR"
append_option "--slots-per-archive-point" "$PRYSM_SLOTS_PER_ARCHIVE_POINT"
append_flag "--subscribe-all-subnets" "$PRYSM_SUBSCRIBE_ALL_SUBNETS"
append_option "--tls-cert" "$PRYSM_TLS_CERT"
append_option "--tls-key" "$PRYSM_TLS_KEY"
append_option "--weak-subjectivity-checkpoint" "$PRYSM_WEAK_SUBJECTIVITY_CHECKPOINT"

# merge options
append_option "--suggested-fee-recipient" "$PRYSM_SUGGESTED_FEE_RECIPIENT"
append_option "--terminal-block-hash-epoch-override" "$PRYSM_TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--terminal-block-hash-override" "$PRYSM_TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-total-difficulty-override" "$PRYSM_TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"

# p2p OPTIONS:
append_flag "--enable-upnp" "$PRYSM_ENABLE_UPNP"
append_option "--min-sync-peers" "$PRYSM_MIN_SYNC_PEERS"
append_option "--p2p-allowlist" "$PRYSM_P2P_ALLOWLIST"
append_option "--p2p-denylist" "$PRYSM_P2P_DENYLIST"
append_option "--p2p-host-dns" "$PRYSM_P2P_HOST_DNS"
append_option "--p2p-host-ip" "$PRYSM_P2P_HOST_IP"
append_option "--p2p-local-ip" "$PRYSM_P2P_LOCAL_IP"
append_option "--p2p-max-peers" "$PRYSM_P2P_MAX_PEERS"
append_option "--p2p-metadata" "$PRYSM_P2P_METADATA"
append_option "--p2p-priv-key" "$PRYSM_P2P_PRIV_KEY"
append_flag "--p2p-static-id" "$PRYSM_P2P_STATIC_ID"
append_option "--peer" "$PRYSM_PEER"
append_option "--pubsub-queue-size" "$PRYSM_PUBSUB_QUEUE_SIZE"

# log options
append_option "--log-file" "$PRYSM_LOG_FILE"
append_option "--log-format" "$PRYSM_LOG_FORMAT"

# features options
append_flag "--blob-save-fsync" "$PRYSM_BLOB_SAVE_FSYNC"
append_flag "--dev" "$PRYSM_DEV"
append_flag "--disable-broadcast-slashings" "$PRYSM_DISABLE_BROADCAST_SLASHINGS"
append_flag "--disable-grpc-connection-logging" "$PRYSM_DISABLE_GRPC_CONNECTION_LOGGING"
append_flag "--disable-peer-scorer" "$PRYSM_DISABLE_PEER_SCORER"
append_flag "--disable-registration-cache" "$PRYSM_DISABLE_REGISTRATION_CACHE"
append_flag "--disable-resource-manager" "$PRYSM_DISABLE_RESOURCE_MANAGER"
append_flag "--disable-staking-contract-check" "$PRYSM_DISABLE_STAKING_CONTRACT_CHECK"
append_flag "--disable-verbose-sig-verification" "$PRYSM_DISABLE_VERBOSE_SIG_VERIFICATION"
append_flag "--enable-committee-aware-packing" "$PRYSM_ENABLE_COMMITTEE_AWARE_PACKING"
append_flag "--enable-experimental-state" "$PRYSM_ENABLE_EXPERIMENTAL_STATE"
append_flag "--enable-full-ssz-data-logging" "$PRYSM_ENABLE_FULL_SSZ_DATA_LOGGING"
append_flag "--enable-historical-state-representation" "$PRYSM_ENABLE_HISTORICAL_STATE_REPRESENTATION"
append_flag "--enable-lightclient" "$PRYSM_ENABLE_LIGHTCLIENT"
append_flag "--enable-quic" "$PRYSM_ENABLE_QUIC"
append_flag "--holesky" "$PRYSM_HOLESKY"
append_flag "--interop-write-ssz-state-transitions" "$PRYSM_INTEROP_WRITE_SSZ_STATE_TRANSITIONS"
append_flag "--mainnet" "$PRYSM_MAINNET"
append_flag "--prepare-all-payloads" "$PRYSM_PREPARE_ALL_PAYLOADS"
append_flag "--save-full-execution-payloads" "$PRYSM_SAVE_FULL_EXECUTION_PAYLOADS"
append_flag "--save-invalid-blob-temp" "$PRYSM_SAVE_INVALID_BLOB_TEMP"
append_flag "--save-invalid-block-temp" "$PRYSM_SAVE_INVALID_BLOCK_TEMP"
append_flag "--sepolia" "$PRYSM_SEPOLIA"
append_flag "--slasher" "$PRYSM_SLASHER"

# interop options
append_option "--genesis-state" "$PRYSM_GENESIS_STATE"
append_option "--interop-genesis-time" "$PRYSM_INTEROP_GENESIS_TIME"
append_option "--interop-num-validators" "$PRYSM_INTEROP_NUM_VALIDATORS"

# deprecated options
append_option "--db-backup-output-dir" "$PRYSM_DB_BACKUP_OUTPUT_DIR"

echo "Using Options: beacon-chain $OPTIONS"

# on ci the postrm fails, so it not in path
exec beacon-chain $OPTIONS
