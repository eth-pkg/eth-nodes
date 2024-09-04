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

append_option "--config" "$RETH_CLI_NODE_CONFIG"
append_option "--chain" "$RETH_CLI_NODE_CHAIN"
append_option "--instance" "$RETH_CLI_NODE_INSTANCE"
append_flag "--with-unused-ports" "$RETH_CLI_NODE_WITH_UNUSED_PORTS"
append_option "--metrics" "$RETH_CLI_NODE_METRICS"
append_option "--datadir" "$RETH_CLI_NODE_DATADIR"
append_option "--datadir.static_files" "$RETH_CLI_NODE_DATADIR_STATIC_FILES"
append_flag "-d" "$RETH_CLI_NODE_DISABLE_DISCOVERY"
append_flag "--disable-dns-discovery" "$RETH_CLI_NODE_DISABLE_DNS_DISCOVERY"
append_flag "--disable-discv4-discovery" "$RETH_CLI_NODE_DISABLE_DISCV4_DISCOVERY"
append_flag "--enable-discv5-discovery" "$RETH_CLI_NODE_ENABLE_DISCV5_DISCOVERY"
append_option "--discovery.addr" "$RETH_CLI_NODE_DISCOVERY_ADDR"
append_option "--discovery.port" "$RETH_CLI_NODE_DISCOVERY_PORT"
append_option "--discovery.v5.addr" "$RETH_CLI_NODE_DISCOVERY_V5_ADDR"
append_option "--discovery.v5.addr.ipv6" "$RETH_CLI_NODE_DISCOVERY_V5_ADDR_IPV6"
append_option "--discovery.v5.port" "$RETH_CLI_NODE_DISCOVERY_V5_PORT"
append_option "--discovery.v5.port.ipv6" "$RETH_CLI_NODE_DISCOVERY_V5_PORT_IPV6"
append_option "--discovery.v5.lookup-interval" "$RETH_CLI_NODE_DISCOVERY_V5_LOOKUP_INTERVAL"
append_option "--discovery.v5.bootstrap.lookup-interval" "$RETH_CLI_NODE_DISCOVERY_V5_BOOTSTRAP_LOOKUP_INTERVAL"
append_option "--discovery.v5.bootstrap.lookup-countdown" "$RETH_CLI_NODE_DISCOVERY_V5_BOOTSTRAP_LOOKUP_COUNTDOWN"
append_option "--trusted-peers" "$RETH_CLI_NODE_TRUSTED_PEERS"
append_flag "--trusted-only" "$RETH_CLI_NODE_TRUSTED_ONLY"
append_option "--bootnodes" "$RETH_CLI_NODE_BOOTNODES"
append_option "--dns-retries" "$RETH_CLI_NODE_DNS_RETRIES"
append_option "--peers-file" "$RETH_CLI_NODE_PEERS_FILE"
append_option "--identity" "$RETH_CLI_NODE_IDENTITY"
append_option "--p2p-secret-key" "$RETH_CLI_NODE_P2P_SECRET_KEY"
append_flag "--no-persist-peers" "$RETH_CLI_NODE_NO_PERSIST_PEERS"
append_option "--nat" "$RETH_CLI_NODE_NAT"
append_option "--addr" "$RETH_CLI_NODE_ADDR"
append_option "--port" "$RETH_CLI_NODE_PORT"
append_option "--max-outbound-peers" "$RETH_CLI_NODE_MAX_OUTBOUND_PEERS"
append_option "--max-inbound-peers" "$RETH_CLI_NODE_MAX_INBOUND_PEERS"
append_option "--pooled-tx-response-soft-limit" "$RETH_CLI_NODE_POOLED_TX_RESPONSE_SOFT_LIMIT"
append_option "--pooled-tx-pack-soft-limit" "$RETH_CLI_NODE_POOLED_TX_PACK_SOFT_LIMIT"
append_flag "--http" "$RETH_CLI_NODE_HTTP"
append_option "--http.addr" "$RETH_CLI_NODE_HTTP_ADDR"
append_option "--http.port" "$RETH_CLI_NODE_HTTP_PORT"
append_option "--http.api" "$RETH_CLI_NODE_HTTP_API"
append_option "--http.corsdomain" "$RETH_CLI_NODE_HTTP_CORSDOMAIN"
append_flag "--ws" "$RETH_CLI_NODE_WS"
append_option "--ws.addr" "$RETH_CLI_NODE_WS_ADDR"
append_option "--ws.port" "$RETH_CLI_NODE_WS_PORT"
append_option "--ws.origins" "$RETH_CLI_NODE_WS_ORIGINS"
append_option "--ws.api" "$RETH_CLI_NODE_WS_API"
append_flag "--ipcdisable" "$RETH_CLI_NODE_IPCDISABLE"
append_option "--ipcpath" "$RETH_CLI_NODE_IPCPATH"
append_option "--authrpc.addr" "$RETH_CLI_NODE_AUTHRPC_ADDR"
append_option "--authrpc.port" "$RETH_CLI_NODE_AUTHRPC_PORT"
append_option "--authrpc.jwtsecret" "$RETH_CLI_NODE_AUTHRPC_JWTSECRET"
append_flag "--auth-ipc" "$RETH_CLI_NODE_AUTH_IPC"
append_option "--auth-ipc.path" "$RETH_CLI_NODE_AUTH_IPC_PATH"
append_option "--rpc.jwtsecret" "$RETH_CLI_NODE_RPC_JWTSECRET"
append_option "--rpc.max-request-size" "$RETH_CLI_NODE_RPC_MAX_REQUEST_SIZE"
append_option "--rpc.max-response-size" "$RETH_CLI_NODE_RPC_MAX_RESPONSE_SIZE"
append_option "--rpc.max-subscriptions-per-connection" "$RETH_CLI_NODE_RPC_MAX_SUBSCRIPTIONS_PER_CONNECTION"
append_option "--rpc.max-connections" "$RETH_CLI_NODE_RPC_MAX_CONNECTIONS"
append_option "--rpc.max-tracing-requests" "$RETH_CLI_NODE_RPC_MAX_TRACING_REQUESTS"
append_option "--rpc.max-blocks-per-filter" "$RETH_CLI_NODE_RPC_MAX_BLOCKS_PER_FILTER"
append_option "--rpc.max-logs-per-response" "$RETH_CLI_NODE_RPC_MAX_LOGS_PER_RESPONSE"
append_option "--rpc.gascap" "$RETH_CLI_NODE_RPC_GASCAP"
append_option "--rpc-cache.max-blocks" "$RETH_CLI_NODE_RPC_CACHE_MAX_BLOCKS"
append_option "--rpc-cache.max-receipts" "$RETH_CLI_NODE_RPC_CACHE_MAX_RECEIPTS"
append_option "--rpc-cache.max-envs" "$RETH_CLI_NODE_RPC_CACHE_MAX_ENVS"
append_option "--rpc-cache.max-concurrent-db-requests" "$RETH_CLI_NODE_RPC_CACHE_MAX_CONCURRENT_DB_REQUESTS"
append_option "--gpo.blocks" "$RETH_CLI_NODE_GPO_BLOCKS"
append_option "--gpo.ignoreprice" "$RETH_CLI_NODE_GPO_IGNOREPRICE"
append_option "--gpo.maxprice" "$RETH_CLI_NODE_GPO_MAXPRICE"
append_option "--gpo.percentile" "$RETH_CLI_NODE_GPO_PERCENTILE"
append_option "--txpool.pending-max-count" "$RETH_CLI_NODE_TXPOOL_PENDING_MAX_COUNT"
append_option "--txpool.pending-max-size" "$RETH_CLI_NODE_TXPOOL_PENDING_MAX_SIZE"
append_option "--txpool.basefee-max-count" "$RETH_CLI_NODE_TXPOOL_BASEFEE_MAX_COUNT"
append_option "--txpool.basefee-max-size" "$RETH_CLI_NODE_TXPOOL_BASEFEE_MAX_SIZE"
append_option "--txpool.queued-max-count" "$RETH_CLI_NODE_TXPOOL_QUEUED_MAX_COUNT"
append_option "--txpool.queued-max-size" "$RETH_CLI_NODE_TXPOOL_QUEUED_MAX_SIZE"
append_option "--txpool.max-account-slots" "$RETH_CLI_NODE_TXPOOL_MAX_ACCOUNT_SLOTS"
append_option "--txpool.pricebump" "$RETH_CLI_NODE_TXPOOL_PRICEBUMP"
append_option "--blobpool.pricebump" "$RETH_CLI_NODE_BLOBPOOL_PRICEBUMP"
append_option "--txpool.max-tx-input-bytes" "$RETH_CLI_NODE_TXPOOL_MAX_TX_INPUT_BYTES"
append_option "--txpool.max-cached-entries" "$RETH_CLI_NODE_TXPOOL_MAX_CACHED_ENTRIES"
append_flag "--txpool.nolocals" "$RETH_CLI_NODE_TXPOOL_NOLOCALS"
append_option "--txpool.locals" "$RETH_CLI_NODE_TXPOOL_LOCALS"
append_flag "--txpool.no-local-transactions-propagation" "$RETH_CLI_NODE_TXPOOL_NO_LOCAL_TRANSACTIONS_PROPAGATION"
append_option "--builder.extradata" "$RETH_CLI_NODE_BUILDER_EXTRADATA"
append_option "--builder.gaslimit" "$RETH_CLI_NODE_BUILDER_GASLIMIT"
append_option "--builder.interval" "$RETH_CLI_NODE_BUILDER_INTERVAL"
append_option "--builder.deadline" "$RETH_CLI_NODE_BUILDER_DEADLINE"
append_option "--builder.max-tasks" "$RETH_CLI_NODE_BUILDER_MAX_TASKS"
append_flag "--debug.terminate" "$RETH_CLI_NODE_DEBUG_TERMINATE"
append_option "--debug.tip" "$RETH_CLI_NODE_DEBUG_TIP"
append_option "--debug.max-block" "$RETH_CLI_NODE_DEBUG_MAX_BLOCK"
append_option "--debug.etherscan" "$RETH_CLI_NODE_DEBUG_ETHERSCAN"
append_option "--debug.rpc-consensus-ws" "$RETH_CLI_NODE_DEBUG_RPC_CONSENSUS_WS"
append_option "--debug.skip-fcu" "$RETH_CLI_NODE_DEBUG_SKIP_FCU"
append_option "--debug.skip-new-payload" "$RETH_CLI_NODE_DEBUG_SKIP_NEW_PAYLOAD"
append_option "--debug.engine-api-store" "$RETH_CLI_NODE_DEBUG_ENGINE_API_STORE"
append_option "--db.log-level" "$RETH_CLI_NODE_DB_LOG_LEVEL"
append_option "--db.exclusive" "$RETH_CLI_NODE_DB_EXCLUSIVE"
append_flag "--dev" "$RETH_CLI_NODE_DEV"
append_option "--dev.block-max-transactions" "$RETH_CLI_NODE_DEV_BLOCK_MAX_TRANSACTIONS"
append_option "--dev.block-time" "$RETH_CLI_NODE_DEV_BLOCK_TIME"
append_flag "--full" "$RETH_CLI_NODE_FULL"
append_option "--log.stdout.format" "$RETH_CLI_NODE_LOG_STDOUT_FORMAT"
append_option "--log.stdout.filter" "$RETH_CLI_NODE_LOG_STDOUT_FILTER"
append_option "--log.file.format" "$RETH_CLI_NODE_LOG_FILE_FORMAT"
append_option "--log.file.filter" "$RETH_CLI_NODE_LOG_FILE_FILTER"
append_option "--log.file.directory" "$RETH_CLI_NODE_LOG_FILE_DIRECTORY"
append_option "--log.file.max-size" "$RETH_CLI_NODE_LOG_FILE_MAX_SIZE"
append_option "--log.file.max-files" "$RETH_CLI_NODE_LOG_FILE_MAX_FILES"
append_flag "--log.journald" "$RETH_CLI_NODE_LOG_JOURNALD"
append_option "--log.journald.filter" "$RETH_CLI_NODE_LOG_JOURNALD_FILTER"
append_option "--color" "$RETH_CLI_NODE_COLOR"
append_option "--verbosity" "$RETH_CLI_NODE_VERBOSITY"
append_flag "--quiet" "$RETH_CLI_NODE_QUIET"

echo "Starting node with options: reth node $OPTIONS"

exec reth node $OPTIONS