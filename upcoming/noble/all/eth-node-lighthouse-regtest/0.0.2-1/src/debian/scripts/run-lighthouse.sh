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

append_flag "--allow-insecure-genesis-sync" "$allow_insecure_genesis_sync"
append_flag "--always-prefer-builder-payload" "$always_prefer_builder_payload"
append_flag "--always-prepare-payload" "$always_prepare_payload"
append_flag "--builder-fallback-disable-checks" "$builder_fallback_disable_checks"
append_flag "--compact-db" "$compact_db"
append_flag "--disable-backfill-rate-limiting" "$disable_backfill_rate_limiting"
append_flag "--disable-deposit-contract-sync" "$disable_deposit_contract_sync"
append_flag "--disable-duplicate-warn-logs" "$disable_duplicate_warn_logs"
append_flag "--disable-enr-auto-update" "$disable_enr_auto_update"
append_flag "--disable-lock-timeouts" "$disable_lock_timeouts"
append_flag "--disable-log-timestamp" "$disable_log_timestamp"
append_flag "--disable-malloc-tuning" "$disable_malloc_tuning"
append_flag "--disable-optimistic-finalized-sync" "$disable_optimistic_finalized_sync"
append_flag "--disable-packet-filter" "$disable_packet_filter"
append_flag "--disable-proposer-reorgs" "$disable_proposer_reorgs"
append_flag "--disable-quic" "$disable_quic"
append_flag "--disable-upnp" "$disable_upnp"
append_flag "--dummy-eth1" "$dummy_eth1"
append_flag "--enable-private-discovery" "$enable_private_discovery"
append_flag "--enr-match" "$enr_match"
append_flag "--eth1" "$eth1"
append_flag "--eth1-purge-cache" "$eth1_purge_cache"
append_flag "--genesis-backfill" "$genesis_backfill"
append_flag "--gui" "$gui"
append_flag "--http" "$http"
append_flag "--http-allow-sync-stalled" "$http_allow_sync_stalled"
append_flag "--http-enable-tls" "$http_enable_tls"
append_flag "--import-all-attestations" "$import_all_attestations"
append_flag "--light-client-server" "$light_client_server"
append_flag "--log-color" "$log_color"
append_flag "--logfile-compress" "$logfile_compress"
append_flag "--logfile-no-restricted-perms" "$logfile_no_restricted_perms"
append_flag "--metrics" "$metrics"
append_flag "--private" "$private"
append_flag "--proposer-only" "$proposer_only"
append_flag "--purge-db" "$purge_db"
append_flag "--reconstruct-historic-states" "$reconstruct_historic_states"
append_flag "--reset-payload-statuses" "$reset_payload_statuses"
append_flag "--shutdown-after-sync" "$shutdown_after_sync"
append_flag "--slasher" "$slasher"
append_flag "--staking" "$staking"
append_flag "--subscribe-all-subnets" "$subscribe_all_subnets"
append_flag "--validator-monitor-auto" "$validator_monitor_auto"
append_flag "--zero-ports" "$zero_ports"

append_option "--auto-compact-db" "$auto_compact_db"
append_option "--blob-prune-margin-epochs" "$blob_prune_margin_epochs"
append_option "--blobs-dir" "$blobs_dir"
append_option "--block-cache-size" "$block_cache_size"
append_option "--boot-nodes" "$boot_nodes"
append_option "--builder" "$builder"
append_option "--builder-fallback-epochs-since-finalization" "$builder_fallback_epochs_since_finalization"
append_option "--builder-fallback-skips" "$builder_fallback_skips"
append_option "--builder-fallback-skips-per-epoch" "$builder_fallback_skips_per_epoch"
append_option "--builder-user-agent" "$builder_user_agent"
append_option "--checkpoint-blobs" "$checkpoint_blobs"
append_option "--checkpoint-block" "$checkpoint_block"
append_option "--checkpoint-state" "$checkpoint_state"
append_option "--checkpoint-sync-url" "$checkpoint_sync_url"
append_option "--checkpoint-sync-url-timeout" "$checkpoint_sync_url_timeout"
append_option "--datadir" "$datadir"
append_option "--debug-level" "$debug_level"
append_option "--discovery-port" "$discovery_port"
append_option "--discovery-port6" "$discovery_port6"
append_option "--enr-address" "$enr_address"
append_option "--enr-quic-port" "$enr_quic_port"
append_option "--enr-quic6-port" "$enr_quic6_port"
append_option "--enr-tcp-port" "$enr_tcp_port"
append_option "--enr-tcp6-port" "$enr_tcp6_port"
append_option "--enr-udp-port" "$enr_udp_port"
append_option "--enr-udp6-port" "$enr_udp6_port"
append_option "--epochs-per-blob-prune" "$epochs_per_blob_prune"
append_option "--epochs-per-migration" "$epochs_per_migration"
append_option "--eth1-blocks-per-log-query" "$eth1_blocks_per_log_query"
append_option "--eth1-cache-follow-distance" "$eth1_cache_follow_distance"
append_option "--execution-endpoint" "$execution_endpoint"
append_option "--execution-jwt" "$execution_jwt"
append_option "--execution-jwt-id" "$execution_jwt_id"
append_option "--execution-jwt-secret-key" "$execution_jwt_secret_key"
append_option "--execution-jwt-version" "$execution_jwt_version"
append_option "--execution-timeout-multiplier" "$execution_timeout_multiplier"
append_option "--fork-choice-before-proposal-timeout" "$fork_choice_before_proposal_timeout"
append_option "--freezer-dir" "$freezer_dir"
append_option "--genesis-state-url" "$genesis_state_url"
append_option "--genesis-state-url-timeout" "$genesis_state_url_timeout"
append_option "--graffiti" "$graffiti"
append_option "--historic-state-cache-size" "$historic_state_cache_size"
append_option "--http-address" "$http_address"
append_option "--http-allow-origin" "$http_allow_origin"
append_option "--http-duplicate-block-status" "$http_duplicate_block_status"
append_option "--http-enable-beacon-processor" "$http_enable_beacon_processor"
append_option "--http-port" "$http_port"
append_option "--http-spec-fork" "$http_spec_fork"
append_option "--http-sse-capacity-multiplier" "$http_sse_capacity_multiplier"
append_option "--http-tls-cert" "$http_tls_cert"
append_option "--http-tls-key" "$http_tls_key"
append_option "--invalid-gossip-verified-blocks-path" "$invalid_gossip_verified_blocks_path"
append_option "--libp2p-addresses" "$libp2p_addresses"
append_option "--listen-address" "$listen_address"
append_option "--log-format" "$log_format"
append_option "--logfile" "$logfile"
append_option "--logfile-debug-level" "$logfile_debug_level"
append_option "--logfile-format" "$logfile_format"
append_option "--logfile-max-number" "$logfile_max_number"
append_option "--logfile-max-size" "$logfile_max_size"
append_option "--max-skip-slots" "$max_skip_slots"
append_option "--metrics-address" "$metrics_address"
append_option "--metrics-allow-origin" "$metrics_allow_origin"
append_option "--metrics-port" "$metrics_port"
append_option "--monitoring-endpoint" "$monitoring_endpoint"
append_option "--monitoring-endpoint-period" "$monitoring_endpoint_period"
append_option "--network" "$network"
append_option "--network-dir" "$network_dir"
append_option "--port" "$port"
append_option "--port6" "$port6"
append_option "--prepare-payload-lookahead" "$prepare_payload_lookahead"
append_option "--progressive-balances" "$progressive_balances_mode"
append_option "--proposer-reorg-cutoff" "$proposer_reorg_cutoff"
append_option "--proposer-reorg-disallowed-offsets" "$proposer_reorg_disallowed_offsets"
append_option "--proposer-reorg-epochs-since-finalization" "$proposer_reorg_epochs_since_finalization"
append_option "--proposer-reorg-threshold" "$proposer_reorg_threshold"
append_option "--prune-blobs" "$prune_blobs"
append_option "--prune-payloads" "$prune_payloads"
append_option "--quic-port" "$quic_port"
append_option "--quic-port6" "$quic_port6"
append_option "--safe-slots-to-import-optimistically" "$safe_slots_to_import_optimistically"
append_option "--shuffling-cache-size" "$shuffling_cache_size"
append_option "--slasher-att-cache-size" "$slasher_att_cache_size"
append_option "--slasher-backend" "$slasher_backend"
append_option "--slasher-broadcast" "$slasher_broadcast"
append_option "--slasher-chunk-size" "$slasher_chunk_size"
append_option "--slasher-dir" "$slasher_dir"
append_option "--slasher-history-length" "$slasher_history_length"
append_option "--slasher-max-db-size" "$slasher_max_db_size"
append_option "--slasher-slot-offset" "$slasher_slot_offset"
append_option "--slasher-update-period" "$slasher_update_period"
append_option "--slasher-validator-chunk-size" "$slasher_validator_chunk_size"
append_option "--slots-per-restore-point" "$slots_per_restore_point"
append_option "--state-cache-size" "$state_cache_size"
append_option "--suggested-fee-recipient" "$suggested_fee_recipient"
append_option "--target-peers" "$target_peers"
append_option "--terminal-block-hash-epoch-override" "$terminal_block_hash_epoch_override"
append_option "--terminal-block-hash-override" "$terminal_block_hash_override"
append_option "--terminal-total-difficulty-override" "$terminal_total_difficulty_override"
append_option "--testnet-dir" "$testnet_dir"
append_option "--trusted-peers" "$trusted_peers"
append_option "--trusted-setup-file-override" "$trusted_setup_file_override"
append_option "--validator-monitor-file" "$validator_monitor_file"
append_option "--validator-monitor-individual-tracking-threshold" "$validator_monitor_individual_tracking_threshold"
append_option "--validator-monitor-pubkeys" "$validator_monitor_pubkeys"
append_option "--wss-checkpoint" "$wss_checkpoint"


echo "Starting lighthouse beacon_node $OPTIONS"
exec lighthouse beacon_node $OPTIONS