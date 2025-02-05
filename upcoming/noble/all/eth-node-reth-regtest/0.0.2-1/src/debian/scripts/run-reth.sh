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
    OPTIONS="$OPTIONS $option $value"
  fi
}

append_flag(){
 local option=$1
  local value=$2
  if [ "$value" = "true" ]; then
    OPTIONS="$OPTIONS $option"
  fi 
}

# Options
append_option "--config" "$config"
append_option "--chain" "$chain"
append_option "--instance" "$instance"
append_flag   "--with-unused-ports" "$with_unused_ports"

# Metrics
append_option "--metrics" "$metrics"

# Datadir
append_option "--datadir" "$datadir"
append_option "--datadir.static-files" "$datadir_static_files"

# Networking
append_flag   "--disable-discovery" "$disable_discovery"
append_flag   "--disable-dns-discovery" "$disable_dns_discovery"
append_flag   "--disable-discv4-discovery" "$disable_discv4_discovery"
append_flag   "--enable-discv5-discovery" "$enable_discv5_discovery"
append_flag   "--disable-nat" "$disable_nat"
append_option "--discovery.addr" "$discovery_addr"
append_option "--discovery.port" "$discovery_port"
append_option "--discovery.v5.addr" "$discovery_v5_addr"
append_option "--discovery.v5.addr.ipv6" "$discovery_v5_addr_ipv6"
append_option "--discovery.v5.port" "$discovery_v5_port"
append_option "--discovery.v5.port.ipv6" "$discovery_v5_port_ipv6"
append_option "--discovery.v5.lookup-interval" "$discovery_v5_lookup_interval"
append_option "--discovery.v5.bootstrap.lookup-interval" "$discovery_v5_bootstrap_lookup_interval"
append_option "--discovery.v5.bootstrap.lookup-countdown" "$discovery_v5_bootstrap_lookup_countdown"
append_option "--trusted-peers" "$trusted_peers"
append_flag   "--trusted-only" "$trusted_only"
append_option "--bootnodes" "$bootnodes"
append_option "--dns-retries" "$dns_retries"
append_option "--peers-file" "$peers_file"
append_option "--identity" "$identity"
append_option "--p2p-secret-key" "$p2p_secret_key"
append_flag   "--no-persist-peers" "$no_persist_peers"
append_option "--nat" "$nat"
append_option "--addr" "$addr"
append_option "--port" "$port"
append_option "--max-outbound-peers" "$max_outbound_peers"
append_option "--max-inbound-peers" "$max_inbound_peers"
append_option "--max-tx-reqs" "$max_tx_reqs"
append_option "--max-tx-reqs-peer" "$max_tx_reqs_peer"
append_option "--max-seen-tx-history" "$max_seen_tx_history"
append_option "--max-pending-imports" "$max_pending_imports"
append_option "--pooled-tx-response-soft-limit" "$pooled_tx_response_soft_limit"
append_option "--pooled-tx-pack-soft-limit" "$pooled_tx_pack_soft_limit"
append_option "--max-tx-pending-fetch" "$max_tx_pending_fetch"
append_option "--net-if.experimental" "$net_if_experimental"

# RPC options
append_flag   "--http" "$http"
append_option "--http.addr" "$http_addr"
append_option "--http.port" "$http_port"
append_option "--http.api" "$http_api"
append_option "--http.corsdomain" "$http_corsdomain"
append_flag   "--ws" "$ws"
append_option "--ws.addr" "$ws_addr"
append_option "--ws.port" "$ws_port"
append_option "--ws.origins" "$ws_origins"
append_option "--ws.api" "$ws_api"
append_flag   "--ipcdisable" "$ipcdisable"
append_option "--ipcpath" "$ipcpath"
append_option "--authrpc.addr" "$authrpc_addr"
append_option "--authrpc.port" "$authrpc_port"
append_option "--authrpc.jwtsecret" "$authrpc_jwtsecret"
append_flag   "--auth-ipc" "$auth_ipc"
append_option "--auth-ipc.path" "$auth_ipc_path"
append_option "--rpc.jwtsecret" "$rpc_jwtsecret"
append_option "--rpc.max-request-size" "$rpc_max_request_size"
append_option "--rpc.max-response-size" "$rpc_max_response_size"
append_option "--rpc.max-subscriptions-per-connection" "$rpc_max_subscriptions_per_connection"
append_option "--rpc.max-connections" "$rpc_max_connections"
append_option "--rpc.max-tracing-requests" "$rpc_max_tracing_requests"
append_option "--rpc.max-blocks-per-filter" "$rpc_max_blocks_per_filter"
append_option "--rpc.max-logs-per-response" "$rpc_max_logs_per_response"
append_option "--rpc.gascap" "$rpc_gascap"
append_option "--rpc.max-simulate-blocks" "$rpc_max_simulate_blocks"
append_option "--rpc.eth-proof-window" "$rpc_eth_proof_window"
append_option "--rpc.proof-permits" "$rpc_proof_permits"

# RPC State Cache:
append_option "--rpc-cache.max-blocks" "$rpc_cache_max_blocks"
append_option "--rpc-cache.max-receipts" "$rpc_cache_max_receipts"
append_option "--rpc-cache.max-envs" "$rpc_cache_max_envs"
append_option "--rpc-cache.max-concurrent-db-requests" "$rpc_cache_max_concurrent_db_requests"

# Gas Price Oracle:
append_option "--gpo.blocks" "$gpo_blocks"
append_option "--gpo.ignoreprice" "$gpo_ignoreprice"
append_option "--gpo.maxprice" "$gpo_maxprice"
append_option "--gpo.percentile" "$gpo_percentile"

# TxPool:
append_option "--txpool.pending-max-count" "$txpool_pending_max_count"
append_option "--txpool.pending-max-size" "$txpool_pending_max_size"
append_option "--txpool.basefee-max-count" "$txpool_basefee_max_count"
append_option "--txpool.basefee-max-size" "$txpool_basefee_max_size"
append_option "--txpool.queued-max-count" "$txpool_queued_max_count"
append_option "--txpool.queued-max-size" "$txpool_queued_max_size"
append_option "--txpool.max-account-slots" "$txpool_max_account_slots"
append_option "--txpool.pricebump" "$txpool_pricebump"
append_option "--txpool.minimal-protocol-fee" "$txpool_minimal_protocol_fee"
append_option "--txpool.gas-limit" "$txpool_gas_limit"
append_option "--blobpool.pricebump" "$blobpool_pricebump"
append_option "--txpool.max-tx-input-bytes" "$txpool_max_tx_input_bytes"
append_option "--txpool.max-cached-entries" "$txpool_max_cached_entries"
append_flag   "--txpool.nolocals" "$txpool_nolocals"
append_option "--txpool.locals" "$txpool_locals"
append_flag   "--txpool.no-local-transactions-propagation" "$txpool_no_local_transactions_propagation"
append_option "--txpool.additional-validation-tasks" "$txpool_additional_validation_tasks"
append_option "--txpool.max-pending-txns" "$txpool_max_pending_txns"
append_option "--txpool.max-new-txns" "$txpool_max_new_txns"

# Builder:
append_option "--builder.extradata" "$builder_extradata"
append_option "--builder.gaslimit" "$builder_gaslimit"
append_option "--builder.interval" "$builder_interval"
append_option "--builder.deadline" "$builder_deadline"
append_option "--builder.max-tasks" "$builder_max_tasks"

# Debug:
append_flag   "--debug.terminate" "$debug_terminate"
append_option "--debug.tip" "$debug_tip"
append_option "--debug.max-block" "$debug_max_block"
append_option "--debug.etherscan" "$debug_etherscan"
append_option "--debug.rpc-consensus-ws" "$debug_rpc_consensus_ws"
append_option "--debug.skip-fcu" "$debug_skip_fcu"
append_option "--debug.skip-new-payload" "$debug_skip_new_payload"
append_option "--debug.reorg-frequency" "$debug_reorg_frequency"
append_option "--debug.reorg-depth" "$debug_reorg_depth"
append_option "--debug.engine-api-store" "$debug_engine_api_store"
append_option "--debug.invalid-block-hook" "$debug_invalid_block_hook"
append_option "--debug.healthy-node-rpc-url" "$debug_healthy_node_rpc_url"

# Database:
append_option "--db.log-level" "$db_log_level"
append_option "--db.exclusive" "$db_exclusive"

# Dev testnet:
append_flag   "--dev" "$dev"
append_option "--dev.block-max-transactions" "$dev_block_max_transactions"
append_option "--dev.block-time" "$dev_block_time"

# Pruning:
append_flag   "--full" "$full"
append_option "--block-interval" "$block_interval"
append_flag   "--prune.senderrecovery.full" "$prune_senderrecovery_full"
append_option "--prune.senderrecovery.distance" "$prune_senderrecovery_distance"
append_option "--prune.senderrecovery.before" "$prune_senderrecovery_before"
append_flag   "--prune.transactionlookup.full" "$prune_transactionlookup_full"
append_option "--prune.transactionlookup.distance" "$prune_transactionlookup_distance"
append_option "--prune.transactionlookup.before" "$prune_transactionlookup_before"
append_flag   "--prune.receipts.full" "$prune_receipts_full"
append_option "--prune.receipts.distance" "$prune_receipts_distance"
append_option "--prune.receipts.before" "$prune_receipts_before"
append_flag   "--prune.accounthistory.full" "$prune_accounthistory_full"
append_option "--prune.accounthistory.distance" "$prune_accounthistory_distance"
append_option "--prune.accounthistory.before" "$prune_accounthistory_before"
append_flag   "--prune.storagehistory.full" "$prune_storagehistory_full"
append_option "--prune.storagehistory.distance" "$prune_storagehistory_distance"
append_option "--prune.storagehistory.before" "$prune_storagehistory_before"
append_option "--prune.receiptslogfilter" "$prune_receiptslogfilter"

# Engine:
append_flag   "--engine.experimental" "$engine_experimental"
append_flag   "--engine.legacy" "$engine_legacy"
append_option "--engine.persistence-threshold" "$engine_persistence_threshold"
append_option "--engine.memory-block-buffer-target" "$engine_memory_block_buffer_target"

# Logging:
append_option "--log.stdout.format" "$log_stdout_format"
append_option "--log.stdout.filter" "$log_stdout_filter"
append_option "--log.file.format" "$log_file_format"
append_option "--log.file.filter" "$log_file_filter"
append_option "--log.file.directory" "$log_file_directory"
append_option "--log.file.max-size" "$log_file_max_size"
append_option "--log.file.max-files" "$log_file_max_files"
append_flag   "--log.journald" "$log_journald"
append_option "--log.journald.filter" "$log_journald_filter"
append_option "--color" "$color"

# Display:
append_flag   "-v" "$verbosity"
append_flag   "-q" "$quiet"


echo "Starting node with options: reth node $OPTIONS"

exec reth node $OPTIONS