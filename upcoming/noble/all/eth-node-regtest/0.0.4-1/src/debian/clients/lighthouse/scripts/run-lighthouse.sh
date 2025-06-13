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

append_flag "--allow-insecure-genesis-sync" "$LIGHTHOUSE_ALLOW_INSECURE_GENESIS_SYNC"
append_flag "--always-prefer-builder-payload" "$LIGHTHOUSE_ALWAYS_PREFER_BUILDER_PAYLOAD"
append_flag "--always-prepare-payload" "$LIGHTHOUSE_ALWAYS_PREPARE_PAYLOAD"
append_flag "--builder-fallback-disable-checks" "$LIGHTHOUSE_BUILDER_FALLBACK_DISABLE_CHECKS"
append_flag "--compact-db" "$LIGHTHOUSE_COMPACT_DB"
append_flag "--disable-backfill-rate-limiting" "$LIGHTHOUSE_DISABLE_BACKFILL_RATE_LIMITING"
append_flag "--disable-deposit-contract-sync" "$LIGHTHOUSE_DISABLE_DEPOSIT_CONTRACT_SYNC"
append_flag "--disable-duplicate-warn-logs" "$LIGHTHOUSE_DISABLE_DUPLICATE_WARN_LOGS"
append_flag "--disable-enr-auto-update" "$LIGHTHOUSE_DISABLE_ENR_AUTO_UPDATE"
append_flag "--disable-lock-timeouts" "$LIGHTHOUSE_DISABLE_LOCK_TIMEOUTS"
append_flag "--disable-log-timestamp" "$LIGHTHOUSE_DISABLE_LOG_TIMESTAMP"
append_flag "--disable-malloc-tuning" "$LIGHTHOUSE_DISABLE_MALLOC_TUNING"
append_flag "--disable-optimistic-finalized-sync" "$LIGHTHOUSE_DISABLE_OPTIMISTIC_FINALIZED_SYNC"
append_flag "--disable-packet-filter" "$LIGHTHOUSE_DISABLE_PACKET_FILTER"
append_flag "--disable-proposer-reorgs" "$LIGHTHOUSE_DISABLE_PROPOSER_REORGS"
append_flag "--disable-quic" "$LIGHTHOUSE_DISABLE_QUIC"
append_flag "--disable-upnp" "$LIGHTHOUSE_DISABLE_UPNP"
append_flag "--dummy-eth1" "$LIGHTHOUSE_DUMMY_ETH1"
append_flag "--enable-private-discovery" "$LIGHTHOUSE_ENABLE_PRIVATE_DISCOVERY"
append_flag "--enr-match" "$LIGHTHOUSE_ENR_MATCH"
append_flag "--eth1" "$LIGHTHOUSE_ETH1"
append_flag "--eth1-purge-cache" "$LIGHTHOUSE_ETH1_PURGE_CACHE"
append_flag "--genesis-backfill" "$LIGHTHOUSE_GENESIS_BACKFILL"
append_flag "--gui" "$LIGHTHOUSE_GUI"
append_flag "--http" "$LIGHTHOUSE_HTTP"
append_flag "--http-allow-sync-stalled" "$LIGHTHOUSE_HTTP_ALLOW_SYNC_STALLED"
append_flag "--http-enable-tls" "$LIGHTHOUSE_HTTP_ENABLE_TLS"
append_flag "--import-all-attestations" "$LIGHTHOUSE_IMPORT_ALL_ATTESTATIONS"
append_flag "--light-client-server" "$LIGHTHOUSE_LIGHT_CLIENT_SERVER"
append_flag "--log-color" "$LIGHTHOUSE_LOG_COLOR"
append_flag "--logfile-compress" "$LIGHTHOUSE_LOGFILE_COMPRESS"
append_flag "--logfile-no-restricted-perms" "$LIGHTHOUSE_LOGFILE_NO_RESTRICTED_PERMS"
append_flag "--metrics" "$LIGHTHOUSE_METRICS"
append_flag "--private" "$LIGHTHOUSE_PRIVATE"
append_flag "--proposer-only" "$LIGHTHOUSE_PROPOSER_ONLY"
append_flag "--purge-db" "$LIGHTHOUSE_PURGE_DB"
append_flag "--reconstruct-historic-states" "$LIGHTHOUSE_RECONSTRUCT_HISTORIC_STATES"
append_flag "--reset-payload-statuses" "$LIGHTHOUSE_RESET_PAYLOAD_STATUSES"
append_flag "--shutdown-after-sync" "$LIGHTHOUSE_SHUTDOWN_AFTER_SYNC"
append_flag "--slasher" "$LIGHTHOUSE_SLASHER"
append_flag "--staking" "$LIGHTHOUSE_STAKING"
append_flag "--subscribe-all-subnets" "$LIGHTHOUSE_SUBSCRIBE_ALL_SUBNETS"
append_flag "--validator-monitor-auto" "$LIGHTHOUSE_VALIDATOR_MONITOR_AUTO"
append_flag "--zero-ports" "$LIGHTHOUSE_ZERO_PORTS"

append_option "--auto-compact-db" "$LIGHTHOUSE_AUTO_COMPACT_DB"
append_option "--blob-prune-margin-epochs" "$LIGHTHOUSE_BLOB_PRUNE_MARGIN_EPOCHS"
append_option "--blobs-dir" "$LIGHTHOUSE_BLOBS_DIR"
append_option "--block-cache-size" "$LIGHTHOUSE_BLOCK_CACHE_SIZE"
append_option "--boot-nodes" "$LIGHTHOUSE_BOOT_NODES"
append_option "--builder" "$LIGHTHOUSE_BUILDER"
append_option "--builder-fallback-epochs-since-finalization" "$LIGHTHOUSE_BUILDER_FALLBACK_EPOCHS_SINCE_FINALIZATION"
append_option "--builder-fallback-skips" "$LIGHTHOUSE_BUILDER_FALLBACK_SKIPS"
append_option "--builder-fallback-skips-per-epoch" "$LIGHTHOUSE_BUILDER_FALLBACK_SKIPS_PER_EPOCH"
append_option "--builder-user-agent" "$LIGHTHOUSE_BUILDER_USER_AGENT"
append_option "--checkpoint-blobs" "$LIGHTHOUSE_CHECKPOINT_BLOBS"
append_option "--checkpoint-block" "$LIGHTHOUSE_CHECKPOINT_BLOCK"
append_option "--checkpoint-state" "$LIGHTHOUSE_CHECKPOINT_STATE"
append_option "--checkpoint-sync-url" "$LIGHTHOUSE_CHECKPOINT_SYNC_URL"
append_option "--checkpoint-sync-url-timeout" "$LIGHTHOUSE_CHECKPOINT_SYNC_URL_TIMEOUT"
append_option "--datadir" "$LIGHTHOUSE_DATADIR"
append_option "--debug-level" "$LIGHTHOUSE_DEBUG_LEVEL"
append_option "--discovery-port" "$LIGHTHOUSE_DISCOVERY_PORT"
append_option "--discovery-port6" "$LIGHTHOUSE_DISCOVERY_PORT6"
append_option "--enr-address" "$LIGHTHOUSE_ENR_ADDRESS"
append_option "--enr-quic-port" "$LIGHTHOUSE_ENR_QUIC_PORT"
append_option "--enr-quic6-port" "$LIGHTHOUSE_ENR_QUIC6_PORT"
append_option "--enr-tcp-port" "$LIGHTHOUSE_ENR_TCP_PORT"
append_option "--enr-tcp6-port" "$LIGHTHOUSE_ENR_TCP6_PORT"
append_option "--enr-udp-port" "$LIGHTHOUSE_ENR_UDP_PORT"
append_option "--enr-udp6-port" "$LIGHTHOUSE_ENR_UDP6_PORT"
append_option "--epochs-per-blob-prune" "$LIGHTHOUSE_EPOCHS_PER_BLOB_PRUNE"
append_option "--epochs-per-migration" "$LIGHTHOUSE_EPOCHS_PER_MIGRATION"
append_option "--eth1-blocks-per-log-query" "$LIGHTHOUSE_ETH1_BLOCKS_PER_LOG_QUERY"
append_option "--eth1-cache-follow-distance" "$LIGHTHOUSE_ETH1_CACHE_FOLLOW_DISTANCE"
append_option "--execution-endpoint" "$LIGHTHOUSE_EXECUTION_ENDPOINT"
append_option "--execution-jwt" "$LIGHTHOUSE_EXECUTION_JWT"
append_option "--execution-jwt-id" "$LIGHTHOUSE_EXECUTION_JWT_ID"
append_option "--execution-jwt-secret-key" "$LIGHTHOUSE_EXECUTION_JWT_SECRET_KEY"
append_option "--execution-jwt-version" "$LIGHTHOUSE_EXECUTION_JWT_VERSION"
append_option "--execution-timeout-multiplier" "$LIGHTHOUSE_EXECUTION_TIMEOUT_MULTIPLIER"
append_option "--fork-choice-before-proposal-timeout" "$LIGHTHOUSE_FORK_CHOICE_BEFORE_PROPOSAL_TIMEOUT"
append_option "--freezer-dir" "$LIGHTHOUSE_FREEZER_DIR"
append_option "--genesis-state-url" "$LIGHTHOUSE_GENESIS_STATE_URL"
append_option "--genesis-state-url-timeout" "$LIGHTHOUSE_GENESIS_STATE_URL_TIMEOUT"
append_option "--graffiti" "$LIGHTHOUSE_GRAFFITI"
append_option "--historic-state-cache-size" "$LIGHTHOUSE_HISTORIC_STATE_CACHE_SIZE"
append_option "--http-address" "$LIGHTHOUSE_HTTP_ADDRESS"
append_option "--http-allow-origin" "$LIGHTHOUSE_HTTP_ALLOW_ORIGIN"
append_option "--http-duplicate-block-status" "$LIGHTHOUSE_HTTP_DUPLICATE_BLOCK_STATUS"
append_option "--http-enable-beacon-processor" "$LIGHTHOUSE_HTTP_ENABLE_BEACON_PROCESSOR"
append_option "--http-port" "$LIGHTHOUSE_HTTP_PORT"
append_option "--http-spec-fork" "$LIGHTHOUSE_HTTP_SPEC_FORK"
append_option "--http-sse-capacity-multiplier" "$LIGHTHOUSE_HTTP_SSE_CAPACITY_MULTIPLIER"
append_option "--http-tls-cert" "$LIGHTHOUSE_HTTP_TLS_CERT"
append_option "--http-tls-key" "$LIGHTHOUSE_HTTP_TLS_KEY"
append_option "--invalid-gossip-verified-blocks-path" "$LIGHTHOUSE_INVALID_GOSSIP_VERIFIED_BLOCKS_PATH"
append_option "--libp2p-addresses" "$LIGHTHOUSE_LIBP2P_ADDRESSES"
append_option "--listen-address" "$LIGHTHOUSE_LISTEN_ADDRESS"
append_option "--log-format" "$LIGHTHOUSE_LOG_FORMAT"
append_option "--logfile" "$LIGHTHOUSE_LOGFILE"
append_option "--logfile-debug-level" "$LIGHTHOUSE_LOGFILE_DEBUG_LEVEL"
append_option "--logfile-format" "$LIGHTHOUSE_LOGFILE_FORMAT"
append_option "--logfile-max-number" "$LIGHTHOUSE_LOGFILE_MAX_NUMBER"
append_option "--logfile-max-size" "$LIGHTHOUSE_LOGFILE_MAX_SIZE"
append_option "--max-skip-slots" "$LIGHTHOUSE_MAX_SKIP_SLOTS"
append_option "--metrics-address" "$LIGHTHOUSE_METRICS_ADDRESS"
append_option "--metrics-allow-origin" "$LIGHTHOUSE_METRICS_ALLOW_ORIGIN"
append_option "--metrics-port" "$LIGHTHOUSE_METRICS_PORT"
append_option "--monitoring-endpoint" "$LIGHTHOUSE_MONITORING_ENDPOINT"
append_option "--monitoring-endpoint-period" "$LIGHTHOUSE_MONITORING_ENDPOINT_PERIOD"
append_option "--network" "$LIGHTHOUSE_NETWORK"
append_option "--network-dir" "$LIGHTHOUSE_NETWORK_DIR"
append_option "--port" "$LIGHTHOUSE_PORT"
append_option "--port6" "$LIGHTHOUSE_PORT6"
append_option "--prepare-payload-lookahead" "$LIGHTHOUSE_PREPARE_PAYLOAD_LOOKAHEAD"
append_option "--progressive-balances" "$LIGHTHOUSE_PROGRESSIVE_BALANCES_MODE"
append_option "--proposer-reorg-cutoff" "$LIGHTHOUSE_PROPOSER_REORG_CUTOFF"
append_option "--proposer-reorg-disallowed-offsets" "$LIGHTHOUSE_PROPOSER_REORG_DISALLOWED_OFFSETS"
append_option "--proposer-reorg-epochs-since-finalization" "$LIGHTHOUSE_PROPOSER_REORG_EPOCHS_SINCE_FINALIZATION"
append_option "--proposer-reorg-threshold" "$LIGHTHOUSE_PROPOSER_REORG_THRESHOLD"
append_option "--prune-blobs" "$LIGHTHOUSE_PRUNE_BLOBS"
append_option "--prune-payloads" "$LIGHTHOUSE_PRUNE_PAYLOADS"
append_option "--quic-port" "$LIGHTHOUSE_QUIC_PORT"
append_option "--quic-port6" "$LIGHTHOUSE_QUIC_PORT6"
append_option "--safe-slots-to-import-optimistically" "$LIGHTHOUSE_SAFE_SLOTS_TO_IMPORT_OPTIMISTICALLY"
append_option "--shuffling-cache-size" "$LIGHTHOUSE_SHUFFLING_CACHE_SIZE"
append_option "--slasher-att-cache-size" "$LIGHTHOUSE_SLASHER_ATT_CACHE_SIZE"
append_option "--slasher-backend" "$LIGHTHOUSE_SLASHER_BACKEND"
append_option "--slasher-broadcast" "$LIGHTHOUSE_SLASHER_BROADCAST"
append_option "--slasher-chunk-size" "$LIGHTHOUSE_SLASHER_CHUNK_SIZE"
append_option "--slasher-dir" "$LIGHTHOUSE_SLASHER_DIR"
append_option "--slasher-history-length" "$LIGHTHOUSE_SLASHER_HISTORY_LENGTH"
append_option "--slasher-max-db-size" "$LIGHTHOUSE_SLASHER_MAX_DB_SIZE"
append_option "--slasher-slot-offset" "$LIGHTHOUSE_SLASHER_SLOT_OFFSET"
append_option "--slasher-update-period" "$LIGHTHOUSE_SLASHER_UPDATE_PERIOD"
append_option "--slasher-validator-chunk-size" "$LIGHTHOUSE_SLASHER_VALIDATOR_CHUNK_SIZE"
append_option "--slots-per-restore-point" "$LIGHTHOUSE_SLOTS_PER_RESTORE_POINT"
append_option "--state-cache-size" "$LIGHTHOUSE_STATE_CACHE_SIZE"
append_option "--suggested-fee-recipient" "$LIGHTHOUSE_SUGGESTED_FEE_RECIPIENT"
append_option "--target-peers" "$LIGHTHOUSE_TARGET_PEERS"
append_option "--terminal-block-hash-epoch-override" "$LIGHTHOUSE_TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--terminal-block-hash-override" "$LIGHTHOUSE_TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-total-difficulty-override" "$LIGHTHOUSE_TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--testnet-dir" "$LIGHTHOUSE_TESTNET_DIR"
append_option "--trusted-peers" "$LIGHTHOUSE_TRUSTED_PEERS"
append_option "--trusted-setup-file-override" "$LIGHTHOUSE_TRUSTED_SETUP_FILE_OVERRIDE"
append_option "--validator-monitor-file" "$LIGHTHOUSE_VALIDATOR_MONITOR_FILE"
append_option "--validator-monitor-individual-tracking-threshold" "$LIGHTHOUSE_VALIDATOR_MONITOR_INDIVIDUAL_TRACKING_THRESHOLD"
append_option "--validator-monitor-pubkeys" "$LIGHTHOUSE_VALIDATOR_MONITOR_PUBKEYS"
append_option "--wss-checkpoint" "$LIGHTHOUSE_WSS_CHECKPOINT"

echo "Starting lighthouse beacon_node $OPTIONS"
exec lighthouse beacon_node $OPTIONS
