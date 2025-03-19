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

# OPTIONS
append_flag   "--auto-log-bloom-caching-enabled" "$auto_log_bloom_caching_enabled"
append_option "--bonsai-historical-block-limit" "$bonsai_historical_block_limit"
append_flag   "--bonsai-limit-trie-logs-enabled" "$bonsai_limit_trie_logs_enabled"
append_option "--bonsai-trie-logs-pruning-window-size" "$bonsai_trie_logs_pruning_window_size"
append_option "--cache-last-blocks" "$cache_last_blocks"
append_flag   "--compatibility-eth64-forkid-enabled" "$compatibility_eth64_forkid_enabled"
append_option "--config-file" "$config_file"
append_option "--data-path" "$data_path"
append_option "--data-storage-format" "$data_storage_format"
append_option "--ethstats" "$ethstats_url"
append_option "--ethstats-cacert-file" "$ethstats_cacert_file"
append_option "--ethstats-contact" "$ethstats_contact"
append_option "--genesis-file" "$genesis_file"
append_flag   "--genesis-state-hash-cache-enabled" "$genesis_state_hash_cache_enabled"
append_option "--host-allowlist" "$host_allowlist"
append_option "--identity" "$identity"
append_option "--key-value-storage" "$key_value_storage"
append_option "--kzg-trusted-setup" "$kzg_trusted_setup"
append_option "--logging" "$logging"
append_option "--nat-method" "$nat_method"
append_option "--network" "$network"
append_option "--network-id" "$network_id"
append_option "--node-private-key-file" "$node_private_key_file"
append_option "--pid-path" "$pid_path"
append_option "--profile" "$profile"
append_option "--reorg-logging-threshold" "$reorg_logging_threshold"
append_flag   "--receipt-compaction-enabled" "$receipt_compaction_enabled"
append_option "--required-block" "$required_block"
append_flag   "--revert-reason-enabled" "$revert_reason_enabled"
append_option "--security-module" "$security_module"
append_option "--static-nodes-file" "$static_nodes_file"
append_option "--sync-min-peers" "$sync_min_peers"
append_option "--sync-mode" "$sync_mode"
append_flag   "--version-compatibility-protection" "$version_compatibility_protection"

# Tx Pool Layered Implementation Options
append_option "--tx-pool-layer-max-capacity" "$tx_pool_layer_max_capacity"
append_option "--tx-pool-max-future-by-sender" "$tx_pool_max_future_by_sender"
append_option "--tx-pool-max-prioritized" "$tx_pool_max_prioritized"
append_option "--tx-pool-max-prioritized-by-type" "$tx_pool_max_prioritized_by_type"
append_option "--tx-pool-min-score" "$tx_pool_min_score"

# Tx Pool Sequenced Implementation Options
append_option "--tx-pool-limit-by-account-percentage" "$tx_pool_limit_by_account_percentage"
append_option "--tx-pool-max-size" "$tx_pool_max_size"
append_option "--tx-pool-retention-hours" "$tx_pool_retention_hours"

# Tx Pool Common Options
append_option "--rpc-tx-feecap" "$rpc_tx_feecap"
append_flag   "--strict-tx-replay-protection-enabled" "$strict_tx_replay_protection_enabled"
append_option "--tx-pool" "$tx_pool"
append_option "--tx-pool-blob-price-bump" "$tx_pool_blob_price_bump"
append_option "--tx-pool-disable-locals" "$tx_pool_disable_locals"
append_option "--tx-pool-enable-save-restore" "$tx_pool_enable_save_restore"
append_option "--tx-pool-min-gas-price" "$tx_pool_min_gas_price"
append_option "--tx-pool-price-bump" "$tx_pool_price_bump"
append_option "--tx-pool-priority-senders" "$tx_pool_priority_senders"
append_option "--tx-pool-save-file" "$tx_pool_save_file"

# Block Builder Options
append_option "--block-txs-selection-max-time" "$block_txs_selection_max_time"
append_option "--min-block-occupancy-ratio" "$min_block_occupancy_ratio"
append_option "--min-gas-price" "$min_gas_price"
append_option "--min-priority-fee" "$min_priority_fee"
append_flag   "--miner-enabled" "$miner_enabled"
append_option "--miner-coinbase" "$miner_coinbase"
append_option "--miner-extra-data" "$miner_extra_data"
append_flag   "--miner-stratum-enabled" "$miner_stratum_enabled"
append_option "--miner-stratum-host" "$miner_stratum_host"
append_option "--miner-stratum-port" "$miner_stratum_port"
append_option "--poa-block-txs-selection-max-time" "$poa_block_txs_selection_max_time"
append_option "--target-gas-limit" "$target_gas_limit"

# P2P Discovery Options
append_option "--banned-node-ids" "$banned_node_ids"
append_option "--bootnodes" "$bootnodes"
append_option "--discovery-dns-url" "$discovery_dns_url"
append_flag   "--discovery-enabled" "$discovery_enabled"
append_option "--max-peers" "$max_peers"
append_option "--net-restrict" "$net_restrict"
append_flag   "--p2p-enabled" "$p2p_enabled"
append_option "--p2p-host" "$p2p_host"
append_option "--p2p-interface" "$p2p_interface"
append_option "--p2p-port" "$p2p_port"
append_option "--poa-discovery-retry-bootnodes" "$p2p_poa_discovery_retry_bootnodes"
append_flag   "--random-peer-priority-enabled" "$random_peer_priority_enabled"
append_flag   "--remote-connections-limit-enabled" "$remote_connections_limit_enabled"
append_option "--remote-connections-max-percentage" "$remote_connections_max_percentage"

# GraphQL Options
append_option "--graphql-http-cors-origins" "$graphql_http_cors_origins"
append_flag   "--graphql-http-enabled" "$graphql_http_enabled"
append_option "--graphql-http-host" "$graphql_http_host"
append_option "--graphql-http-port" "$graphql_http_port"

# Engine JSON-RPC Options
append_option "--engine-host-allowlist" "$engine_host_allowlist"
append_option "--engine-jwt-disabled" "$engine_jwt_disabled"
append_option "--engine-jwt-secret" "$engine_jwt_secret"
append_flag   "--engine-rpc-enabled" "$engine_rpc_enabled"
append_option "--engine-rpc-port" "$engine_rpc_port"

# JSON-RPC HTTP Options
append_flag   "--json-pretty-print-enabled" "$json_pretty_print_enabled"
append_option "--rpc-http-api" "$rpc_http_api"
append_option "--rpc-http-api-method-no-auth" "$rpc_http_api_method_no_auth"
append_option "--rpc-http-authentication-credentials-file" "$rpc_http_authentication_credentials_file"
append_flag   "--rpc-http-authentication-enabled" "$rpc_http_authentication_enabled"
append_option "--rpc-http-authentication-jwt-algorithm" "$rpc_http_authentication_jwt_algorithm"
append_option "--rpc-http-authentication-jwt-public-key-file" "$rpc_http_authentication_jwt_public_key_file"
append_option "--rpc-http-cors-origins" "$rpc_http_cors_origins"
append_flag   "--rpc-http-enabled" "$rpc_http_enabled"
append_option "--rpc-http-host" "$rpc_http_host"
append_option "--rpc-http-max-active-connections" "$rpc_http_max_active_connections"
append_option "--rpc-http-max-batch-size" "$rpc_http_max_batch_size"
append_option "--rpc-http-max-request-content-length" "$rpc_http_max_request_content_length"
append_option "--rpc-http-port" "$rpc_http_port"
append_flag   "--rpc-http-tls-ca-clients-enabled" "$rpc_http_tls_ca_clients_enabled"
append_option "--rpc-http-tls-cipher-suites" "$rpc_http_tls_cipher_suites"
append_flag   "--rpc-http-tls-client-auth-enabled" "$rpc_http_tls_client_auth_enabled"
append_flag   "--rpc-http-tls-enabled" "$rpc_http_tls_enabled"
append_option "--rpc-http-tls-keystore-file" "$rpc_http_tls_keystore_file"
append_option "--rpc-http-tls-keystore-password-file" "$rpc_http_tls_keystore_password_file"
append_option "--rpc-http-tls-known-clients-file" "$rpc_http_tls_known_clients_file"
append_option "--rpc-http-tls-protocols" "$rpc_http_tls_protocols"

# JSON-RPC Websocket Options
append_option "--rpc-ws-api" "$rpc_ws_api"
append_option "--rpc-ws-api-method-no-auth" "$rpc_ws_api_method_no_auth"
append_option "--rpc-ws-authentication-credentials-file" "$rpc_ws_authentication_credentials_file"
append_flag   "--rpc-ws-authentication-enabled" "$rpc_ws_authentication_enabled"
append_option "--rpc-ws-authentication-jwt-algorithm" "$rpc_ws_authentication_jwt_algorithm"
append_option "--rpc-ws-authentication-jwt-public-key-file" "$rpc_ws_authentication_jwt_public_key_file"
append_flag   "--rpc-ws-enabled" "$rpc_ws_enabled"
append_option "--rpc-ws-host" "$rpc_ws_host"
append_option "--rpc-ws-max-active-connections" "$rpc_ws_max_active_connections"
append_option "--rpc-ws-max-frame-size" "$rpc_ws_max_frame_size"
append_option "--rpc-ws-port" "$rpc_ws_port"

# In-Process RPC Options
# Privacy Options
append_flag   "--privacy-enable-database-migration" "$privacy_enable_database_migration"
append_flag   "--privacy-enabled" "$privacy_enabled"
append_flag   "--privacy-flexible-groups-enabled" "$privacy_flexible_groups_enabled"
append_option "--privacy-marker-transaction-signing-key-file" "$privacy_marker_transaction_signing_key_file"
append_flag   "--privacy-multi-tenancy-enabled" "$privacy_multi_tenancy_enabled"
append_option "--privacy-public-key-file" "$privacy_public_key_file"
append_flag   "--privacy-tls-enabled" "$privacy_tls_enabled"
append_option "--privacy-tls-keystore-file" "$privacy_tls_keystore_file"
append_option "--privacy-tls-keystore-password-file" "$privacy_tls_keystore_password_file"
append_option "--privacy-tls-known-enclave-file" "$privacy_tls_known_enclave_file"
append_option "--privacy-url" "$privacy_url"

# Metrics Options
append_option "--metrics-category" "$metrics_category"
append_flag   "--metrics-enabled" "$metrics_enabled"
append_option "--metrics-host" "$metrics_host"
append_option "--metrics-port" "$metrics_port"
append_option "--metrics-protocol" "$metrics_protocol"
append_flag   "--metrics-push-enabled" "$metrics_push_enabled"
append_option "--metrics-push-host" "$metrics_push_host"
append_option "--metrics-push-interval" "$metrics_push_interval"
append_option "--metrics-push-port" "$metrics_push_port"
append_option "--metrics-push-prometheus-job" "$metrics_push_prometheus_job"

# Permissions Options
append_option "--permissions-accounts-config-file" "$permissions_accounts_config_file"
append_flag   "--permissions-accounts-config-file-enabled" "$permissions_accounts_config_file_enabled"
append_option "--permissions-accounts-contract-address" "$permissions_accounts_contract_address"
append_flag   "--permissions-accounts-contract-enabled" "$permissions_accounts_contract_enabled"
append_option "--permissions-nodes-config-file" "$permissions_nodes_config_file"
append_flag   "--permissions-nodes-config-file-enabled" "$permissions_nodes_config_file_enabled"
append_option "--permissions-nodes-contract-address" "$permissions_nodes_contract_address"
append_flag   "--permissions-nodes-contract-enabled" "$permissions_nodes_contract_enabled"
append_option "--permissions-nodes-contract-version" "$permissions_nodes_contract_version"

# API Configuration Options
append_option "--api-gas-price-blocks" "$api_gas_price_blocks"
append_option "--api-gas-price-max" "$api_gas_price_max"
append_option "--api-gas-price-percentile" "$api_gas_price_percentile"
append_option "--rpc-gas-cap" "$rpc_gas_cap"
append_option "--rpc-max-logs-range" "$rpc_max_logs_range"
append_option "--rpc-max-trace-filter-range" "$rpc_max_trace_filter_range"



echo "Running: LOG4J_CONFIGURATION_FILE=/usr/lib/eth-node-besu-regtest/admin.xml besu $OPTIONS"

LOG4J_CONFIGURATION_FILE=/usr/lib/eth-node-besu-regtest/admin.xml exec besu $OPTIONS