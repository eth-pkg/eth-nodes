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
append_flag "--allow-insecure-genesis-sync" "$LIGHTHOUSE_CLI_BN_ALLOW_INSECURE_GENESIS_SYNC"
append_flag "--always-prefer-builder-payload" "$LIGHTHOUSE_CLI_BN_ALWAYS_PREFER_BUILDER_PAYLOAD"
append_flag "--always-prepare-payload" "$LIGHTHOUSE_CLI_BN_ALWAYS_PREPARE_PAYLOAD"
append_flag "--builder-fallback-disable-checks" "$LIGHTHOUSE_CLI_BN_BUILDER_FALLBACK_DISABLE_CHECKS"
append_flag "--compact-db" "$LIGHTHOUSE_CLI_BN_COMPACT_DB"
append_flag "--disable-backfill-rate-limiting" "$LIGHTHOUSE_CLI_BN_DISABLE_BACKFILL_RATE_LIMITING"
append_flag "--disable-deposit-contract-sync" "$LIGHTHOUSE_CLI_BN_DISABLE_DEPOSIT_CONTRACT_SYNC"
append_flag "--disable-duplicate-warn-logs" "$LIGHTHOUSE_CLI_BN_DISABLE_DUPLICATE_WARN_LOGS"
append_flag "--disable-enr-auto-update" "$LIGHTHOUSE_CLI_BN_DISABLE_ENR_AUTO_UPDATE"
append_flag "--disable-lock-timeouts" "$LIGHTHOUSE_CLI_BN_DISABLE_LOCK_TIMEOUTS"
append_flag "--disable-log-timestamp" "$LIGHTHOUSE_CLI_BN_DISABLE_LOG_TIMESTAMP"
append_flag "--disable-malloc-tuning" "$LIGHTHOUSE_CLI_BN_DISABLE_MALLOC_TUNING"
append_flag "--disable-optimistic-finalized-sync" "$LIGHTHOUSE_CLI_BN_DISABLE_OPTIMISTIC_FINALIZED_SYNC"
append_flag "--disable-packet-filter" "$LIGHTHOUSE_CLI_BN_DISABLE_PACKET_FILTER"
append_flag "--disable-proposer-reorgs" "$LIGHTHOUSE_CLI_BN_DISABLE_PROPOSER_REORGS"
append_flag "--disable-quic" "$LIGHTHOUSE_CLI_BN_DISABLE_QUIC"
append_flag "--disable-upnp" "$LIGHTHOUSE_CLI_BN_DISABLE_UPNP"
append_flag "--dummy-eth1" "$LIGHTHOUSE_CLI_BN_DUMMY_ETH1"
append_flag "--enable-private-discovery" "$LIGHTHOUSE_CLI_BN_ENABLE_PRIVATE_DISCOVERY"
append_flag "--enr-match" "$LIGHTHOUSE_CLI_BN_ENR_MATCH"
append_flag "--eth1" "$LIGHTHOUSE_CLI_BN_ETH1"
append_flag "--eth1-purge-cache" "$LIGHTHOUSE_CLI_BN_ETH1_PURGE_CACHE"
append_flag "--genesis-backfill" "$LIGHTHOUSE_CLI_BN_GENESIS_BACKFILL"
append_flag "--gui" "$LIGHTHOUSE_CLI_BN_GUI"
append_flag "--http" "$LIGHTHOUSE_CLI_BN_HTTP"
append_flag "--http-allow-sync-stalled" "$LIGHTHOUSE_CLI_BN_HTTP_ALLOW_SYNC_STALLED"
append_flag "--http-enable-tls" "$LIGHTHOUSE_CLI_BN_HTTP_ENABLE_TLS"
append_flag "--import-all-attestations" "$LIGHTHOUSE_CLI_BN_IMPORT_ALL_ATTESTATIONS"
append_flag "--light-client-server" "$LIGHTHOUSE_CLI_BN_LIGHT_CLIENT_SERVER"
append_flag "--log-color" "$LIGHTHOUSE_CLI_BN_LOG_COLOR"
append_flag "--logfile-compress" "$LIGHTHOUSE_CLI_BN_LOGFILE_COMPRESS"
append_flag "--logfile-no-restricted-perms" "$LIGHTHOUSE_CLI_BN_LOGFILE_NO_RESTRICTED_PERMS"
append_flag "--metrics" "$LIGHTHOUSE_CLI_BN_METRICS"
append_flag "--private" "$LIGHTHOUSE_CLI_BN_PRIVATE"
append_flag "--proposer-only" "$LIGHTHOUSE_CLI_BN_PROPOSER_ONLY"
append_flag "--purge-db" "$LIGHTHOUSE_CLI_BN_PURGE_DB"
append_flag "--reconstruct-historic-states" "$LIGHTHOUSE_CLI_BN_RECONSTRUCT_HISTORIC_STATES"
append_flag "--reset-payload-statuses" "$LIGHTHOUSE_CLI_BN_RESET_PAYLOAD_STATUSES"
append_flag "--shutdown-after-sync" "$LIGHTHOUSE_CLI_BN_SHUTDOWN_AFTER_SYNC"
append_flag "--slasher" "$LIGHTHOUSE_CLI_BN_SLASHER"
append_flag "--staking" "$LIGHTHOUSE_CLI_BN_STAKING"
append_flag "--subscribe-all-subnets" "$LIGHTHOUSE_CLI_BN_SUBSCRIBE_ALL_SUBNETS"
append_flag "--validator-monitor-auto" "$LIGHTHOUSE_CLI_BN_VALIDATOR_MONITOR_AUTO"
append_flag "--zero-ports" "$LIGHTHOUSE_CLI_BN_ZERO_PORTS"

append_option "--auto-compact-db" "$LIGHTHOUSE_CLI_BN_AUTO_COMPACT_DB"
append_option "--blob-prune-margin-epochs" "$LIGHTHOUSE_CLI_BN_BLOB_PRUNE_MARGIN_EPOCHS"
append_option "--blobs-dir" "$LIGHTHOUSE_CLI_BN_BLOBS_DIR"
append_option "--block-cache-size" "$LIGHTHOUSE_CLI_BN_BLOCK_CACHE_SIZE"
append_option "--boot-nodes" "$LIGHTHOUSE_CLI_BN_BOOT_NODES"
append_option "--builder" "$LIGHTHOUSE_CLI_BN_BUILDER"
append_option "--builder-fallback-epochs-since-finalization" "$LIGHTHOUSE_CLI_BN_BUILDER_FALLBACK_EPOCHS_SINCE_FINALIZATION"
append_option "--builder-fallback-skips" "$LIGHTHOUSE_CLI_BN_BUILDER_FALLBACK_SKIPS"
append_option "--builder-fallback-skips-per-epoch" "$LIGHTHOUSE_CLI_BN_BUILDER_FALLBACK_SKIPS_PER_EPOCH"
append_option "--builder-profit-threshold" "$LIGHTHOUSE_CLI_BN_BUILDER_PROFIT_THRESHOLD"
append_option "--builder-user-agent" "$LIGHTHOUSE_CLI_BN_BUILDER_USER_AGENT"
append_option "--checkpoint-blobs" "$LIGHTHOUSE_CLI_BN_CHECKPOINT_BLOBS"
append_option "--checkpoint-block" "$LIGHTHOUSE_CLI_BN_CHECKPOINT_BLOCK"
append_option "--checkpoint-state" "$LIGHTHOUSE_CLI_BN_CHECKPOINT_STATE"
append_option "--checkpoint-sync-url" "$LIGHTHOUSE_CLI_BN_CHECKPOINT_SYNC_URL"
append_option "--checkpoint-sync-url-timeout" "$LIGHTHOUSE_CLI_BN_CHECKPOINT_SYNC_URL_TIMEOUT"
append_option "--datadir" "$LIGHTHOUSE_CLI_BN_DATADIR"
append_option "--debug-level" "$LIGHTHOUSE_CLI_BN_DEBUG_LEVEL"
append_option "--discovery-port" "$LIGHTHOUSE_CLI_BN_DISCOVERY_PORT"
append_option "--discovery-port6" "$LIGHTHOUSE_CLI_BN_DISCOVERY_PORT6"
append_option "--enr-address" "$LIGHTHOUSE_CLI_BN_ENR_ADDRESS"
append_option "--enr-quic-port" "$LIGHTHOUSE_CLI_BN_ENR_QUIC_PORT"
append_option "--enr-quic6-port" "$LIGHTHOUSE_CLI_BN_ENR_QUIC6_PORT"
append_option "--enr-tcp-port" "$LIGHTHOUSE_CLI_BN_ENR_TCP_PORT"
append_option "--enr-tcp6-port" "$LIGHTHOUSE_CLI_BN_ENR_TCP6_PORT"
append_option "--enr-udp-port" "$LIGHTHOUSE_CLI_BN_ENR_UDP_PORT"
append_option "--enr-udp6-port" "$LIGHTHOUSE_CLI_BN_ENR_UDP6_PORT"
append_option "--epochs-per-blob-prune" "$LIGHTHOUSE_CLI_BN_EPOCHS_PER_BLOB_PRUNE"
append_option "--epochs-per-migration" "$LIGHTHOUSE_CLI_BN_EPOCHS_PER_MIGRATION"
append_option "--eth1-blocks-per-log-query" "$LIGHTHOUSE_CLI_BN_ETH1_BLOCKS_PER_LOG_QUERY"
append_option "--eth1-cache-follow-distance" "$LIGHTHOUSE_CLI_BN_ETH1_CACHE_FOLLOW_DISTANCE"
append_option "--execution-endpoint" "$LIGHTHOUSE_CLI_BN_EXECUTION_ENDPOINT"
append_option "--execution-jwt" "$LIGHTHOUSE_CLI_BN_EXECUTION_JWT"
append_option "--execution-jwt-id" "$LIGHTHOUSE_CLI_BN_EXECUTION_JWT_ID"
append_option "--execution-jwt-secret-key" "$LIGHTHOUSE_CLI_BN_EXECUTION_JWT_SECRET_KEY"
append_option "--execution-jwt-version" "$LIGHTHOUSE_CLI_BN_EXECUTION_JWT_VERSION"
append_option "--execution-timeout-multiplier" "$LIGHTHOUSE_CLI_BN_EXECUTION_TIMEOUT_MULTIPLIER"
append_option "--fork-choice-before-proposal-timeout" "$LIGHTHOUSE_CLI_BN_FORK_CHOICE_BEFORE_PROPOSAL_TIMEOUT"
append_option "--freezer-dir" "$LIGHTHOUSE_CLI_BN_FREEZER_DIR"
append_option "--genesis-state-url" "$LIGHTHOUSE_CLI_BN_GENESIS_STATE_URL"
append_option "--genesis-state-url-timeout" "$LIGHTHOUSE_CLI_BN_GENESIS_STATE_URL_TIMEOUT"
append_option "--graffiti" "$LIGHTHOUSE_CLI_BN_GRAFFITI"
append_option "--historic-state-cache-size" "$LIGHTHOUSE_CLI_BN_HISTORIC_STATE_CACHE_SIZE"
append_option "--http-address" "$LIGHTHOUSE_CLI_BN_HTTP_ADDRESS"
append_option "--http-allow-origin" "$LIGHTHOUSE_CLI_BN_HTTP_ALLOW_ORIGIN"
append_option "--http-duplicate-block-status" "$LIGHTHOUSE_CLI_BN_HTTP_DUPLICATE_BLOCK_STATUS"
append_option "--http-enable-beacon-processor" "$LIGHTHOUSE_CLI_BN_HTTP_ENABLE_BEACON_PROCESSOR"
append_option "--http-port" "$LIGHTHOUSE_CLI_BN_HTTP_PORT"
append_option "--http-spec-fork" "$LIGHTHOUSE_CLI_BN_HTTP_SPEC_FORK"
append_option "--http-sse-capacity-multiplier" "$LIGHTHOUSE_CLI_BN_HTTP_SSE_CAPACITY_MULTIPLIER"
append_option "--http-tls-cert" "$LIGHTHOUSE_CLI_BN_HTTP_TLS_CERT"
append_option "--http-tls-key" "$LIGHTHOUSE_CLI_BN_HTTP_TLS_KEY"
append_option "--invalid-gossip-verified-blocks-path" "$LIGHTHOUSE_CLI_BN_INVALID_GOSSIP_VERIFIED_BLOCKS_PATH"
append_option "--libp2p-addresses" "$LIGHTHOUSE_CLI_BN_LIBP2P_ADDRESSES"
append_option "--listen-address" "$LIGHTHOUSE_CLI_BN_LISTEN_ADDRESS"
append_option "--log-format" "$LIGHTHOUSE_CLI_BN_LOG_FORMAT"
append_option "--logfile" "$LIGHTHOUSE_CLI_BN_LOGFILE"
append_option "--logfile-debug-level" "$LIGHTHOUSE_CLI_BN_LOGFILE_DEBUG_LEVEL"
append_option "--logfile-format" "$LIGHTHOUSE_CLI_BN_LOGFILE_FORMAT"
append_option "--logfile-max-number" "$LIGHTHOUSE_CLI_BN_LOGFILE_MAX_NUMBER"
append_option "--logfile-max-size" "$LIGHTHOUSE_CLI_BN_LOGFILE_MAX_SIZE"
append_option "--max-skip-slots" "$LIGHTHOUSE_CLI_BN_MAX_SKIP_SLOTS"
append_option "--metrics-address" "$LIGHTHOUSE_CLI_BN_METRICS_ADDRESS"
append_option "--metrics-allow-origin" "$LIGHTHOUSE_CLI_BN_METRICS_ALLOW_ORIGIN"
append_option "--metrics-port" "$LIGHTHOUSE_CLI_BN_METRICS_PORT"
append_option "--monitoring-endpoint" "$LIGHTHOUSE_CLI_BN_MONITORING_ENDPOINT"
append_option "--monitoring-endpoint-period" "$LIGHTHOUSE_CLI_BN_MONITORING_ENDPOINT_PERIOD"
append_option "--network" "$LIGHTHOUSE_CLI_BN_NETWORK"
append_option "--network-dir" "$LIGHTHOUSE_CLI_BN_NETWORK_DIR"
append_option "--port" "$LIGHTHOUSE_CLI_BN_PORT"
append_option "--port6" "$LIGHTHOUSE_CLI_BN_PORT6"
append_option "--prepare-payload-lookahead" "$LIGHTHOUSE_CLI_BN_PREPARE_PAYLOAD_LOOKAHEAD"
append_option "--progressive-balances" "$LIGHTHOUSE_CLI_BN_PROGRESSIVE_BALANCES_MODE"
append_option "--proposer-reorg-cutoff" "$LIGHTHOUSE_CLI_BN_PROPOSER_REORG_CUTOFF"
append_option "--proposer-reorg-disallowed-offsets" "$LIGHTHOUSE_CLI_BN_PROPOSER_REORG_DISALLOWED_OFFSETS"
append_option "--proposer-reorg-epochs-since-finalization" "$LIGHTHOUSE_CLI_BN_PROPOSER_REORG_EPOCHS_SINCE_FINALIZATION"
append_option "--proposer-reorg-threshold" "$LIGHTHOUSE_CLI_BN_PROPOSER_REORG_THRESHOLD"
append_option "--prune-blobs" "$LIGHTHOUSE_CLI_BN_PRUNE_BLOBS"
append_option "--prune-payloads" "$LIGHTHOUSE_CLI_BN_PRUNE_PAYLOADS"
append_option "--quic-port" "$LIGHTHOUSE_CLI_BN_QUIC_PORT"
append_option "--quic-port6" "$LIGHTHOUSE_CLI_BN_QUIC_PORT6"
append_option "--safe-slots-to-import-optimistically" "$LIGHTHOUSE_CLI_BN_SAFE_SLOTS_TO_IMPORT_OPTIMISTICALLY"
append_option "--shuffling-cache-size" "$LIGHTHOUSE_CLI_BN_SHUFFLING_CACHE_SIZE"
append_option "--slasher-att-cache-size" "$LIGHTHOUSE_CLI_BN_SLASHER_ATT_CACHE_SIZE"
append_option "--slasher-backend" "$LIGHTHOUSE_CLI_BN_SLASHER_BACKEND"
append_option "--slasher-broadcast" "$LIGHTHOUSE_CLI_BN_SLASHER_BROADCAST"
append_option "--slasher-chunk-size" "$LIGHTHOUSE_CLI_BN_SLASHER_CHUNK_SIZE"
append_option "--slasher-dir" "$LIGHTHOUSE_CLI_BN_SLASHER_DIR"
append_option "--slasher-history-length" "$LIGHTHOUSE_CLI_BN_SLASHER_HISTORY_LENGTH"
append_option "--slasher-max-db-size" "$LIGHTHOUSE_CLI_BN_SLASHER_MAX_DB_SIZE"
append_option "--slasher-slot-offset" "$LIGHTHOUSE_CLI_BN_SLASHER_SLOT_OFFSET"
append_option "--slasher-update-period" "$LIGHTHOUSE_CLI_BN_SLASHER_UPDATE_PERIOD"
append_option "--slasher-validator-chunk-size" "$LIGHTHOUSE_CLI_BN_SLASHER_VALIDATOR_CHUNK_SIZE"
append_option "--slots-per-restore-point" "$LIGHTHOUSE_CLI_BN_SLOTS_PER_RESTORE_POINT"
append_option "--state-cache-size" "$LIGHTHOUSE_CLI_BN_STATE_CACHE_SIZE"
append_option "--suggested-fee-recipient" "$LIGHTHOUSE_CLI_BN_SUGGESTED_FEE_RECIPIENT"
append_option "--target-peers" "$LIGHTHOUSE_CLI_BN_TARGET_PEERS"
append_option "--terminal-block-hash-epoch-override" "$LIGHTHOUSE_CLI_BN_TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--terminal-block-hash-override" "$LIGHTHOUSE_CLI_BN_TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-total-difficulty-override" "$LIGHTHOUSE_CLI_BN_TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--testnet-dir" "$LIGHTHOUSE_CLI_BN_TESTNET_DIR"
append_option "--trusted-peers" "$LIGHTHOUSE_CLI_BN_TRUSTED_PEERS"
append_option "--trusted-setup-file-override" "$LIGHTHOUSE_CLI_BN_TRUSTED_SETUP_FILE_OVERRIDE"
append_option "--validator-monitor-file" "$LIGHTHOUSE_CLI_BN_VALIDATOR_MONITOR_FILE"
append_option "--validator-monitor-individual-tracking-threshold" "$LIGHTHOUSE_CLI_BN_VALIDATOR_MONITOR_INDIVIDUAL_TRACKING_THRESHOLD"
append_option "--validator-monitor-pubkeys" "$LIGHTHOUSE_CLI_BN_VALIDATOR_MONITOR_PUBKEYS"
append_option "--wss-checkpoint" "$LIGHTHOUSE_CLI_BN_WSS_CHECKPOINT"


echo "Starting lighthouse beacon_node $OPTIONS"
exec lighthouse beacon_node $OPTIONS