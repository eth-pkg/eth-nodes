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

# OPTIONS
append_flag "--auto-log-bloom-caching-enabled" "$AUTO_LOG_BLOOM_CACHING_ENABLED"
append_option "--bonsai-historical-block-limit" "$BONSAI_HISTORICAL_BLOCK_LIMIT"
append_flag "--bonsai-limit-trie-logs-enabled" "$BONSAI_LIMIT_TRIE_LOGS_ENABLED"
append_option "--bonsai-trie-logs-pruning-window-size" "$BONSAI_TRIE_LOGS_PRUNING_WINDOW_SIZE"
append_option "--cache-last-blocks" "$CACHE_LAST_BLOCKS"
append_flag "--compatibility-eth64-forkid-enabled" "$COMPATIBILITY_ETH64_FORKID_ENABLED"
append_option "--config-file" "$BESU_CONFIG_FILE"
append_option "--data-path" "$DATA_PATH"
append_option "--data-storage-format" "$DATA_STORAGE_FORMAT"
append_option "--ethstats" "$ETHSTATS_URL"
append_option "--ethstats-cacert-file" "$ETHSTATS_CACERT_FILE"
append_option "--ethstats-contact" "$ETHSTATS_CONTACT"
append_option "--genesis-file" "$GENESIS_FILE"
append_flag "--genesis-state-hash-cache-enabled" "$GENESIS_STATE_HASH_CACHE_ENABLED"
append_option "--host-allowlist" "$HOST_ALLOWLIST"
append_option "--identity" "$IDENTITY"
append_option "--key-value-storage" "$KEY_VALUE_STORAGE"
append_option "--kzg-trusted-setup" "$KZG_TRUSTED_SETUP"
append_option "--logging" "$LOGGING"
append_option "--nat-method" "$NAT_METHOD"
append_option "--network" "$NETWORK"
append_option "--network-id" "$NETWORK_ID"
append_option "--node-private-key-file" "$NODE_PRIVATE_KEY_FILE"
append_option "--pid-path" "$PID_PATH"
append_option "--profile" "$PROFILE"
append_option "--reorg-logging-threshold" "$REORG_LOGGING_THRESHOLD"
append_flag "--receipt-compaction-enabled" "$RECEIPT_COMPACTION_ENABLED"
append_option "--required-block" "$REQUIRED_BLOCK"
append_flag "--revert-reason-enabled" "$REVERT_REASON_ENABLED"
append_option "--security-module" "$SECURITY_MODULE"
append_option "--static-nodes-file" "$STATIC_NODES_FILE"
append_option "--sync-min-peers" "$SYNC_MIN_PEERS"
append_option "--sync-mode" "$SYNC_MODE"
append_flag "--version-compatibility-protection" "$VERSION_COMPATIBILITY_PROTECTION"

# Tx Pool Layered Implementation Options
append_option "--tx-pool-layer-max-capacity" "$TX_POOL_LAYER_MAX_CAPACITY"
append_option "--tx-pool-max-future-by-sender" "$TX_POOL_MAX_FUTURE_BY_SENDER"
append_option "--tx-pool-max-prioritized" "$TX_POOL_MAX_PRIORITIZED"
append_option "--tx-pool-max-prioritized-by-type" "$TX_POOL_MAX_PRIORITIZED_BY_TYPE"
append_option "--tx-pool-min-score" "$TX_POOL_MIN_SCORE"

# Tx Pool Sequenced Implementation Options
append_option "--tx-pool-limit-by-account-percentage" "$TX_POOL_LIMIT_BY_ACCOUNT_PERCENTAGE"
append_option "--tx-pool-max-size" "$TX_POOL_MAX_SIZE"
append_option "--tx-pool-retention-hours" "$TX_POOL_RETENTION_HOURS"

# Tx Pool Common Options
append_option "--rpc-tx-feecap" "$RPC_TX_FEECAP"
append_flag "--strict-tx-replay-protection-enabled" "$STRICT_TX_REPLAY_PROTECTION_ENABLED"
append_option "--tx-pool" "$TX_POOL"
append_option "--tx-pool-blob-price-bump" "$TX_POOL_BLOB_PRICE_BUMP"
append_option "--tx-pool-disable-locals" "$TX_POOL_DISABLE_LOCALS"
append_option "--tx-pool-enable-save-restore" "$TX_POOL_ENABLE_SAVE_RESTORE"
append_option "--tx-pool-min-gas-price" "$TX_POOL_MIN_GAS_PRICE"
append_option "--tx-pool-price-bump" "$TX_POOL_PRICE_BUMP"
append_option "--tx-pool-priority-senders" "$TX_POOL_PRIORITY_SENDERS"
append_option "--tx-pool-save-file" "$TX_POOL_SAVE_FILE"

# Block Builder Options
append_option "--block-txs-selection-max-time" "$BLOCK_TXS_SELECTION_MAX_TIME"
append_option "--min-block-occupancy-ratio" "$MIN_BLOCK_OCCUPANCY_RATIO"
append_option "--min-gas-price" "$MIN_GAS_PRICE"
append_option "--min-priority-fee" "$MIN_PRIORITY_FEE"
append_flag "--miner-enabled" "$MINER_ENABLED"
append_option "--miner-coinbase" "$MINER_COINBASE"
append_option "--miner-extra-data" "$MINER_EXTRA_DATA"
append_flag "--miner-stratum-enabled" "$MINER_STRATUM_ENABLED"
append_option "--miner-stratum-host" "$MINER_STRATUM_HOST"
append_option "--miner-stratum-port" "$MINER_STRATUM_PORT"
append_option "--poa-block-txs-selection-max-time" "$POA_BLOCK_TXS_SELECTION_MAX_TIME"
append_option "--target-gas-limit" "$TARGET_GAS_LIMIT"

# P2P Discovery Options
append_option "--banned-node-ids" "$BANNED_NODE_IDS"
append_option "--bootnodes" "$BOOTNODES"
append_option "--discovery-dns-url" "$DISCOVERY_DNS_URL"
append_flag "--discovery-enabled" "$DISCOVERY_ENABLED"
append_option "--max-peers" "$MAX_PEERS"
append_option "--net-restrict" "$NET_RESTRICT"
append_flag "--p2p-enabled" "$P2P_ENABLED"
append_option "--p2p-host" "$P2P_HOST"
append_option "--p2p-interface" "$P2P_INTERFACE"
append_option "--p2p-port" "$P2P_PORT"
append_option "--poa-discovery-retry-bootnodes" "$P2P_POA_DISCOVERY_RETRY_BOOTNODES"
append_flag "--random-peer-priority-enabled" "$RANDOM_PEER_PRIORITY_ENABLED"
append_flag "--remote-connections-limit-enabled" "$REMOTE_CONNECTIONS_LIMIT_ENABLED"
append_option "--remote-connections-max-percentage" "$REMOTE_CONNECTIONS_MAX_PERCENTAGE"

# GraphQL Options
append_option "--graphql-http-cors-origins" "$GRAPHQL_HTTP_CORS_ORIGINS"
append_flag "--graphql-http-enabled" "$GRAPHQL_HTTP_ENABLED"
append_option "--graphql-http-host" "$GRAPHQL_HTTP_HOST"
append_option "--graphql-http-port" "$GRAPHQL_HTTP_PORT"

# Engine JSON-RPC Options
append_option "--engine-host-allowlist" "$ENGINE_HOST_ALLOWLIST"
append_option "--engine-jwt-disabled" "$ENGINE_JWT_DISABLED"
append_option "--engine-jwt-secret" "$ENGINE_JWT_SECRET"
append_flag "--engine-rpc-enabled" "$ENGINE_RPC_ENABLED"
append_option "--engine-rpc-port" "$ENGINE_RPC_PORT"

# JSON-RPC HTTP Options
append_flag "--json-pretty-print-enabled" "$JSON_PRETTY_PRINT_ENABLED"
append_option "--rpc-http-api" "$RPC_HTTP_API"
append_option "--rpc-http-api-method-no-auth" "$RPC_HTTP_API_METHOD_NO_AUTH"
append_option "--rpc-http-authentication-credentials-file" "$RPC_HTTP_AUTHENTICATION_CREDENTIALS_FILE"
append_flag "--rpc-http-authentication-enabled" "$RPC_HTTP_AUTHENTICATION_ENABLED"
append_option "--rpc-http-authentication-jwt-algorithm" "$RPC_HTTP_AUTHENTICATION_JWT_ALGORITHM"
append_option "--rpc-http-authentication-jwt-public-key-file" "$RPC_HTTP_AUTHENTICATION_JWT_PUBLIC_KEY_FILE"
append_option "--rpc-http-cors-origins" "$RPC_HTTP_CORS_ORIGINS"
append_flag "--rpc-http-enabled" "$RPC_HTTP_ENABLED"
append_option "--rpc-http-host" "$RPC_HTTP_HOST"
append_option "--rpc-http-max-active-connections" "$RPC_HTTP_MAX_ACTIVE_CONNECTIONS"
append_option "--rpc-http-max-batch-size" "$RPC_HTTP_MAX_BATCH_SIZE"
append_option "--rpc-http-max-request-content-length" "$RPC_HTTP_MAX_REQUEST_CONTENT_LENGTH"
append_option "--rpc-http-port" "$RPC_HTTP_PORT"
append_flag "--rpc-http-tls-ca-clients-enabled" "$RPC_HTTP_TLS_CA_CLIENTS_ENABLED"
append_option "--rpc-http-tls-cipher-suites" "$RPC_HTTP_TLS_CIPHER_SUITES"
append_flag "--rpc-http-tls-client-auth-enabled" "$RPC_HTTP_TLS_CLIENT_AUTH_ENABLED"
append_flag "--rpc-http-tls-enabled" "$RPC_HTTP_TLS_ENABLED"
append_option "--rpc-http-tls-keystore-file" "$RPC_HTTP_TLS_KEYSTORE_FILE"
append_option "--rpc-http-tls-keystore-password-file" "$RPC_HTTP_TLS_KEYSTORE_PASSWORD_FILE"
append_option "--rpc-http-tls-known-clients-file" "$RPC_HTTP_TLS_KNOWN_CLIENTS_FILE"
append_option "--rpc-http-tls-protocols" "$RPC_HTTP_TLS_PROTOCOLS"

# JSON-RPC Websocket Options
append_option "--rpc-ws-api" "$RPC_WS_API"
append_option "--rpc-ws-api-method-no-auth" "$RPC_WS_API_METHOD_NO_AUTH"
append_option "--rpc-ws-authentication-credentials-file" "$RPC_WS_AUTHENTICATION_CREDENTIALS_FILE"
append_flag "--rpc-ws-authentication-enabled" "$RPC_WS_AUTHENTICATION_ENABLED"
append_option "--rpc-ws-authentication-jwt-algorithm" "$RPC_WS_AUTHENTICATION_JWT_ALGORITHM"
append_option "--rpc-ws-authentication-jwt-public-key-file" "$RPC_WS_AUTHENTICATION_JWT_PUBLIC_KEY_FILE"
append_flag "--rpc-ws-enabled" "$RPC_WS_ENABLED"
append_option "--rpc-ws-host" "$RPC_WS_HOST"
append_option "--rpc-ws-max-active-connections" "$RPC_WS_MAX_ACTIVE_CONNECTIONS"
append_option "--rpc-ws-max-frame-size" "$RPC_WS_MAX_FRAME_SIZE"
append_option "--rpc-ws-port" "$RPC_WS_PORT"

# In-Process RPC Options
# Privacy Options
append_flag "--privacy-enable-database-migration" "$PRIVACY_ENABLE_DATABASE_MIGRATION"
append_flag "--privacy-enabled" "$PRIVACY_ENABLED"
append_flag "--privacy-flexible-groups-enabled" "$PRIVACY_FLEXIBLE_GROUPS_ENABLED"
append_option "--privacy-marker-transaction-signing-key-file" "$PRIVACY_MARKER_TRANSACTION_SIGNING_KEY_FILE"
append_flag "--privacy-multi-tenancy-enabled" "$PRIVACY_MULTI_TENANCY_ENABLED"
append_option "--privacy-public-key-file" "$PRIVACY_PUBLIC_KEY_FILE"
append_flag "--privacy-tls-enabled" "$PRIVACY_TLS_ENABLED"
append_option "--privacy-tls-keystore-file" "$PRIVACY_TLS_KEYSTORE_FILE"
append_option "--privacy-tls-keystore-password-file" "$PRIVACY_TLS_KEYSTORE_PASSWORD_FILE"
append_option "--privacy-tls-known-enclave-file" "$PRIVACY_TLS_KNOWN_ENCLAVE_FILE"
append_option "--privacy-url" "$PRIVACY_URL"

# Metrics Options
append_option "--metrics-category" "$METRICS_CATEGORY"
append_flag "--metrics-enabled" "$METRICS_ENABLED"
append_option "--metrics-host" "$METRICS_HOST"
append_option "--metrics-port" "$METRICS_PORT"
append_option "--metrics-protocol" "$METRICS_PROTOCOL"
append_flag "--metrics-push-enabled" "$METRICS_PUSH_ENABLED"
append_option "--metrics-push-host" "$METRICS_PUSH_HOST"
append_option "--metrics-push-interval" "$METRICS_PUSH_INTERVAL"
append_option "--metrics-push-port" "$METRICS_PUSH_PORT"
append_option "--metrics-push-prometheus-job" "$METRICS_PUSH_PROMETHEUS_JOB"

# Permissions Options
append_option "--permissions-accounts-config-file" "$PERMISSIONS_ACCOUNTS_CONFIG_FILE"
append_flag "--permissions-accounts-config-file-enabled" "$PERMISSIONS_ACCOUNTS_CONFIG_FILE_ENABLED"
append_option "--permissions-accounts-contract-address" "$PERMISSIONS_ACCOUNTS_CONTRACT_ADDRESS"
append_flag "--permissions-accounts-contract-enabled" "$PERMISSIONS_ACCOUNTS_CONTRACT_ENABLED"
append_option "--permissions-nodes-config-file" "$PERMISSIONS_NODES_CONFIG_FILE"
append_flag "--permissions-nodes-config-file-enabled" "$PERMISSIONS_NODES_CONFIG_FILE_ENABLED"
append_option "--permissions-nodes-contract-address" "$PERMISSIONS_NODES_CONTRACT_ADDRESS"
append_flag "--permissions-nodes-contract-enabled" "$PERMISSIONS_NODES_CONTRACT_ENABLED"
append_option "--permissions-nodes-contract-version" "$PERMISSIONS_NODES_CONTRACT_VERSION"

# API Configuration Options
append_option "--api-gas-price-blocks" "$API_GAS_PRICE_BLOCKS"
append_option "--api-gas-price-max" "$API_GAS_PRICE_MAX"
append_option "--api-gas-price-percentile" "$API_GAS_PRICE_PERCENTILE"
append_option "--rpc-gas-cap" "$RPC_GAS_CAP"
append_option "--rpc-max-logs-range" "$RPC_MAX_LOGS_RANGE"
append_option "--rpc-max-trace-filter-range" "$RPC_MAX_TRACE_FILTER_RANGE"

echo "Running: LOG4J_CONFIGURATION_FILE=/usr/lib/eth-node-regtest/besu/admin.xml besu $OPTIONS"

bash -c "LOG4J_CONFIGURATION_FILE=/usr/lib/eth-node-regtest/besu/admin.xml besu $OPTIONS"
