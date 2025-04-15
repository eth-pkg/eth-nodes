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

append_flag "--allow-insecure-genesis-sync" "$ALLOW_INSECURE_GENESIS_SYNC"
append_flag "--always-prefer-builder-payload" "$ALWAYS_PREFER_BUILDER_PAYLOAD"
append_flag "--always-prepare-payload" "$ALWAYS_PREPARE_PAYLOAD"
append_flag "--builder-fallback-disable-checks" "$BUILDER_FALLBACK_DISABLE_CHECKS"
append_flag "--compact-db" "$COMPACT_DB"
append_flag "--disable-backfill-rate-limiting" "$DISABLE_BACKFILL_RATE_LIMITING"
append_flag "--disable-deposit-contract-sync" "$DISABLE_DEPOSIT_CONTRACT_SYNC"
append_flag "--disable-duplicate-warn-logs" "$DISABLE_DUPLICATE_WARN_LOGS"
append_flag "--disable-enr-auto-update" "$DISABLE_ENR_AUTO_UPDATE"
append_flag "--disable-lock-timeouts" "$DISABLE_LOCK_TIMEOUTS"
append_flag "--disable-log-timestamp" "$DISABLE_LOG_TIMESTAMP"
append_flag "--disable-malloc-tuning" "$DISABLE_MALLOC_TUNING"
append_flag "--disable-optimistic-finalized-sync" "$DISABLE_OPTIMISTIC_FINALIZED_SYNC"
append_flag "--disable-packet-filter" "$DISABLE_PACKET_FILTER"
append_flag "--disable-proposer-reorgs" "$DISABLE_PROPOSER_REORGS"
append_flag "--disable-quic" "$DISABLE_QUIC"
append_flag "--disable-upnp" "$DISABLE_UPNP"
append_flag "--dummy-eth1" "$DUMMY_ETH1"
append_flag "--enable-private-discovery" "$ENABLE_PRIVATE_DISCOVERY"
append_flag "--enr-match" "$ENR_MATCH"
append_flag "--eth1" "$ETH1"
append_flag "--eth1-purge-cache" "$ETH1_PURGE_CACHE"
append_flag "--genesis-backfill" "$GENESIS_BACKFILL"
append_flag "--gui" "$GUI"
append_flag "--http" "$HTTP"
append_flag "--http-allow-sync-stalled" "$HTTP_ALLOW_SYNC_STALLED"
append_flag "--http-enable-tls" "$HTTP_ENABLE_TLS"
append_flag "--import-all-attestations" "$IMPORT_ALL_ATTESTATIONS"
append_flag "--light-client-server" "$LIGHT_CLIENT_SERVER"
append_flag "--log-color" "$LOG_COLOR"
append_flag "--logfile-compress" "$LOGFILE_COMPRESS"
append_flag "--logfile-no-restricted-perms" "$LOGFILE_NO_RESTRICTED_PERMS"
append_flag "--metrics" "$METRICS"
append_flag "--private" "$PRIVATE"
append_flag "--proposer-only" "$PROPOSER_ONLY"
append_flag "--purge-db" "$PURGE_DB"
append_flag "--reconstruct-historic-states" "$RECONSTRUCT_HISTORIC_STATES"
append_flag "--reset-payload-statuses" "$RESET_PAYLOAD_STATUSES"
append_flag "--shutdown-after-sync" "$SHUTDOWN_AFTER_SYNC"
append_flag "--slasher" "$SLASHER"
append_flag "--staking" "$STAKING"
append_flag "--subscribe-all-subnets" "$SUBSCRIBE_ALL_SUBNETS"
append_flag "--validator-monitor-auto" "$VALIDATOR_MONITOR_AUTO"
append_flag "--zero-ports" "$ZERO_PORTS"

append_option "--auto-compact-db" "$AUTO_COMPACT_DB"
append_option "--blob-prune-margin-epochs" "$BLOB_PRUNE_MARGIN_EPOCHS"
append_option "--blobs-dir" "$BLOBS_DIR"
append_option "--block-cache-size" "$BLOCK_CACHE_SIZE"
append_option "--boot-nodes" "$BOOT_NODES"
append_option "--builder" "$BUILDER"
append_option "--builder-fallback-epochs-since-finalization" "$BUILDER_FALLBACK_EPOCHS_SINCE_FINALIZATION"
append_option "--builder-fallback-skips" "$BUILDER_FALLBACK_SKIPS"
append_option "--builder-fallback-skips-per-epoch" "$BUILDER_FALLBACK_SKIPS_PER_EPOCH"
append_option "--builder-user-agent" "$BUILDER_USER_AGENT"
append_option "--checkpoint-blobs" "$CHECKPOINT_BLOBS"
append_option "--checkpoint-block" "$CHECKPOINT_BLOCK"
append_option "--checkpoint-state" "$CHECKPOINT_STATE"
append_option "--checkpoint-sync-url" "$CHECKPOINT_SYNC_URL"
append_option "--checkpoint-sync-url-timeout" "$CHECKPOINT_SYNC_URL_TIMEOUT"
append_option "--datadir" "$DATADIR"
append_option "--debug-level" "$DEBUG_LEVEL"
append_option "--discovery-port" "$DISCOVERY_PORT"
append_option "--discovery-port6" "$DISCOVERY_PORT6"
append_option "--enr-address" "$ENR_ADDRESS"
append_option "--enr-quic-port" "$ENR_QUIC_PORT"
append_option "--enr-quic6-port" "$ENR_QUIC6_PORT"
append_option "--enr-tcp-port" "$ENR_TCP_PORT"
append_option "--enr-tcp6-port" "$ENR_TCP6_PORT"
append_option "--enr-udp-port" "$ENR_UDP_PORT"
append_option "--enr-udp6-port" "$ENR_UDP6_PORT"
append_option "--epochs-per-blob-prune" "$EPOCHS_PER_BLOB_PRUNE"
append_option "--epochs-per-migration" "$EPOCHS_PER_MIGRATION"
append_option "--eth1-blocks-per-log-query" "$ETH1_BLOCKS_PER_LOG_QUERY"
append_option "--eth1-cache-follow-distance" "$ETH1_CACHE_FOLLOW_DISTANCE"
append_option "--execution-endpoint" "$EXECUTION_ENDPOINT"
append_option "--execution-jwt" "$EXECUTION_JWT"
append_option "--execution-jwt-id" "$EXECUTION_JWT_ID"
append_option "--execution-jwt-secret-key" "$EXECUTION_JWT_SECRET_KEY"
append_option "--execution-jwt-version" "$EXECUTION_JWT_VERSION"
append_option "--execution-timeout-multiplier" "$EXECUTION_TIMEOUT_MULTIPLIER"
append_option "--fork-choice-before-proposal-timeout" "$FORK_CHOICE_BEFORE_PROPOSAL_TIMEOUT"
append_option "--freezer-dir" "$FREEZER_DIR"
append_option "--genesis-state-url" "$GENESIS_STATE_URL"
append_option "--genesis-state-url-timeout" "$GENESIS_STATE_URL_TIMEOUT"
append_option "--graffiti" "$GRAFFITI"
append_option "--historic-state-cache-size" "$HISTORIC_STATE_CACHE_SIZE"
append_option "--http-address" "$HTTP_ADDRESS"
append_option "--http-allow-origin" "$HTTP_ALLOW_ORIGIN"
append_option "--http-duplicate-block-status" "$HTTP_DUPLICATE_BLOCK_STATUS"
append_option "--http-enable-beacon-processor" "$HTTP_ENABLE_BEACON_PROCESSOR"
append_option "--http-port" "$HTTP_PORT"
append_option "--http-spec-fork" "$HTTP_SPEC_FORK"
append_option "--http-sse-capacity-multiplier" "$HTTP_SSE_CAPACITY_MULTIPLIER"
append_option "--http-tls-cert" "$HTTP_TLS_CERT"
append_option "--http-tls-key" "$HTTP_TLS_KEY"
append_option "--invalid-gossip-verified-blocks-path" "$INVALID_GOSSIP_VERIFIED_BLOCKS_PATH"
append_option "--libp2p-addresses" "$LIBP2P_ADDRESSES"
append_option "--listen-address" "$LISTEN_ADDRESS"
append_option "--log-format" "$LOG_FORMAT"
append_option "--logfile" "$LOGFILE"
append_option "--logfile-debug-level" "$LOGFILE_DEBUG_LEVEL"
append_option "--logfile-format" "$LOGFILE_FORMAT"
append_option "--logfile-max-number" "$LOGFILE_MAX_NUMBER"
append_option "--logfile-max-size" "$LOGFILE_MAX_SIZE"
append_option "--max-skip-slots" "$MAX_SKIP_SLOTS"
append_option "--metrics-address" "$METRICS_ADDRESS"
append_option "--metrics-allow-origin" "$METRICS_ALLOW_ORIGIN"
append_option "--metrics-port" "$METRICS_PORT"
append_option "--monitoring-endpoint" "$MONITORING_ENDPOINT"
append_option "--monitoring-endpoint-period" "$MONITORING_ENDPOINT_PERIOD"
append_option "--network" "$NETWORK"
append_option "--network-dir" "$NETWORK_DIR"
append_option "--port" "$PORT"
append_option "--port6" "$PORT6"
append_option "--prepare-payload-lookahead" "$PREPARE_PAYLOAD_LOOKAHEAD"
append_option "--progressive-balances" "$PROGRESSIVE_BALANCES_MODE"
append_option "--proposer-reorg-cutoff" "$PROPOSER_REORG_CUTOFF"
append_option "--proposer-reorg-disallowed-offsets" "$PROPOSER_REORG_DISALLOWED_OFFSETS"
append_option "--proposer-reorg-epochs-since-finalization" "$PROPOSER_REORG_EPOCHS_SINCE_FINALIZATION"
append_option "--proposer-reorg-threshold" "$PROPOSER_REORG_THRESHOLD"
append_option "--prune-blobs" "$PRUNE_BLOBS"
append_option "--prune-payloads" "$PRUNE_PAYLOADS"
append_option "--quic-port" "$QUIC_PORT"
append_option "--quic-port6" "$QUIC_PORT6"
append_option "--safe-slots-to-import-optimistically" "$SAFE_SLOTS_TO_IMPORT_OPTIMISTICALLY"
append_option "--shuffling-cache-size" "$SHUFFLING_CACHE_SIZE"
append_option "--slasher-att-cache-size" "$SLASHER_ATT_CACHE_SIZE"
append_option "--slasher-backend" "$SLASHER_BACKEND"
append_option "--slasher-broadcast" "$SLASHER_BROADCAST"
append_option "--slasher-chunk-size" "$SLASHER_CHUNK_SIZE"
append_option "--slasher-dir" "$SLASHER_DIR"
append_option "--slasher-history-length" "$SLASHER_HISTORY_LENGTH"
append_option "--slasher-max-db-size" "$SLASHER_MAX_DB_SIZE"
append_option "--slasher-slot-offset" "$SLASHER_SLOT_OFFSET"
append_option "--slasher-update-period" "$SLASHER_UPDATE_PERIOD"
append_option "--slasher-validator-chunk-size" "$SLASHER_VALIDATOR_CHUNK_SIZE"
append_option "--slots-per-restore-point" "$SLOTS_PER_RESTORE_POINT"
append_option "--state-cache-size" "$STATE_CACHE_SIZE"
append_option "--suggested-fee-recipient" "$SUGGESTED_FEE_RECIPIENT"
append_option "--target-peers" "$TARGET_PEERS"
append_option "--terminal-block-hash-epoch-override" "$TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--terminal-block-hash-override" "$TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-total-difficulty-override" "$TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--testnet-dir" "$TESTNET_DIR"
append_option "--trusted-peers" "$TRUSTED_PEERS"
append_option "--trusted-setup-file-override" "$TRUSTED_SETUP_FILE_OVERRIDE"
append_option "--validator-monitor-file" "$VALIDATOR_MONITOR_FILE"
append_option "--validator-monitor-individual-tracking-threshold" "$VALIDATOR_MONITOR_INDIVIDUAL_TRACKING_THRESHOLD"
append_option "--validator-monitor-pubkeys" "$VALIDATOR_MONITOR_PUBKEYS"
append_option "--wss-checkpoint" "$WSS_CHECKPOINT"

echo "Starting lighthouse beacon_node $OPTIONS"
exec lighthouse beacon_node $OPTIONS
