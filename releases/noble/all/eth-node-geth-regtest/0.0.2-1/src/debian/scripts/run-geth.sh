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

# ACCOUNT
append_flag "--allow-insecure-unlock" "$allow_insecure_unlock"
append_option "--keystore" "$keystore"
append_flag "--lightkdf" "$lightkdf"
append_option "--password" "$password"
append_option "--pcscdpath" "$pcscdpath"
append_option "--signer" "$signer"
append_option "--unlock" "$unlock"
append_flag "--usb" "$usb"

# ALIASED (deprecated)
append_option "--cache.trie.journal" "$cache_trie_journal"
append_option "--cache.trie.rejournal" "$cache_trie_rejournal"
append_option "--light.egress" "$light_egress"
append_option "--light.ingress" "$light_ingress"
append_option "--light.maxpeers" "$light_maxpeers"
append_flag "--light.nopruning" "$light_nopruning"
append_flag "--light.nosyncserve" "$light_nosyncserve"
append_option "--light.serve" "$light_serve"
append_option "--log.backtrace" "$log_backtrace"
append_flag "--log.debug" "$log_debug"
append_flag "--metrics.expensive" "$metrics_expensive"
append_flag "--mine" "$mine"
append_option "--miner.etherbase" "$miner_etherbase"
append_option "--miner.newpayload-timeout" "$miner_newpayload_timeout"
append_flag "--nousb" "$nousb"
append_option "--txlookuplimit" "$txlookuplimit"
append_flag "--v5disc" "$v5disc"
append_option "--whitelist" "$whitelist"

# API AND CONSOLE
append_option "--authrpc.addr" "$authrpc_addr"
append_option "--authrpc.jwtsecret" "$authrpc_jwtsecret"
append_option "--authrpc.port" "$authrpc_port"
append_option "--authrpc.vhosts" "$authrpc_vhosts"
append_option "--exec" "$exec"
append_flag "--graphql" "$graphql"
append_option "--graphql.corsdomain" "$graphql_corsdomain"
append_option "--graphql.vhosts" "$graphql_vhosts"
append_option "--header" "$header"
append_flag "--http" "$http"
append_option "--http.addr" "$http_addr"
append_option "--http.api" "$http_api"
append_option "--http.corsdomain" "$http_corsdomain"
append_option "--http.port" "$http_port"
append_option "--http.rpcprefix" "$http_rpcprefix"
append_option "--http.vhosts" "$http_vhosts"
append_flag "--ipcdisable" "$ipcdisable"
append_option "--ipcpath" "$ipcpath"
append_option "--jspath" "$jspath"
append_option "--preload" "$preload"
append_flag "--rpc.allow-unprotected-txs" "$rpc_allow_unprotected_txs"
append_option "--rpc.batch-request-limit" "$rpc_batch_request_limit"
append_option "--rpc.batch-response-max-size" "$rpc_batch_response_max_size"
append_flag "--rpc.enabledeprecatedpersonal" "$rpc_enabledeprecatedpersonal"
append_option "--rpc.evmtimeout" "$rpc_evmtimeout"
append_option "--rpc.gascap" "$rpc_gascap"
append_option "--rpc.txfeecap" "$rpc_txfeecap"
append_flag "--ws" "$ws"
append_option "--ws.addr" "$ws_addr"
append_option "--ws.api" "$ws_api"
append_option "--ws.origins" "$ws_origins"
append_option "--ws.port" "$ws_port"
append_option "--ws.rpcprefix" "$ws_rpcprefix"

# BEACON CHAIN
append_option "--beacon.api" "$beacon_api"
append_option "--beacon.api.header" "$beacon_api_header"
append_option "--beacon.checkpoint" "$beacon_checkpoint"
append_option "--beacon.config" "$beacon_config"
append_option "--beacon.genesis.gvroot" "$beacon_genesis_gvroot"
append_option "--beacon.genesis.time" "$beacon_genesis_time"
append_flag "--beacon.nofilter" "$beacon_nofilter"
append_option "--beacon.threshold" "$beacon_threshold"

# DEVELOPER CHAIN
append_flag "--dev" "$dev"
append_option "--dev.gaslimit" "$dev_gaslimit"
append_option "--dev.period" "$dev_period"

# ETHEREUM
append_option "--bloomfilter.size" "$bloomfilter_size"
append_option "--config" "$config"
append_option "--datadir" "$datadir"
append_option "--datadir.ancient" "$datadir_ancient"
append_option "--datadir.minfreedisk" "$datadir_minfreedisk"
append_option "--db.engine" "$db_engine"
append_option "--eth.requiredblocks" "$eth_requiredblocks"
append_flag "--exitwhensynced" "$exitwhensynced"
append_flag "--holesky" "$holesky"
append_flag "--mainnet" "$mainnet"
append_option "--networkid" "$networkid"
append_option "--override.cancun" "$override_cancun"
append_option "--override.verkle" "$override_verkle"
append_flag "--sepolia" "$sepolia"
append_flag "--snapshot" "$snapshot"

# GAS PRICE ORACLE
append_option "--gpo.blocks" "$gpo_blocks"
append_option "--gpo.ignoreprice" "$gpo_ignoreprice"
append_option "--gpo.maxprice" "$gpo_maxprice"
append_option "--gpo.percentile" "$gpo_percentile"

# LOGGING AND DEBUGGING
append_flag "--log.compress" "$log_compress"
append_option "--log.file" "$log_file"
append_option "--log.format" "$log_format"
append_option "--log.maxage" "$log_maxage"
append_option "--log.maxbackups" "$log_maxbackups"
append_option "--log.maxsize" "$log_maxsize"
append_flag "--log.rotate" "$log_rotate"
append_option "--log.vmodule" "$log_vmodule"
append_flag "--nocompaction" "$nocompaction"
append_flag "--pprof" "$pprof"
append_option "--pprof.addr" "$pprof_addr"
append_option "--pprof.blockprofilerate" "$pprof_blockprofilerate"
append_option "--pprof.cpuprofile" "$pprof_cpuprofile"
append_option "--pprof.memprofilerate" "$pprof_memprofilerate"
append_option "--pprof.port" "$pprof_port"
append_option "--remotedb" "$remotedb"
append_option "--trace" "$trace"
append_option "--verbosity" "$verbosity"

# METRICS AND STATS
append_option "--ethstats" "$ethstats"
append_flag "--metrics" "$metrics"
append_option "--metrics.addr" "$metrics_addr"
append_flag "--metrics.influxdb" "$metrics_influxdb"
append_option "--metrics.influxdb.bucket" "$metrics_influxdb_bucket"
append_option "--metrics.influxdb.database" "$metrics_influxdb_database"
append_option "--metrics.influxdb.endpoint" "$metrics_influxdb_endpoint"
append_option "--metrics.influxdb.organization" "$metrics_influxdb_organization"
append_option "--metrics.influxdb.password" "$metrics_influxdb_password"
append_option "--metrics.influxdb.tags" "$metrics_influxdb_tags"
append_option "--metrics.influxdb.token" "$metrics_influxdb_token"
append_option "--metrics.influxdb.username" "$metrics_influxdb_username"
append_flag "--metrics.influxdbv2" "$metrics_influxdbv2"
append_option "--metrics.port" "$metrics_port"

# MINER
append_option "--miner.extradata" "$miner_extradata"
append_option "--miner.gaslimit" "$miner_gaslimit"
append_option "--miner.gasprice" "$miner_gasprice"
append_option "--miner.pending.feeRecipient" "$miner_pending_feerecipient"
append_option "--miner.recommit" "$miner_recommit"

# MISC
append_option "--synctarget" "$synctarget"

# NETWORKING
append_option "--bootnodes" "$bootnodes"
append_option "--discovery.dns" "$discovery_dns"
append_option "--discovery.port" "$discovery_port"
append_flag "--discovery.v4" "$discovery_v4"
append_flag "--discovery.v5" "$discovery_v5"
append_option "--identity" "$identity"
append_option "--maxpeers" "$maxpeers"
append_option "--maxpendpeers" "$maxpendpeers"
append_option "--nat" "$nat"
append_option "--netrestrict" "$netrestrict"
append_option "--nodekey" "$nodekey"
append_option "--nodekeyhex" "$nodekeyhex"
append_flag "--nodiscover" "$nodiscover"
append_option "--port" "$port"

# PERFORMANCE TUNING
append_option "--cache" "$cache"
append_option "--cache.blocklogs" "$cache_blocklogs"
append_option "--cache.database" "$cache_database"
append_option "--cache.gc" "$cache_gc"
append_flag "--cache.noprefetch" "$cache_noprefetch"
append_flag "--cache.preimages" "$cache_preimages"
append_option "--cache.snapshot" "$cache_snapshot"
append_option "--cache.trie" "$cache_trie"
append_option "--crypto.kzg" "$crypto_kzg"
append_option "--fdlimit" "$fdlimit"

# STATE HISTORY MANAGEMENT
append_option "--gcmode" "$gcmode"
append_option "--history.state" "$history_state"
append_option "--history.transactions" "$history_transactions"
append_option "--state.scheme" "$state_scheme"
append_option "--syncmode" "$syncmode"

# TRANSACTION POOL (BLOB)
append_option "--blobpool.datacap" "$blobpool_datacap"
append_option "--blobpool.datadir" "$blobpool_datadir"
append_option "--blobpool.pricebump" "$blobpool_pricebump"

# TRANSACTION POOL (EVM)
append_option "--txpool.accountqueue" "$txpool_accountqueue"
append_option "--txpool.accountslots" "$txpool_accountslots"
append_option "--txpool.globalqueue" "$txpool_globalqueue"
append_option "--txpool.globalslots" "$txpool_globalslots"
append_option "--txpool.journal" "$txpool_journal"
append_option "--txpool.lifetime" "$txpool_lifetime"
append_option "--txpool.locals" "$txpool_locals"
append_flag "--txpool.nolocals" "$txpool_nolocals"
append_option "--txpool.pricebump" "$txpool_pricebump"
append_option "--txpool.pricelimit" "$txpool_pricelimit"
append_option "--txpool.rejournal" "$txpool_rejournal"

# VIRTUAL MACHINE
append_flag "--vmdebug" "$vmdebug"
append_option "--vmtrace" "$vmtrace"
append_option "--vmtrace.jsonconfig" "$vmtrace_jsonconfig"




if [ -n "$TESTNET_DIR" ]; then
    echo "Importing genesis state"
    geth init --datadir "$datadir" "$TESTNET_DIR/genesis.json"
fi

echo "Using Options: geth $OPTIONS"

exec geth $OPTIONS
