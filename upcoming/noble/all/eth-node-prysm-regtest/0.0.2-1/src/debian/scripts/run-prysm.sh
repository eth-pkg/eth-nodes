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

# Global options
append_flag   "--accept-terms-of-use" "$accept_terms_of_use"
append_option "--api-timeout" "$api_timeout"
append_option "--bootstrap-node" "$bootstrap_node"
append_option "--chain-config-file" "$chain_config_file"
append_flag   "--clear-db" "$clear_db"
append_option "--config-file" "$config_file"
append_option "--datadir" "$datadir"
append_flag   "--disable-monitoring" "$disable_monitoring"
append_flag   "--e2e-config" "$e2e_config"
append_flag   "--enable-tracing" "$enable_tracing"
append_flag   "--force-clear-db" "$force_clear_db"
append_option "--grpc-max-msg-size" "$grpc_max_msg_size"
append_option "--max-goroutines" "$max_goroutines"
append_flag   "--minimal-config" "$minimal_config"
append_option "--monitor-indices" "$monitor_indices"
append_option "--monitoring-host" "$monitoring_host"
append_option "--monitoring-port" "$monitoring_port"
append_flag   "--no-discovery" "$no_discovery"
append_option "--p2p-quic-port" "$p2p_quic_port"
append_option "--p2p-tcp-port" "$p2p_tcp_port"
append_option "--p2p-udp-port" "$p2p_udp_port"
append_option "--relay-node" "$relay_node"
append_option "--restore-source-file" "$restore_source_file"
append_option "--restore-target-dir" "$restore_target_dir"
append_option "--rpc-max-page-size" "$rpc_max_page_size"
append_option "--trace-sample-fraction" "$trace_sample_fraction"
append_option "--tracing-endpoint" "$tracing_endpoint"
append_option "--tracing-process-name" "$tracing_process_name"
append_option "--verbosity" "$verbosity"

# debug options
append_option "--blockprofilerate" "$blockprofilerate"
append_option "--cpuprofile" "$cpuprofile"
append_option "--memprofilerate" "$memprofilerate"
append_option "--mutexprofilefraction" "$mutexprofilefraction"
append_flag   "--pprof" "$pprof"
append_option "--pprofaddr" "$pprofaddr"
append_option "--pprofport" "$pprofport"
append_option "--trace" "$trace"

# beacon chain options
append_option "--backfill-batch-size" "$backfill_batch_size"
append_option "--backfill-oldest-slot" "$backfill_oldest_slot"
append_option "--backfill-worker-count" "$backfill_worker_count"
append_option "--blob-batch-limit" "$blob_batch_limit"
append_option "--blob-batch-limit-burst-factor" "$blob_batch_limit_burst_factor"
append_option "--blob-path" "$blob_path"
append_option "--blob-retention-epochs" "$blob_retention_epochs"
append_option "--block-batch-limit" "$block_batch_limit"
append_option "--block-batch-limit-burst-factor" "$block_batch_limit_burst_factor"
append_option "--chain-id" "$chain_id"
append_option "--checkpoint-block" "$checkpoint_block"
append_option "--checkpoint-state" "$checkpoint_state"
append_option "--checkpoint-sync-url" "$checkpoint_sync_url"
append_option "--contract-deployment-block" "$contract_deployment_block"
append_option "--deposit-contract" "$deposit_contract"
append_flag   "--disable-debug-rpc-endpoints" "$disable_debug_rpc_endpoints"
append_flag   "--disable-grpc-gateway" "$disable_grpc_gateway"
append_flag   "--enable-experimental-backfill" "$enable_experimental_backfill"
append_option "--engine-endpoint-timeout-seconds" "$engine_endpoint_timeout_seconds"
append_option "--eth1-header-req-limit" "$eth1_header_req_limit"
append_option "--execution-endpoint" "$execution_endpoint"
append_option "--execution-headers" "$execution_headers"
append_option "--gc-percent" "$gc_percent"
append_option "--genesis-beacon-api-url" "$genesis_beacon_api_url"
append_option "--genesis-state" "$genesis_state"
append_option "--grpc-gateway-corsdomain" "$grpc_gateway_corsdomain"
append_option "--grpc-gateway-host" "$grpc_gateway_host"
append_option "--grpc-gateway-port" "$grpc_gateway_port"
append_flag   "--historical-slasher-node" "$historical_slasher_node"
append_option "--http-mev-relay" "$http_mev_relay"
append_option "--http-modules" "$http_modules"
append_flag   "--interop-eth1data-votes" "$interop_eth1data_votes"
append_option "--jwt-id" "$jwt_id"
append_option "--jwt-secret" "$jwt_secret"
append_option "--local-block-value-boost" "$local_block_value_boost"
append_option "--max-builder-consecutive-missed-slots" "$max_builder_consecutive_missed_slots"
append_option "--max-builder-epoch-missed-slots" "$max_builder_epoch_missed_slots"
append_option "--max-concurrent-dials" "$max_concurrent_dials"
append_option "--min-builder-bid" "$min_builder_bid"
append_option "--min-builder-to-local-difference" "$min_builder_to_local_difference"
append_option "--minimum-peers-per-subnet" "$minimum_peers_per_subnet"
append_option "--network-id" "$network_id"
append_option "--rpc-host" "$rpc_host"
append_option "--rpc-port" "$rpc_port"
append_option "--slasher-datadir" "$slasher_datadir"
append_option "--slots-per-archive-point" "$slots_per_archive_point"
append_flag   "--subscribe-all-subnets" "$subscribe_all_subnets"
append_option "--tls-cert" "$tls_cert"
append_option "--tls-key" "$tls_key"
append_option "--weak-subjectivity-checkpoint" "$weak_subjectivity_checkpoint"

# merge options 
append_option "--suggested-fee-recipient" "$suggested_fee_recipient"
append_option "--terminal-block-hash-epoch-override" "$terminal_block_hash_epoch_override"
append_option "--terminal-block-hash-override" "$terminal_block_hash_override"
append_option "--terminal-total-difficulty-override" "$terminal_total_difficulty_override"

# p2p OPTIONS:
append_flag   "--enable-upnp" "$enable_upnp"
append_option "--min-sync-peers" "$min_sync_peers"
append_option "--p2p-allowlist" "$p2p_allowlist"
append_option "--p2p-denylist" "$p2p_denylist"
append_option "--p2p-host-dns" "$p2p_host_dns"
append_option "--p2p-host-ip" "$p2p_host_ip"
append_option "--p2p-local-ip" "$p2p_local_ip"
append_option "--p2p-max-peers" "$p2p_max_peers"
append_option "--p2p-metadata" "$p2p_metadata"
append_option "--p2p-priv-key" "$p2p_priv_key"
append_flag   "--p2p-static-id" "$p2p_static_id"
append_option "--peer" "$peer"
append_option "--pubsub-queue-size" "$pubsub_queue_size"

# log options
append_option "--log-file" "$log_file"
append_option "--log-format" "$log_format"

# features options 
append_flag "--blob-save-fsync" "$blob_save_fsync"
append_flag "--dev" "$dev"
append_flag "--disable-broadcast-slashings" "$disable_broadcast_slashings"
append_flag "--disable-grpc-connection-logging" "$disable_grpc_connection_logging"
append_flag "--disable-peer-scorer" "$disable_peer_scorer"
append_flag "--disable-registration-cache" "$disable_registration_cache"
append_flag "--disable-resource-manager" "$disable_resource_manager"
append_flag "--disable-staking-contract-check" "$disable_staking_contract_check"
append_flag "--disable-verbose-sig-verification" "$disable_verbose_sig_verification"
append_flag "--enable-committee-aware-packing" "$enable_committee_aware_packing"
append_flag "--enable-experimental-state" "$enable_experimental_state"
append_flag "--enable-full-ssz-data-logging" "$enable_full_ssz_data_logging"
append_flag "--enable-historical-state-representation" "$enable_historical_state_representation"
append_flag "--enable-lightclient" "$enable_lightclient"
append_flag "--enable-quic" "$enable_quic"
append_flag "--holesky" "$holesky"
append_flag "--interop-write-ssz-state-transitions" "$interop_write_ssz_state_transitions"
append_flag "--mainnet" "$mainnet"
append_flag "--prepare-all-payloads" "$prepare_all_payloads"
append_flag "--save-full-execution-payloads" "$save_full_execution_payloads"
append_flag "--save-invalid-blob-temp" "$save_invalid_blob_temp"
append_flag "--save-invalid-block-temp" "$save_invalid_block_temp"
append_flag "--sepolia" "$sepolia"
append_flag "--slasher" "$slasher" 

# interop options
append_option "--genesis-state" "$genesis_state"
append_option "--interop-genesis-time" "$interop_genesis_time"
append_option "--interop-num-validators" "$interop_num_validators"

# deprecated options
append_option "--db-backup-output-dir" "$db_backup_output_dir"



echo "Using Options: beacon-chain $OPTIONS"

# on ci the postrm fails, so it not in path
exec beacon-chain $OPTIONS