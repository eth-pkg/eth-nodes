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
        OPTIONS="$OPTIONS $option $value"
    fi
}

append_flag() {
    local option=$1
    local value=$2
    if [ "$value" = "true" ]; then
        OPTIONS="$OPTIONS $option"
    fi
}

# Options
append_option "--config" "$RETH_CONFIG"
append_option "--chain" "$RETH_CHAIN"
append_option "--instance" "$RETH_INSTANCE"
append_flag "--with-unused-ports" "$RETH_WITH_UNUSED_PORTS"

# Metrics
append_option "--metrics" "$RETH_METRICS"

# Datadir
append_option "--datadir" "$RETH_DATADIR"
append_option "--datadir.static-files" "$RETH_DATADIR_STATIC_FILES"

# Networking
append_flag "--disable-discovery" "$RETH_DISABLE_DISCOVERY"
append_flag "--disable-dns-discovery" "$RETH_DISABLE_DNS_DISCOVERY"
append_flag "--disable-discv4-discovery" "$RETH_DISABLE_DISCV4_DISCOVERY"
append_flag "--enable-discv5-discovery" "$RETH_ENABLE_DISCV5_DISCOVERY"
append_flag "--disable-nat" "$RETH_DISABLE_NAT"
append_option "--discovery.addr" "$RETH_DISCOVERY_ADDR"
append_option "--discovery.port" "$RETH_DISCOVERY_PORT"
append_option "--discovery.v5.addr" "$RETH_DISCOVERY_V5_ADDR"
append_option "--discovery.v5.addr.ipv6" "$RETH_DISCOVERY_V5_ADDR_IPV6"
append_option "--discovery.v5.port" "$RETH_DISCOVERY_V5_PORT"
append_option "--discovery.v5.port.ipv6" "$RETH_DISCOVERY_V5_PORT_IPV6"
append_option "--discovery.v5.lookup-interval" "$RETH_DISCOVERY_V5_LOOKUP_INTERVAL"
append_option "--discovery.v5.bootstrap.lookup-interval" "$RETH_DISCOVERY_V5_BOOTSTRAP_LOOKUP_INTERVAL"
append_option "--discovery.v5.bootstrap.lookup-countdown" "$RETH_DISCOVERY_V5_BOOTSTRAP_LOOKUP_COUNTDOWN"
append_option "--trusted-peers" "$RETH_TRUSTED_PEERS"
append_flag "--trusted-only" "$RETH_TRUSTED_ONLY"
append_option "--bootnodes" "$RETH_BOOTNODES"
append_option "--dns-retries" "$RETH_DNS_RETRIES"
append_option "--peers-file" "$RETH_PEERS_FILE"
append_option "--identity" "$RETH_IDENTITY"
append_option "--p2p-secret-key" "$RETH_P2P_SECRET_KEY"
append_flag "--no-persist-peers" "$RETH_NO_PERSIST_PEERS"
append_option "--nat" "$RETH_NAT"
append_option "--addr" "$RETH_ADDR"
append_option "--port" "$RETH_PORT"
append_option "--max-outbound-peers" "$RETH_MAX_OUTBOUND_PEERS"
append_option "--max-inbound-peers" "$RETH_MAX_INBOUND_PEERS"
append_option "--max-tx-reqs" "$RETH_MAX_TX_REQS"
append_option "--max-tx-reqs-peer" "$RETH_MAX_TX_REQS_PEER"
append_option "--max-seen-tx-history" "$RETH_MAX_SEEN_TX_HISTORY"
append_option "--max-pending-imports" "$RETH_MAX_PENDING_IMPORTS"
append_option "--pooled-tx-response-soft-limit" "$RETH_POOLED_TX_RESPONSE_SOFT_LIMIT"
append_option "--pooled-tx-pack-soft-limit" "$RETH_POOLED_TX_PACK_SOFT_LIMIT"
append_option "--max-tx-pending-fetch" "$RETH_MAX_TX_PENDING_FETCH"
append_option "--net-if.experimental" "$RETH_NET_IF_EXPERIMENTAL"

# RPC options
append_flag "--http" "$RETH_HTTP"
append_option "--http.addr" "$RETH_HTTP_ADDR"
append_option "--http.port" "$RETH_HTTP_PORT"
append_option "--http.api" "$RETH_HTTP_API"
append_option "--http.corsdomain" "$RETH_HTTP_CORSDOMAIN"
append_flag "--ws" "$RETH_WS"
append_option "--ws.addr" "$RETH_WS_ADDR"
append_option "--ws.port" "$RETH_WS_PORT"
append_option "--ws.origins" "$RETH_WS_ORIGINS"
append_option "--ws.api" "$RETH_WS_API"
append_flag "--ipcdisable" "$RETH_IPCDISABLE"
append_option "--ipcpath" "$RETH_IPCPATH"
append_option "--authrpc.addr" "$RETH_AUTHRPC_ADDR"
append_option "--authrpc.port" "$RETH_AUTHRPC_PORT"
append_option "--authrpc.jwtsecret" "$RETH_AUTHRPC_JWTSECRET"
append_flag "--auth-ipc" "$RETH_AUTH_IPC"
append_option "--auth-ipc.path" "$RETH_AUTH_IPC_PATH"
append_option "--rpc.jwtsecret" "$RETH_RPC_JWTSECRET"
append_option "--rpc.max-request-size" "$RETH_RPC_MAX_REQUEST_SIZE"
append_option "--rpc.max-response-size" "$RETH_RPC_MAX_RESPONSE_SIZE"
append_option "--rpc.max-subscriptions-per-connection" "$RETH_RPC_MAX_SUBSCRIPTIONS_PER_CONNECTION"
append_option "--rpc.max-connections" "$RETH_RPC_MAX_CONNECTIONS"
append_option "--rpc.max-tracing-requests" "$RETH_RPC_MAX_TRACING_REQUESTS"
append_option "--rpc.max-blocks-per-filter" "$RETH_RPC_MAX_BLOCKS_PER_FILTER"
append_option "--rpc.max-logs-per-response" "$RETH_RPC_MAX_LOGS_PER_RESPONSE"
append_option "--rpc.gascap" "$RETH_RPC_GASCAP"
append_option "--rpc.max-simulate-blocks" "$RETH_RPC_MAX_SIMULATE_BLOCKS"
append_option "--rpc.eth-proof-window" "$RETH_RPC_ETH_PROOF_WINDOW"
append_option "--rpc.proof-permits" "$RETH_RPC_PROOF_PERMITS"

# RPC State Cache:
append_option "--rpc-cache.max-blocks" "$RETH_RPC_CACHE_MAX_BLOCKS"
append_option "--rpc-cache.max-receipts" "$RETH_RPC_CACHE_MAX_RECEIPTS"
append_option "--rpc-cache.max-envs" "$RETH_RPC_CACHE_MAX_ENVS"
append_option "--rpc-cache.max-concurrent-db-requests" "$RETH_RPC_CACHE_MAX_CONCURRENT_DB_REQUESTS"

# Gas Price Oracle:
append_option "--gpo.blocks" "$RETH_GPO_BLOCKS"
append_option "--gpo.ignoreprice" "$RETH_GPO_IGNOREPRICE"
append_option "--gpo.maxprice" "$RETH_GPO_MAXPRICE"
append_option "--gpo.percentile" "$RETH_GPO_PERCENTILE"

# TxPool:
append_option "--txpool.pending-max-count" "$RETH_TXPOOL_PENDING_MAX_COUNT"
append_option "--txpool.pending-max-size" "$RETH_TXPOOL_PENDING_MAX_SIZE"
append_option "--txpool.basefee-max-count" "$RETH_TXPOOL_BASEFEE_MAX_COUNT"
append_option "--txpool.basefee-max-size" "$RETH_TXPOOL_BASEFEE_MAX_SIZE"
append_option "--txpool.queued-max-count" "$RETH_TXPOOL_QUEUED_MAX_COUNT"
append_option "--txpool.queued-max-size" "$RETH_TXPOOL_QUEUED_MAX_SIZE"
append_option "--txpool.max-account-slots" "$RETH_TXPOOL_MAX_ACCOUNT_SLOTS"
append_option "--txpool.pricebump" "$RETH_TXPOOL_PRICEBUMP"
append_option "--txpool.minimal-protocol-fee" "$RETH_TXPOOL_MINIMAL_PROTOCOL_FEE"
append_option "--txpool.gas-limit" "$RETH_TXPOOL_GAS_LIMIT"
append_option "--blobpool.pricebump" "$RETH_BLOBPOOL_PRICEBUMP"
append_option "--txpool.max-tx-input-bytes" "$RETH_TXPOOL_MAX_TX_INPUT_BYTES"
append_option "--txpool.max-cached-entries" "$RETH_TXPOOL_MAX_CACHED_ENTRIES"
append_flag "--txpool.nolocals" "$RETH_TXPOOL_NOLOCALS"
append_option "--txpool.locals" "$RETH_TXPOOL_LOCALS"
append_flag "--txpool.no-local-transactions-propagation" "$RETH_TXPOOL_NO_LOCAL_TRANSACTIONS_PROPAGATION"
append_option "--txpool.additional-validation-tasks" "$RETH_TXPOOL_ADDITIONAL_VALIDATION_TASKS"
append_option "--txpool.max-pending-txns" "$RETH_TXPOOL_MAX_PENDING_TXNS"
append_option "--txpool.max-new-txns" "$RETH_TXPOOL_MAX_NEW_TXNS"

# Builder:
append_option "--builder.extradata" "$RETH_BUILDER_EXTRADATA"
append_option "--builder.gaslimit" "$RETH_BUILDER_GASLIMIT"
append_option "--builder.interval" "$RETH_BUILDER_INTERVAL"
append_option "--builder.deadline" "$RETH_BUILDER_DEADLINE"
append_option "--builder.max-tasks" "$RETH_BUILDER_MAX_TASKS"

# Debug:
append_flag "--debug.terminate" "$RETH_DEBUG_TERMINATE"
append_option "--debug.tip" "$RETH_DEBUG_TIP"
append_option "--debug.max-block" "$RETH_DEBUG_MAX_BLOCK"
append_option "--debug.etherscan" "$RETH_DEBUG_ETHERSCAN"
append_option "--debug.rpc-consensus-ws" "$RETH_DEBUG_RPC_CONSENSUS_WS"
append_option "--debug.skip-fcu" "$RETH_DEBUG_SKIP_FCU"
append_option "--debug.skip-new-payload" "$RETH_DEBUG_SKIP_NEW_PAYLOAD"
append_option "--debug.reorg-frequency" "$RETH_DEBUG_REORG_FREQUENCY"
append_option "--debug.reorg-depth" "$RETH_DEBUG_REORG_DEPTH"
append_option "--debug.engine-api-store" "$RETH_DEBUG_ENGINE_API_STORE"
append_option "--debug.invalid-block-hook" "$RETH_DEBUG_INVALID_BLOCK_HOOK"
append_option "--debug.healthy-node-rpc-url" "$RETH_DEBUG_HEALTHY_NODE_RPC_URL"

# Database:
append_option "--db.log-level" "$RETH_DB_LOG_LEVEL"
append_option "--db.exclusive" "$RETH_DB_EXCLUSIVE"

# Dev testnet:
append_flag "--dev" "$RETH_DEV"
append_option "--dev.block-max-transactions" "$RETH_DEV_BLOCK_MAX_TRANSACTIONS"
append_option "--dev.block-time" "$RETH_DEV_BLOCK_TIME"

# Pruning:
append_flag "--full" "$RETH_FULL"
append_option "--block-interval" "$RETH_BLOCK_INTERVAL"
append_flag "--prune.senderrecovery.full" "$RETH_PRUNE_SENDERRECOVERY_FULL"
append_option "--prune.senderrecovery.distance" "$RETH_PRUNE_SENDERRECOVERY_DISTANCE"
append_option "--prune.senderrecovery.before" "$RETH_PRUNE_SENDERRECOVERY_BEFORE"
append_flag "--prune.transactionlookup.full" "$RETH_PRUNE_TRANSACTIONLOOKUP_FULL"
append_option "--prune.transactionlookup.distance" "$RETH_PRUNE_TRANSACTIONLOOKUP_DISTANCE"
append_option "--prune.transactionlookup.before" "$RETH_PRUNE_TRANSACTIONLOOKUP_BEFORE"
append_flag "--prune.receipts.full" "$RETH_PRUNE_RECEIPTS_FULL"
append_option "--prune.receipts.distance" "$RETH_PRUNE_RECEIPTS_DISTANCE"
append_option "--prune.receipts.before" "$RETH_PRUNE_RECEIPTS_BEFORE"
append_flag "--prune.accounthistory.full" "$RETH_PRUNE_ACCOUNTHISTORY_FULL"
append_option "--prune.accounthistory.distance" "$RETH_PRUNE_ACCOUNTHISTORY_DISTANCE"
append_option "--prune.accounthistory.before" "$RETH_PRUNE_ACCOUNTHISTORY_BEFORE"
append_flag "--prune.storagehistory.full" "$RETH_PRUNE_STORAGEHISTORY_FULL"
append_option "--prune.storagehistory.distance" "$RETH_PRUNE_STORAGEHISTORY_DISTANCE"
append_option "--prune.storagehistory.before" "$RETH_PRUNE_STORAGEHISTORY_BEFORE"
append_option "--prune.receiptslogfilter" "$RETH_PRUNE_RECEIPTSLOGFILTER"

# Engine:
append_flag "--engine.experimental" "$RETH_ENGINE_EXPERIMENTAL"
append_flag "--engine.legacy" "$RETH_ENGINE_LEGACY"
append_option "--engine.persistence-threshold" "$RETH_ENGINE_PERSISTENCE_THRESHOLD"
append_option "--engine.memory-block-buffer-target" "$RETH_ENGINE_MEMORY_BLOCK_BUFFER_TARGET"

# Logging:
append_option "--log.stdout.format" "$RETH_LOG_STDOUT_FORMAT"
append_option "--log.stdout.filter" "$RETH_LOG_STDOUT_FILTER"
append_option "--log.file.format" "$RETH_LOG_FILE_FORMAT"
append_option "--log.file.filter" "$RETH_LOG_FILE_FILTER"
append_option "--log.file.directory" "$RETH_LOG_FILE_DIRECTORY"
append_option "--log.file.max-size" "$RETH_LOG_FILE_MAX_SIZE"
append_option "--log.file.max-files" "$RETH_LOG_FILE_MAX_FILES"
append_flag "--log.journald" "$RETH_LOG_JOURNALD"
append_option "--log.journald.filter" "$RETH_LOG_JOURNALD_FILTER"
append_option "--color" "$RETH_COLOR"

# Display:
append_flag "-v" "$verbosity"
append_flag "-q" "$quiet"

echo "Starting node with options: reth node $OPTIONS"

exec reth node $OPTIONS
