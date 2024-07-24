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

append_flag "--allow-insecure-unlock" "$GETH_CLI_ALLOW_INSECURE_UNLOCK"
append_flag "--graphql" "$GETH_CLI_GRAPHQL"
append_flag "--http" "$GETH_CLI_HTTP"
append_flag "--ws" "$GETH_CLI_WS"
append_flag "--dev" "$GETH_CLI_DEV"
append_flag "--goerli" "$GETH_CLI_GOERLI"
append_flag "--holesky" "$GETH_CLI_HOLESKY"
append_flag "--mainnet" "$GETH_CLI_MAINNET"
append_flag "--sepolia" "$GETH_CLI_SEPOLIA"
append_flag "--nodiscover" "$GETH_CLI_NODISCOVER"

append_option "--keystore" "$GETH_CLI_KEYSTORE"
append_option "--lightkdf" "$GETH_CLI_LIGHTKDF"
append_option "--password" "$GETH_CLI_PASSWORD"
append_option "--pcscdpath" "$GETH_CLI_PCSCDPATH"
append_option "--signer" "$GETH_CLI_SIGNER"
append_option "--unlock" "$GETH_CLI_UNLOCK"
append_option "--usb" "$GETH_CLI_USB"
append_option "--cache.trie.journal" "$GETH_CLI_CACHE_TRIE_JOURNAL"
append_option "--cache.trie.rejournal" "$GETH_CLI_CACHE_TRIE_REJOURNAL"
append_option "--light.egress" "$GETH_CLI_LIGHT_EGRESS"
append_option "--light.ingress" "$GETH_CLI_LIGHT_INGRESS"
append_option "--light.maxpeers" "$GETH_CLI_LIGHT_MAXPEERS"
append_option "--light.nopruning" "$GETH_CLI_LIGHT_NOPRUNING"
append_option "--light.nosyncserve" "$GETH_CLI_LIGHT_NOSYNCSERVE"
append_option "--light.serve" "$GETH_CLI_LIGHT_SERVE"
append_option "--log.backtrace" "$GETH_CLI_LOG_BACKTRACE"
append_option "--log.debug" "$GETH_CLI_LOG_DEBUG"
append_option "--metrics.expensive" "$GETH_CLI_METRICS_EXPENSIVE"
append_option "--mine" "$GETH_CLI_MINE"
append_option "--miner.etherbase" "$GETH_CLI_MINER_ETHERBASE"
append_option "--miner.newpayload-timeout" "$GETH_CLI_MINER_NEWPAYLOAD_TIMEOUT"
append_option "--nousb" "$GETH_CLI_NOUSB"
append_option "--txlookuplimit" "$GETH_CLI_TXLOOKUPLIMIT"
append_option "--v5disc" "$GETH_CLI_V5DISC"
append_option "--whitelist" "$GETH_CLI_WHITELIST"
append_option "--authrpc.addr" "$GETH_CLI_AUTHRPC_ADDR"
append_option "--authrpc.jwtsecret" "$GETH_CLI_AUTHRPC_JWTSECRET"
append_option "--authrpc.port" "$GETH_CLI_AUTHRPC_PORT"
append_option "--authrpc.vhosts" "$GETH_CLI_AUTHRPC_VHOSTS"
append_option "--exec" "$GETH_CLI_EXEC"
append_option "--graphql.corsdomain" "$GETH_CLI_GRAPHQL_CORSDOMAIN"
append_option "--graphql.vhosts" "$GETH_CLI_GRAPHQL_VHOSTS"
append_option "--header" "$GETH_CLI_HEADER"
append_option "--http.addr" "$GETH_CLI_HTTP_ADDR"
append_option "--http.api" "$GETH_CLI_HTTP_API"
append_option "--http.corsdomain" "$GETH_CLI_HTTP_CORSDOMAIN"
append_option "--http.port" "$GETH_CLI_HTTP_PORT"
append_option "--http.rpcprefix" "$GETH_CLI_HTTP_RPCPREFIX"
append_option "--http.vhosts" "$GETH_CLI_HTTP_VHOSTS"
append_option "--ipcdisable" "$GETH_CLI_IPCDISABLE"
append_option "--ipcpath" "$GETH_CLI_IPCPATH"
append_option "--jspath" "$GETH_CLI_JSPATH"
append_option "--preload" "$GETH_CLI_PRELOAD"
append_option "--rpc.allow-unprotected-txs" "$GETH_CLI_RPC_ALLOW_UNPROTECTED_TXS"
append_option "--rpc.batch-request-limit" "$GETH_CLI_RPC_BATCH_REQUEST_LIMIT"
append_option "--rpc.batch-response-max-size" "$GETH_CLI_RPC_BATCH_RESPONSE_MAX_SIZE"
append_option "--rpc.enabledeprecatedpersonal" "$GETH_CLI_RPC_ENABLEDEPRECATEDPERSONAL"
append_option "--rpc.evmtimeout" "$GETH_CLI_RPC_EVMTIMEOUT"
append_option "--rpc.gascap" "$GETH_CLI_RPC_GASCAP"
append_option "--rpc.txfeecap" "$GETH_CLI_RPC_TXFEECAP"
append_option "--ws.addr" "$GETH_CLI_WS_ADDR"
append_option "--ws.api" "$GETH_CLI_WS_API"
append_option "--ws.origins" "$GETH_CLI_WS_ORIGINS"
append_option "--ws.port" "$GETH_CLI_WS_PORT"
append_option "--ws.rpcprefix" "$GETH_CLI_WS_RPCPREFIX"
append_option "--beacon.api" "$GETH_CLI_BEACON_API"
append_option "--beacon.api.header" "$GETH_CLI_BEACON_API_HEADER"
append_option "--beacon.checkpoint" "$GETH_CLI_BEACON_CHECKPOINT"
append_option "--beacon.config" "$GETH_CLI_BEACON_CONFIG"
append_option "--beacon.genesis.gvroot" "$GETH_CLI_BEACON_GENESIS_GVROOT"
append_option "--beacon.genesis.time" "$GETH_CLI_BEACON_GENESIS_TIME"
append_option "--beacon.nofilter" "$GETH_CLI_BEACON_NOFILTER"
append_option "--beacon.threshold" "$GETH_CLI_BEACON_THRESHOLD"
append_option "--dev.gaslimit" "$GETH_CLI_DEV_GASLIMIT"
append_option "--dev.period" "$GETH_CLI_DEV_PERIOD"
append_option "--bloomfilter.size" "$GETH_CLI_BLOOMFILTER_SIZE"
append_option "--config" "$GETH_CLI_CONFIG"
append_option "--datadir" "$GETH_CLI_DATADIR"
append_option "--datadir.ancient" "$GETH_CLI_DATADIR_ANCIENT"
append_option "--datadir.minfreedisk" "$GETH_CLI_DATADIR_MINFREEDISK"
append_option "--db.engine" "$GETH_CLI_DB_ENGINE"
append_option "--eth.requiredblocks" "$GETH_CLI_ETH_REQUIREDBLOCKS"
append_option "--exitwhensynced" "$GETH_CLI_EXITWHENSYNCED"
append_option "--networkid" "$GETH_CLI_NETWORKID"
append_option "--override.cancun" "$GETH_CLI_OVERRIDE_CANCUN"
append_option "--override.verkle" "$GETH_CLI_OVERRIDE_VERKLE"
append_option "--snapshot" "$GETH_CLI_SNAPSHOT"
append_option "--gpo.blocks" "$GETH_CLI_GPO_BLOCKS"
append_option "--gpo.ignoreprice" "$GETH_CLI_GPO_IGNOREPRICE"
append_option "--gpo.maxprice" "$GETH_CLI_GPO_MAXPRICE"
append_option "--gpo.percentile" "$GETH_CLI_GPO_PERCENTILE"
append_option "--log.compress" "$GETH_CLI_LOG_COMPRESS"
append_option "--log.file" "$GETH_CLI_LOG_FILE"
append_option "--log.format" "$GETH_CLI_LOG_FORMAT"
append_option "--log.maxage" "$GETH_CLI_LOG_MAXAGE"
append_option "--log.maxbackups" "$GETH_CLI_LOG_MAXBACKUPS"
append_option "--log.maxsize" "$GETH_CLI_LOG_MAXSIZE"
append_option "--log.rotate" "$GETH_CLI_LOG_ROTATE"
append_option "--log.vmodule" "$GETH_CLI_LOG_VMODULE"
append_option "--nocompaction" "$GETH_CLI_NOCOMPACTION"
append_option "--pprof" "$GETH_CLI_PPROF"
append_option "--pprof.addr" "$GETH_CLI_PPROF_ADDR"
append_option "--pprof.blockprofilerate" "$GETH_CLI_PPROF_BLOCKPROFILERATE"
append_option "--pprof.cpuprofile" "$GETH_CLI_PPROF_CPUPROFILE"
append_option "--pprof.memprofilerate" "$GETH_CLI_PPROF_MEMPROFILERATE"
append_option "--pprof.port" "$GETH_CLI_PPROF_PORT"
append_option "--remotedb" "$GETH_CLI_REMOTEDB"
append_option "--trace" "$GETH_CLI_TRACE"
append_option "--verbosity" "$GETH_CLI_VERBOSITY"
append_option "--ethstats" "$GETH_CLI_ETHSTATS"
append_option "--metrics" "$GETH_CLI_METRICS"
append_option "--metrics.addr" "$GETH_CLI_METRICS_ADDR"
append_option "--metrics.influxdb" "$GETH_CLI_METRICS_INFLUXDB"
append_option "--metrics.influxdb.bucket" "$GETH_CLI_METRICS_INFLUXDB_BUCKET"
append_option "--metrics.influxdb.database" "$GETH_CLI_METRICS_INFLUXDB_DATABASE"
append_option "--metrics.influxdb.endpoint" "$GETH_CLI_METRICS_INFLUXDB_ENDPOINT"
append_option "--metrics.influxdb.organization" "$GETH_CLI_METRICS_INFLUXDB_ORGANIZATION"
append_option "--metrics.influxdb.password" "$GETH_CLI_METRICS_INFLUXDB_PASSWORD"
append_option "--metrics.influxdb.tags" "$GETH_CLI_METRICS_INFLUXDB_TAGS"
append_option "--metrics.influxdb.token" "$GETH_CLI_METRICS_INFLUXDB_TOKEN"
append_option "--metrics.influxdb.username" "$GETH_CLI_METRICS_INFLUXDB_USERNAME"
append_option "--metrics.influxdbv2" "$GETH_CLI_METRICS_INFLUXDBV2"
append_option "--metrics.port" "$GETH_CLI_METRICS_PORT"
append_option "--miner.extradata" "$GETH_CLI_MINER_EXTRADATA"
append_option "--miner.gaslimit" "$GETH_CLI_MINER_GASLIMIT"
append_option "--miner.gasprice" "$GETH_CLI_MINER_GASPRICE"
append_option "--miner.pending.feeRecipient" "$GETH_CLI_MINER_PENDING_FEERECIPIENT"
append_option "--miner.recommit" "$GETH_CLI_MINER_RECOMMIT"
append_option "--synctarget" "$GETH_CLI_SYNCTARGET"
append_option "--bootnodes" "$GETH_CLI_BOOTNODES"
append_option "--discovery.dns" "$GETH_CLI_DISCOVERY_DNS"
append_option "--discovery.port" "$GETH_CLI_DISCOVERY_PORT"
append_option "--discovery.v4" "$GETH_CLI_DISCOVERY_V4"
append_option "--discovery.v5" "$GETH_CLI_DISCOVERY_V5"
append_option "--identity" "$GETH_CLI_IDENTITY"
append_option "--maxpeers" "$GETH_CLI_MAXPEERS"
append_option "--maxpendpeers" "$GETH_CLI_MAXPENDPEERS"
append_option "--nat" "$GETH_CLI_NAT"
append_option "--netrestrict" "$GETH_CLI_NETRESTRICT"
append_option "--nodekey" "$GETH_CLI_NODEKEY"
append_option "--nodekeyhex" "$GETH_CLI_NODEKEYHEX"
append_option "--port" "$GETH_CLI_PORT"
append_option "--cache" "$GETH_CLI_CACHE"
append_option "--cache.blocklogs" "$GETH_CLI_CACHE_BLOCKLOGS"
append_option "--cache.database" "$GETH_CLI_CACHE_DATABASE"
append_option "--cache.gc" "$GETH_CLI_CACHE_GC"
append_option "--cache.noprefetch" "$GETH_CLI_CACHE_NOPREFETCH"
append_option "--cache.preimages" "$GETH_CLI_CACHE_PREIMAGES"
append_option "--cache.snapshot" "$GETH_CLI_CACHE_SNAPSHOT"
append_option "--cache.trie" "$GETH_CLI_CACHE_TRIE"
append_option "--crypto.kzg" "$GETH_CLI_CRYPTO_KZG"
append_option "--fdlimit" "$GETH_CLI_FDLIMIT"
append_option "--gcmode" "$GETH_CLI_GCMODE"
append_option "--history.state" "$GETH_CLI_HISTORY_STATE"
append_option "--history.transactions" "$GETH_CLI_HISTORY_TRANSACTIONS"
append_option "--state.scheme" "$GETH_CLI_STATE_SCHEME"
append_option "--syncmode" "$GETH_CLI_SYNCMODE"
append_option "--blobpool.datacap" "$GETH_CLI_BLOBPOOL_DATACAP"
append_option "--blobpool.datadir" "$GETH_CLI_BLOBPOOL_DATADIR"
append_option "--blobpool.pricebump" "$GETH_CLI_BLOBPOOL_PRICEBUMP"
append_option "--txpool.accountqueue" "$GETH_CLI_TXPOOL_ACCOUNTQUEUE"
append_option "--txpool.accountslots" "$GETH_CLI_TXPOOL_ACCOUNTSLOTS"
append_option "--txpool.globalqueue" "$GETH_CLI_TXPOOL_GLOBALQUEUE"
append_option "--txpool.globalslots" "$GETH_CLI_TXPOOL_GLOBALSLOTS"
append_option "--txpool.journal" "$GETH_CLI_TXPOOL_JOURNAL"
append_option "--txpool.lifetime" "$GETH_CLI_TXPOOL_LIFETIME"
append_option "--txpool.locals" "$GETH_CLI_TXPOOL_LOCALS"
append_option "--txpool.nolocals" "$GETH_CLI_TXPOOL_NOLOCALS"
append_option "--txpool.pricebump" "$GETH_CLI_TXPOOL_PRICEBUMP"
append_option "--txpool.pricelimit" "$GETH_CLI_TXPOOL_PRICELIMIT"
append_option "--txpool.rejournal" "$GETH_CLI_TXPOOL_REJOURNAL"
append_option "--vmdebug" "$GETH_CLI_VMDEBUG"
append_option "--vmtrace" "$GETH_CLI_VMTRACE"
append_option "--vmtrace.jsonconfig" "$GETH_CLI_VMTRACE_JSONCONFIG"


if [ -n "$SHARED_CONFIG_GENESIS_FILE" ]; then
    echo "Importing genesis state"
    geth init --datadir "$GETH_CLI_DATADIR" "$SHARED_CONFIG_GENESIS_FILE"
fi

echo "Using Options: geth $OPTIONS"

exec geth $OPTIONS
