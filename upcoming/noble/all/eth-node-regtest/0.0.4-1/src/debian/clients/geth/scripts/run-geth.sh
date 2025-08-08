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

# ACCOUNT
append_flag "--allow-insecure-unlock" "$GETH_ALLOW_INSECURE_UNLOCK"
append_option "--keystore" "$GETH_KEYSTORE"
append_flag "--lightkdf" "$GETH_LIGHTKDF"
append_option "--password" "$GETH_PASSWORD"
append_option "--pcscdpath" "$GETH_PCSCDPATH"
append_option "--signer" "$GETH_SIGNER"
append_option "--unlock" "$GETH_UNLOCK"
append_flag "--usb" "$GETH_USB"

# ALIASED (deprecated)
append_option "--cache.trie.journal" "$GETH_CACHE_TRIE_JOURNAL"
append_option "--cache.trie.rejournal" "$GETH_CACHE_TRIE_REJOURNAL"
append_option "--light.egress" "$GETH_LIGHT_EGRESS"
append_option "--light.ingress" "$GETH_LIGHT_INGRESS"
append_option "--light.maxpeers" "$GETH_LIGHT_MAXPEERS"
append_flag "--light.nopruning" "$GETH_LIGHT_NOPRUNING"
append_flag "--light.nosyncserve" "$GETH_LIGHT_NOSYNCSERVE"
append_option "--light.serve" "$GETH_LIGHT_SERVE"
append_option "--log.backtrace" "$GETH_LOG_BACKTRACE"
append_flag "--log.debug" "$GETH_LOG_DEBUG"
append_flag "--metrics.expensive" "$GETH_METRICS_EXPENSIVE"
append_flag "--mine" "$GETH_MINE"
append_option "--miner.etherbase" "$GETH_MINER_ETHERBASE"
append_option "--miner.newpayload-timeout" "$GETH_MINER_NEWPAYLOAD_TIMEOUT"
append_flag "--nousb" "$GETH_NOUSB"
append_option "--txlookuplimit" "$GETH_TXLOOKUPLIMIT"
append_flag "--v5disc" "$GETH_V5DISC"
append_option "--whitelist" "$GETH_WHITELIST"

# API AND CONSOLE
append_option "--authrpc.addr" "$GETH_AUTHRPC_ADDR"
append_option "--authrpc.jwtsecret" "$GETH_AUTHRPC_JWTSECRET"
append_option "--authrpc.port" "$GETH_AUTHRPC_PORT"
append_option "--authrpc.vhosts" "$GETH_AUTHRPC_VHOSTS"
append_option "--exec" "$GETH_EXEC"
append_flag "--graphql" "$GETH_GRAPHQL"
append_option "--graphql.corsdomain" "$GETH_GRAPHQL_CORSDOMAIN"
append_option "--graphql.vhosts" "$GETH_GRAPHQL_VHOSTS"
append_option "--header" "$GETH_HEADER"
append_flag "--http" "$GETH_HTTP"
append_option "--http.addr" "$GETH_HTTP_ADDR"
append_option "--http.api" "$GETH_HTTP_API"
append_option "--http.corsdomain" "$GETH_HTTP_CORSDOMAIN"
append_option "--http.port" "$GETH_HTTP_PORT"
append_option "--http.rpcprefix" "$GETH_HTTP_RPCPREFIX"
append_option "--http.vhosts" "$GETH_HTTP_VHOSTS"
append_flag "--ipcdisable" "$GETH_IPCDISABLE"
append_option "--ipcpath" "$GETH_IPCPATH"
append_option "--jspath" "$GETH_JSPATH"
append_option "--preload" "$GETH_PRELOAD"
append_flag "--rpc.allow-unprotected-txs" "$GETH_RPC_ALLOW_UNPROTECTED_TXS"
append_option "--rpc.batch-request-limit" "$GETH_RPC_BATCH_REQUEST_LIMIT"
append_option "--rpc.batch-response-max-size" "$GETH_RPC_BATCH_RESPONSE_MAX_SIZE"
append_flag "--rpc.enabledeprecatedpersonal" "$GETH_RPC_ENABLEDEPRECATEDPERSONAL"
append_option "--rpc.evmtimeout" "$GETH_RPC_EVMTIMEOUT"
append_option "--rpc.gascap" "$GETH_RPC_GASCAP"
append_option "--rpc.txfeecap" "$GETH_RPC_TXFEECAP"
append_flag "--ws" "$GETH_WS"
append_option "--ws.addr" "$GETH_WS_ADDR"
append_option "--ws.api" "$GETH_WS_API"
append_option "--ws.origins" "$GETH_WS_ORIGINS"
append_option "--ws.port" "$GETH_WS_PORT"
append_option "--ws.rpcprefix" "$GETH_WS_RPCPREFIX"

# BEACON CHAIN
append_option "--beacon.api" "$GETH_BEACON_API"
append_option "--beacon.api.header" "$GETH_BEACON_API_HEADER"
append_option "--beacon.checkpoint" "$GETH_BEACON_CHECKPOINT"
append_option "--beacon.config" "$GETH_BEACON_CONFIG"
append_option "--beacon.genesis.gvroot" "$GETH_BEACON_GENESIS_GVROOT"
append_option "--beacon.genesis.time" "$GETH_BEACON_GENESIS_TIME"
append_flag "--beacon.nofilter" "$GETH_BEACON_NOFILTER"
append_option "--beacon.threshold" "$GETH_BEACON_THRESHOLD"

# DEVELOPER CHAIN
append_flag "--dev" "$GETH_DEV"
append_option "--dev.gaslimit" "$GETH_DEV_GASLIMIT"
append_option "--dev.period" "$GETH_DEV_PERIOD"

# ETHEREUM
append_option "--bloomfilter.size" "$GETH_BLOOMFILTER_SIZE"
append_option "--config" "$GETH_CONFIG"
append_option "--datadir" "$GETH_DATADIR"
append_option "--datadir.ancient" "$GETH_DATADIR_ANCIENT"
append_option "--datadir.minfreedisk" "$GETH_DATADIR_MINFREEDISK"
append_option "--db.engine" "$GETH_DB_ENGINE"
append_option "--eth.requiredblocks" "$GETH_ETH_REQUIREDBLOCKS"
append_flag "--exitwhensynced" "$GETH_EXITWHENSYNCED"
append_flag "--holesky" "$GETH_HOLESKY"
append_flag "--mainnet" "$GETH_MAINNET"
append_option "--networkid" "$GETH_NETWORKID"
append_option "--override.cancun" "$GETH_OVERRIDE_CANCUN"
append_option "--override.verkle" "$GETH_OVERRIDE_VERKLE"
append_flag "--sepolia" "$GETH_SEPOLIA"
append_flag "--snapshot" "$GETH_SNAPSHOT"

# GAS PRICE ORACLE
append_option "--gpo.blocks" "$GETH_GPO_BLOCKS"
append_option "--gpo.ignoreprice" "$GETH_GPO_IGNOREPRICE"
append_option "--gpo.maxprice" "$GETH_GPO_MAXPRICE"
append_option "--gpo.percentile" "$GETH_GPO_PERCENTILE"

# LOGGING AND DEBUGGING
append_flag "--log.compress" "$GETH_LOG_COMPRESS"
append_option "--log.file" "$GETH_LOG_FILE"
append_option "--log.format" "$GETH_LOG_FORMAT"
append_option "--log.maxage" "$GETH_LOG_MAXAGE"
append_option "--log.maxbackups" "$GETH_LOG_MAXBACKUPS"
append_option "--log.maxsize" "$GETH_LOG_MAXSIZE"
append_flag "--log.rotate" "$GETH_LOG_ROTATE"
append_option "--log.vmodule" "$GETH_LOG_VMODULE"
append_flag "--nocompaction" "$GETH_NOCOMPACTION"
append_flag "--pprof" "$GETH_PPROF"
append_option "--pprof.addr" "$GETH_PPROF_ADDR"
append_option "--pprof.blockprofilerate" "$GETH_PPROF_BLOCKPROFILERATE"
append_option "--pprof.cpuprofile" "$GETH_PPROF_CPUPROFILE"
append_option "--pprof.memprofilerate" "$GETH_PPROF_MEMPROFILERATE"
append_option "--pprof.port" "$GETH_PPROF_PORT"
append_option "--remotedb" "$GETH_REMOTEDB"
append_option "--trace" "$GETH_TRACE"
append_option "--verbosity" "$GETH_VERBOSITY"

# METRICS AND STATS
append_option "--ethstats" "$GETH_ETHSTATS"
append_flag "--metrics" "$GETH_METRICS"
append_option "--metrics.addr" "$GETH_METRICS_ADDR"
append_flag "--metrics.influxdb" "$GETH_METRICS_INFLUXDB"
append_option "--metrics.influxdb.bucket" "$GETH_METRICS_INFLUXDB_BUCKET"
append_option "--metrics.influxdb.database" "$GETH_METRICS_INFLUXDB_DATABASE"
append_option "--metrics.influxdb.endpoint" "$GETH_METRICS_INFLUXDB_ENDPOINT"
append_option "--metrics.influxdb.organization" "$GETH_METRICS_INFLUXDB_ORGANIZATION"
append_option "--metrics.influxdb.password" "$GETH_METRICS_INFLUXDB_PASSWORD"
append_option "--metrics.influxdb.tags" "$GETH_METRICS_INFLUXDB_TAGS"
append_option "--metrics.influxdb.token" "$GETH_METRICS_INFLUXDB_TOKEN"
append_option "--metrics.influxdb.username" "$GETH_METRICS_INFLUXDB_USERNAME"
append_flag "--metrics.influxdbv2" "$GETH_METRICS_INFLUXDBV2"
append_option "--metrics.port" "$GETH_METRICS_PORT"

# MINER
append_option "--miner.extradata" "$GETH_MINER_EXTRADATA"
append_option "--miner.gaslimit" "$GETH_MINER_GASLIMIT"
append_option "--miner.gasprice" "$GETH_MINER_GASPRICE"
append_option "--miner.pending.feeRecipient" "$GETH_MINER_PENDING_FEERECIPIENT"
append_option "--miner.recommit" "$GETH_MINER_RECOMMIT"

# MISC
append_option "--synctarget" "$GETH_SYNCTARGET"

# NETWORKING
append_option "--bootnodes" "$GETH_BOOTNODES"
append_option "--discovery.dns" "$GETH_DISCOVERY_DNS"
append_option "--discovery.port" "$GETH_DISCOVERY_PORT"
append_flag "--discovery.v4" "$GETH_DISCOVERY_V4"
append_flag "--discovery.v5" "$GETH_DISCOVERY_V5"
append_option "--identity" "$GETH_IDENTITY"
append_option "--maxpeers" "$GETH_MAXPEERS"
append_option "--maxpendpeers" "$GETH_MAXPENDPEERS"
append_option "--nat" "$GETH_NAT"
append_option "--netrestrict" "$GETH_NETRESTRICT"
append_option "--nodekey" "$GETH_NODEKEY"
append_option "--nodekeyhex" "$GETH_NODEKEYHEX"
append_flag "--nodiscover" "$GETH_NODISCOVER"
append_option "--port" "$GETH_PORT"

# PERFORMANCE TUNING
append_option "--cache" "$GETH_CACHE"
append_option "--cache.blocklogs" "$GETH_CACHE_BLOCKLOGS"
append_option "--cache.database" "$GETH_CACHE_DATABASE"
append_option "--cache.gc" "$GETH_CACHE_GC"
append_flag "--cache.noprefetch" "$GETH_CACHE_NOPREFETCH"
append_flag "--cache.preimages" "$GETH_CACHE_PREIMAGES"
append_option "--cache.snapshot" "$GETH_CACHE_SNAPSHOT"
append_option "--cache.trie" "$GETH_CACHE_TRIE"
append_option "--crypto.kzg" "$GETH_CRYPTO_KZG"
append_option "--fdlimit" "$GETH_FDLIMIT"

# STATE HISTORY MANAGEMENT
append_option "--gcmode" "$GETH_GCMODE"
append_option "--history.state" "$GETH_HISTORY_STATE"
append_option "--history.transactions" "$GETH_HISTORY_TRANSACTIONS"
append_option "--state.scheme" "$GETH_STATE_SCHEME"
append_option "--syncmode" "$GETH_SYNCMODE"

# TRANSACTION POOL (BLOB)
append_option "--blobpool.datacap" "$GETH_BLOBPOOL_DATACAP"
append_option "--blobpool.datadir" "$GETH_BLOBPOOL_DATADIR"
append_option "--blobpool.pricebump" "$GETH_BLOBPOOL_PRICEBUMP"

# TRANSACTION POOL (EVM)
append_option "--txpool.accountqueue" "$GETH_TXPOOL_ACCOUNTQUEUE"
append_option "--txpool.accountslots" "$GETH_TXPOOL_ACCOUNTSLOTS"
append_option "--txpool.globalqueue" "$GETH_TXPOOL_GLOBALQUEUE"
append_option "--txpool.globalslots" "$GETH_TXPOOL_GLOBALSLOTS"
append_option "--txpool.journal" "$GETH_TXPOOL_JOURNAL"
append_option "--txpool.lifetime" "$GETH_TXPOOL_LIFETIME"
append_option "--txpool.locals" "$GETH_TXPOOL_LOCALS"
append_flag "--txpool.nolocals" "$GETH_TXPOOL_NOLOCALS"
append_option "--txpool.pricebump" "$GETH_TXPOOL_PRICEBUMP"
append_option "--txpool.pricelimit" "$GETH_TXPOOL_PRICELIMIT"
append_option "--txpool.rejournal" "$GETH_TXPOOL_REJOURNAL"

# VIRTUAL MACHINE
append_flag "--vmdebug" "$GETH_VMDEBUG"
append_option "--vmtrace" "$GETH_VMTRACE"
append_option "--vmtrace.jsonconfig" "$GETH_VMTRACE_JSONCONFIG"

if [ -n "$BASECONF_TESTNET_DIR" ]; then
    echo "Importing genesis state"
    geth init --datadir "$GETH_DATADIR" "$BASECONF_TESTNET_DIR/genesis.json"
fi

echo "Using Options: geth $OPTIONS"

exec geth $OPTIONS
