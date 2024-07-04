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

append_flag "--auto-log-bloom-caching-enabled" "$BESU_CLI_AUTO_LOG_BLOOM_CACHING_ENABLED"
append_flag "--compatibility-eth64-forkid-enabled" "$BESU_CLI_COMPATIBILITY_ETH64_FORKID_ENABLED"
append_flag "--genesis-state-hash-cache-enabled" "$BESU_CLI_GENESIS_STATE_HASH_CACHE_ENABLED"
append_flag "--receipt-compaction-enabled" "$BESU_CLI_RECEIPT_COMPACTION_ENABLED"
append_flag "--revert-reason-enabled" "$BESU_CLI_REVERT_REASON_ENABLED"
append_flag "--strict-tx-replay-protection-enabled" "$BESU_CLI_STRICT_TX_REPLAY_PROTECTION_ENABLED"
append_flag "--miner-enabled" "$BESU_CLI_MINER_ENABLED"
append_flag "--miner-stratum-enabled" "$BESU_CLI_MINER_STRATUM_ENABLED"
append_flag "--discovery-enabled" "$BESU_CLI_DISCOVERY_ENABLED"
append_flag "--p2p-enabled" "$BESU_CLI_P2P_ENABLED"
append_flag "--random-peer-priority-enabled" "$BESU_CLI_RANDOM_PEER_PRIORITY_ENABLED"
append_flag "--remote-connections-limit-enabled" "$BESU_CLI_REMOTE_CONNECTIONS_LIMIT_ENABLED"
append_flag "--graphql-http-enabled" "$BESU_CLI_GRAPHQL_HTTP_ENABLED"
append_flag "--engine-rpc-enabled" "$BESU_CLI_ENGINE_RPC_ENABLED"
append_flag "--json-pretty-print-enabled" "$BESU_CLI_JSON_PRETTY_PRINT_ENABLED"
append_flag "--rpc-http-authentication-enabled" "$BESU_CLI_RPC_HTTP_AUTHENTICATION_ENABLED"
append_flag "--rpc-http-enabled" "$BESU_CLI_RPC_HTTP_ENABLED"
append_flag "--rpc-http-tls-ca-clients-enabled" "$BESU_CLI_RPC_HTTP_TLS_CA_CLIENTS_ENABLED"
append_flag "--rpc-http-tls-client-auth-enabled" "$BESU_CLI_RPC_HTTP_TLS_CLIENT_AUTH_ENABLED"
append_flag "--rpc-http-tls-enabled" "$BESU_CLI_RPC_HTTP_TLS_ENABLED"
append_flag "--rpc-ws-authentication-enabled" "$BESU_CLI_RPC_WS_AUTHENTICATION_ENABLED"
append_flag "--rpc-ws-enabled" "$BESU_CLI_RPC_WS_ENABLED"
append_flag "--privacy-enabled" "$BESU_CLI_PRIVACY_ENABLED"
append_flag "--privacy-flexible-groups-enabled" "$BESU_CLI_PRIVACY_FLEXIBLE_GROUPS_ENABLED"
append_flag "--privacy-multi-tenancy-enabled" "$BESU_CLI_PRIVACY_MULTI_TENANCY_ENABLED"
append_flag "--privacy-tls-enabled" "$BESU_CLI_PRIVACY_TLS_ENABLED"
append_flag "--metrics-enabled" "$BESU_CLI_METRICS_ENABLED"
append_flag "--metrics-push-enabled" "$BESU_CLI_METRICS_PUSH_ENABLED"
append_flag "--permissions-accounts-config-file-enabled" "$BESU_CLI_PERMISSIONS_ACCOUNTS_CONFIG_FILE_ENABLED"
append_flag "--permissions-accounts-contract-enabled" "$BESU_CLI_PERMISSIONS_ACCOUNTS_CONTRACT_ENABLED"
append_flag "--permissions-nodes-config-file-enabled" "$BESU_CLI_PERMISSIONS_NODES_CONFIG_FILE_ENABLED"
append_flag "--permissions-nodes-contract-enabled" "$BESU_CLI_PERMISSIONS_NODES_CONTRACT_ENABLED"



append_option "--bonsai-historical-block-limit" "$BESU_CLI_BONSAI_HISTORICAL_BLOCK_LIMIT"
append_option "--cache-last-blocks" "$BESU_CLI_CACHE_LAST_BLOCKS"
append_option "--config-file" "$BESU_CLI_CONFIG_FILE"
append_option "--data-path" "$BESU_CLI_DATA_PATH"
append_option "--data-storage-format" "$BESU_CLI_DATA_STORAGE_FORMAT"
append_option "--ethstats" "$BESU_CLI_ETHSTATS_URL"
append_option "--ethstats-cacert-file" "$BESU_CLI_ETHSTATS_CACERT_FILE"
append_option "--ethstats-contact" "$BESU_CLI_ETHSTATS_CONTACT"
append_option "--genesis-file" "$BESU_CLI_GENESIS_FILE"
append_option "--host-allowlist" "$BESU_CLI_HOST_ALLOWLIST"
append_option "--identity" "$BESU_CLI_IDENTITY"
append_option "--key-value-storage" "$BESU_CLI_KEY_VALUE_STORAGE"
append_option "--kzg-trusted-setup" "$BESU_CLI_KZG_TRUSTED_SETUP"
append_option "--logging" "$BESU_CLI_LOGGING"
append_option "--nat-method" "$BESU_CLI_NAT_METHOD"
append_option "--network" "$BESU_CLI_NETWORK"
append_option "--network-id" "$BESU_CLI_NETWORK_ID"
append_option "--node-private-key-file" "$BESU_CLI_NODE_PRIVATE_KEY_FILE"
append_option "--pid-path" "$BESU_CLI_PID_PATH"
append_option "--profile" "$BESU_CLI_PROFILE"
append_option "--reorg-logging-threshold" "$BESU_CLI_REORG_LOGGING_THRESHOLD"
append_option "--required-block" "$BESU_CLI_REQUIRED_BLOCK"
append_option "--security-module" "$BESU_CLI_SECURITY_MODULE"
append_option "--static-nodes-file" "$BESU_CLI_STATIC_NODES_FILE"
append_option "--sync-min-peers" "$BESU_CLI_SYNC_MIN_PEERS"
append_option "--sync-mode" "$BESU_CLI_SYNC_MODE"
append_option "--tx-pool-layer-max-capacity" "$BESU_CLI_TX_POOL_LAYER_MAX_CAPACITY"
append_option "--tx-pool-max-future-by-sender" "$BESU_CLI_TX_POOL_MAX_FUTURE_BY_SENDER"
append_option "--tx-pool-max-prioritized" "$BESU_CLI_TX_POOL_MAX_PRIORITIZED"
append_option "--tx-pool-max-prioritized-by-type" "$BESU_CLI_TX_POOL_MAX_PRIORITIZED_BY_TYPE"
append_option "--tx-pool-limit-by-account-percentage" "$BESU_CLI_TX_POOL_LIMIT_BY_ACCOUNT_PERCENTAGE"
append_option "--tx-pool-max-size" "$BESU_CLI_TX_POOL_MAX_SIZE"
append_option "--tx-pool-retention-hours" "$BESU_CLI_TX_POOL_RETENTION_HOURS"
append_option "--rpc-tx-feecap" "$BESU_CLI_RPC_TX_FEECAP"
append_option "--tx-pool" "$BESU_CLI_TX_POOL"
append_option "--tx-pool-blob-price-bump" "$BESU_CLI_TX_POOL_BLOB_PRICE_BUMP"
append_option "--tx-pool-disable-locals" "$BESU_CLI_TX_POOL_DISABLE_LOCALS"
append_option "--tx-pool-enable-save-restore" "$BESU_CLI_TX_POOL_ENABLE_SAVE_RESTORE"
append_option "--tx-pool-min-gas-price" "$BESU_CLI_TX_POOL_MIN_GAS_PRICE"
append_option "--tx-pool-price-bump" "$BESU_CLI_TX_POOL_PRICE_BUMP"
append_option "--tx-pool-priority-senders" "$BESU_CLI_TX_POOL_PRIORITY_SENDERS"
append_option "--tx-pool-save-file" "$BESU_CLI_TX_POOL_SAVE_FILE"
append_option "--block-txs-selection-max-time" "$BESU_CLI_BLOCK_TXS_SELECTION_MAX_TIME"
append_option "--min-block-occupancy-ratio" "$BESU_CLI_MIN_BLOCK_OCCUPANCY_RATIO"
append_option "--min-gas-price" "$BESU_CLI_MIN_GAS_PRICE"
append_option "--min-priority-fee" "$BESU_CLI_MIN_PRIORITY_FEE"
append_option "--miner-coinbase" "$BESU_CLI_MINER_COINBASE"
append_option "--miner-extra-data" "$BESU_CLI_MINER_EXTRA_DATA"
append_option "--miner-stratum-host" "$BESU_CLI_MINER_STRATUM_HOST"
append_option "--miner-stratum-port" "$BESU_CLI_MINER_STRATUM_PORT"
append_option "--poa-block-txs-selection-max-time" "$BESU_CLI_POA_BLOCK_TXS_SELECTION_MAX_TIME"
append_option "--target-gas-limit" "$BESU_CLI_TARGET_GAS_LIMIT"
append_option "--banned-node-ids" "$BESU_CLI_BANNED_NODE_IDS"
append_option "--bootnodes" "$BESU_CLI_BOOTNODES"
append_option "--discovery-dns-url" "$BESU_CLI_DISCOVERY_DNS_URL"
append_option "--max-peers" "$BESU_CLI_MAX_PEERS"
append_option "--p2p-host" "$BESU_CLI_P2P_HOST"
append_option "--p2p-interface" "$BESU_CLI_P2P_INTERFACE"
append_option "--p2p-port" "$BESU_CLI_P2P_PORT"
append_option "--remote-connections-max-percentage" "$BESU_CLI_REMOTE_CONNECTIONS_MAX_PERCENTAGE"
append_option "--graphql-http-cors-origins" "$BESU_CLI_GRAPHQL_HTTP_CORS_ORIGINS"
append_option "--graphql-http-host" "$BESU_CLI_GRAPHQL_HTTP_HOST"
append_option "--graphql-http-port" "$BESU_CLI_GRAPHQL_HTTP_PORT"
append_option "--engine-host-allowlist" "$BESU_CLI_ENGINE_HOST_ALLOWLIST"
append_option "--engine-jwt-disabled" "$BESU_CLI_ENGINE_JWT_DISABLED"
append_option "--engine-jwt-secret" "$BESU_CLI_ENGINE_JWT_SECRET"
append_option "--engine-rpc-port" "$BESU_CLI_ENGINE_RPC_PORT"
append_option "--rpc-http-api" "$BESU_CLI_RPC_HTTP_API"
append_option "--rpc-http-api-method-no-auth" "$BESU_CLI_RPC_HTTP_API_METHOD_NO_AUTH"
append_option "--rpc-http-authentication-credentials-file" "$BESU_CLI_RPC_HTTP_AUTHENTICATION_CREDENTIALS_FILE"
append_option "--rpc-http-authentication-jwt-algorithm" "$BESU_CLI_RPC_HTTP_AUTHENTICATION_JWT_ALGORITHM"
append_option "--rpc-http-authentication-jwt-public-key-file" "$BESU_CLI_RPC_HTTP_AUTHENTICATION_JWT_PUBLIC_KEY_FILE"
append_option "--rpc-http-cors-origins" "$BESU_CLI_RPC_HTTP_CORS_ORIGINS"
append_option "--rpc-http-host" "$BESU_CLI_RPC_HTTP_HOST"
append_option "--rpc-http-max-active-connections" "$BESU_CLI_RPC_HTTP_MAX_ACTIVE_CONNECTIONS"
append_option "--rpc-http-max-batch-size" "$BESU_CLI_RPC_HTTP_MAX_BATCH_SIZE"
append_option "--rpc-http-max-request-content-length" "$BESU_CLI_RPC_HTTP_MAX_REQUEST_CONTENT_LENGTH"
append_option "--rpc-http-port" "$BESU_CLI_RPC_HTTP_PORT"
append_option "--rpc-http-tls-cipher-suites" "$BESU_CLI_RPC_HTTP_TLS_CIPHER_SUITES"

append_option "--rpc-http-tls-keystore-file" "$BESU_CLI_RPC_HTTP_TLS_KEYSTORE_FILE"
append_option "--rpc-http-tls-keystore-password-file" "$BESU_CLI_RPC_HTTP_TLS_KEYSTORE_PASSWORD_FILE"
append_option "--rpc-http-tls-known-clients-file" "$BESU_CLI_RPC_HTTP_TLS_KNOWN_CLIENTS_FILE"
append_option "--rpc-http-tls-protocols" "$BESU_CLI_RPC_HTTP_TLS_PROTOCOLS"
append_option "--rpc-ws-api" "$BESU_CLI_RPC_WS_API"
append_option "--rpc-ws-api-method-no-auth" "$BESU_CLI_RPC_WS_API_METHOD_NO_AUTH"
append_option "--rpc-ws-authentication-credentials-file" "$BESU_CLI_RPC_WS_AUTHENTICATION_CREDENTIALS_FILE"
append_option "--rpc-ws-authentication-jwt-algorithm" "$BESU_CLI_RPC_WS_AUTHENTICATION_JWT_ALGORITHM"
append_option "--rpc-ws-authentication-jwt-public-key-file" "$BESU_CLI_RPC_WS_AUTHENTICATION_JWT_PUBLIC_KEY_FILE"
append_option "--rpc-ws-host" "$BESU_CLI_RPC_WS_HOST"
append_option "--rpc-ws-max-active-connections" "$BESU_CLI_RPC_WS_MAX_ACTIVE_CONNECTIONS"
append_option "--rpc-ws-max-frame-size" "$BESU_CLI_RPC_WS_MAX_FRAME_SIZE"
append_option "--rpc-ws-port" "$BESU_CLI_RPC_WS_PORT"
append_option "--privacy-enable-database-migration" "$BESU_CLI_PRIVACY_ENABLE_DATABASE_MIGRATION"

append_option "--privacy-marker-transaction-signing-key-file" "$BESU_CLI_PRIVACY_MARKER_TRANSACTION_SIGNING_KEY_FILE"
append_option "--privacy-public-key-file" "$BESU_CLI_PRIVACY_PUBLIC_KEY_FILE"
append_option "--privacy-tls-keystore-file" "$BESU_CLI_PRIVACY_TLS_KEYSTORE_FILE"
append_option "--privacy-tls-keystore-password-file" "$BESU_CLI_PRIVACY_TLS_KEYSTORE_PASSWORD_FILE"
append_option "--privacy-tls-known-enclave-file" "$BESU_CLI_PRIVACY_TLS_KNOWN_ENCLAVE_FILE"
append_option "--privacy-url" "$BESU_CLI_PRIVACY_URL"
append_option "--metrics-category" "$BESU_CLI_METRICS_CATEGORY"
append_option "--metrics-host" "$BESU_CLI_METRICS_HOST"
append_option "--metrics-port" "$BESU_CLI_METRICS_PORT"
append_option "--metrics-protocol" "$BESU_CLI_METRICS_PROTOCOL"
append_option "--metrics-push-host" "$BESU_CLI_METRICS_PUSH_HOST"
append_option "--metrics-push-interval" "$BESU_CLI_METRICS_PUSH_INTERVAL"
append_option "--metrics-push-port" "$BESU_CLI_METRICS_PUSH_PORT"
append_option "--metrics-push-prometheus-job" "$BESU_CLI_METRICS_PUSH_PROMETHEUS_JOB"
append_option "--permissions-accounts-config-file" "$BESU_CLI_PERMISSIONS_ACCOUNTS_CONFIG_FILE"
append_option "--permissions-accounts-contract-address" "$BESU_CLI_PERMISSIONS_ACCOUNTS_CONTRACT_ADDRESS"
append_option "--permissions-nodes-config-file" "$BESU_CLI_PERMISSIONS_NODES_CONFIG_FILE"
append_option "--permissions-nodes-contract-address" "$BESU_CLI_PERMISSIONS_NODES_CONTRACT_ADDRESS"
append_option "--permissions-nodes-contract-version" "$BESU_CLI_PERMISSIONS_NODES_CONTRACT_VERSION"
append_option "--api-gas-price-blocks" "$BESU_CLI_API_GAS_PRICE_BLOCKS"
append_option "--api-gas-price-max" "$BESU_CLI_API_GAS_PRICE_MAX"
append_option "--api-gas-price-percentile" "$BESU_CLI_API_GAS_PRICE_PERCENTILE"
append_option "--rpc-gas-cap" "$BESU_CLI_RPC_GAS_CAP"
append_option "--rpc-max-logs-range" "$BESU_CLI_RPC_MAX_LOGS_RANGE"
append_option "--rpc-max-trace-filter-range" "$BESU_CLI_RPC_MAX_TRACE_FILTER_RANGE"

# TODO missing options
append_option "--bonsai-limit-trie-logs-enabled" "$BESU_CLI_BONSAI_LIMIT_TRIE_LOGS_ENABLED"

echo "Running: besu $OPTIONS"

besu $OPTIONS