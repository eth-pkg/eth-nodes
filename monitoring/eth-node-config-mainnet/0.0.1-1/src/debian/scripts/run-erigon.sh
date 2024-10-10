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

add_option() {
  local option=$1
  local value=$2
  if [ -n "$value" ]; then
    if [ "$value" == "" ];then 
        OPTIONS="$OPTIONS $option"
    else 
        OPTIONS="$OPTIONS $option=$value"
    fi 
  fi
}


add_option "--datadir" "$ERIGON_CLI_DATADIR"
add_option "--ethash.dagdir" "$ERIGON_CLI_ETHASH_DAGDIR"
add_option "--snapshots" "$ERIGON_CLI_SNAPSHOTS"
add_option "--internalcl" "$ERIGON_CLI_INTERNALCL"
add_option "--txpool.disable" "$ERIGON_CLI_TXPOOL_DISABLE"
add_option "--txpool.locals" "$ERIGON_CLI_TXPOOL_LOCALS"
add_option "--txpool.nolocals" "$ERIGON_CLI_TXPOOL_NOLOCALS"
add_option "--txpool.pricelimit" "$ERIGON_CLI_TXPOOL_PRICELIMIT"
add_option "--txpool.pricebump" "$ERIGON_CLI_TXPOOL_PRICEBUMP"
add_option "--txpool.blobpricebump" "$ERIGON_CLI_TXPOOL_BLOBPRICEBUMP"
add_option "--txpool.accountslots" "$ERIGON_CLI_TXPOOL_ACCOUNTSLOTS"
add_option "--txpool.blobslots" "$ERIGON_CLI_TXPOOL_BLOBSLOTS"
add_option "--txpool.totalblobpoollimit" "$ERIGON_CLI_TXPOOL_TOTALBLOBPOOLLIMIT"
add_option "--txpool.globalslots" "$ERIGON_CLI_TXPOOL_GLOBALSLOTS"
add_option "--txpool.globalbasefeeslots" "$ERIGON_CLI_TXPOOL_GLOBALBASEFEESLOTS"
add_option "--txpool.accountqueue" "$ERIGON_CLI_TXPOOL_ACCOUNTQUEUE"
add_option "--txpool.globalqueue" "$ERIGON_CLI_TXPOOL_GLOBALQUEUE"
add_option "--txpool.lifetime" "$ERIGON_CLI_TXPOOL_LIFETIME"
add_option "--txpool.trace.senders" "$ERIGON_CLI_TXPOOL_TRACE_SENDERS"
add_option "--txpool.commit.every" "$ERIGON_CLI_TXPOOL_COMMIT_EVERY"
add_option "--prune" "$ERIGON_CLI_PRUNE"
add_option "--prune.h.older" "$ERIGON_CLI_PRUNE_H_OLDER"
add_option "--prune.r.older" "$ERIGON_CLI_PRUNE_R_OLDER"
add_option "--prune.t.older" "$ERIGON_CLI_PRUNE_T_OLDER"
add_option "--prune.c.older" "$ERIGON_CLI_PRUNE_C_OLDER"
add_option "--prune.h.before" "$ERIGON_CLI_PRUNE_H_BEFORE"
add_option "--prune.r.before" "$ERIGON_CLI_PRUNE_R_BEFORE"
add_option "--prune.t.before" "$ERIGON_CLI_PRUNE_T_BEFORE"
add_option "--prune.c.before" "$ERIGON_CLI_PRUNE_C_BEFORE"
add_option "--batchSize" "$ERIGON_CLI_BATCH_SIZE"
add_option "--bodies.cache" "$ERIGON_CLI_BODIES_CACHE"
add_option "--database.verbosity" "$ERIGON_CLI_DATABASE_VERBOSITY"
add_option "--private.api.addr" "$ERIGON_CLI_PRIVATE_API_ADDR"
add_option "--private.api.ratelimit" "$ERIGON_CLI_PRIVATE_API_RATELIMIT"
add_option "--etl.bufferSize" "$ERIGON_CLI_ETL_BUFFER_SIZE"
add_option "--tls" "$ERIGON_CLI_TLS"
add_option "--tls.cert" "$ERIGON_CLI_TLS_CERT"
add_option "--tls.key" "$ERIGON_CLI_TLS_KEY"
add_option "--tls.cacert" "$ERIGON_CLI_TLS_CACERT"
add_option "--state.stream.disable" "$ERIGON_CLI_STATE_STREAM_DISABLE"
add_option "--sync.loop.throttle" "$ERIGON_CLI_SYNC_LOOP_THROTTLE"
add_option "--bad.block" "$ERIGON_CLI_BAD_BLOCK"
add_option "--http" "$ERIGON_CLI_HTTP"
add_option "--http.enabled" "$ERIGON_CLI_HTTP_ENABLED"
add_option "--graphql" "$ERIGON_CLI_GRAPHQL"
add_option "--http.addr" "$ERIGON_CLI_HTTP_ADDR"
add_option "--http.port" "$ERIGON_CLI_HTTP_PORT"
add_option "--authrpc.addr" "$ERIGON_CLI_AUTHRPC_ADDR"
add_option "--authrpc.port" "$ERIGON_CLI_AUTHRPC_PORT"
add_option "--authrpc.jwtsecret" "$ERIGON_CLI_AUTHRPC_JWTSECRET"
add_option "--http.compression" "$ERIGON_CLI_HTTP_COMPRESSION"
add_option "--http.corsdomain" "$ERIGON_CLI_HTTP_CORSDOMAIN"
add_option "--http.vhosts" "$ERIGON_CLI_HTTP_VHOSTS"
add_option "--authrpc.vhosts" "$ERIGON_CLI_AUTHRPC_VHOSTS"
add_option "--http.api" "$ERIGON_CLI_HTTP_API"
add_option "--ws.port" "$ERIGON_CLI_WS_PORT"
add_option "--ws" "$ERIGON_CLI_WS"
add_option "--ws.compression" "$ERIGON_CLI_WS_COMPRESSION"
add_option "--http.trace" "$ERIGON_CLI_HTTP_TRACE"
add_option "--http.dbg.single" "$ERIGON_CLI_HTTP_DBG_SINGLE"
add_option "--state.cache" "$ERIGON_CLI_STATE_CACHE"
add_option "--rpc.batch.concurrency" "$ERIGON_CLI_RPC_BATCH_CONCURRENCY"
add_option "--rpc.streaming.disable" "$ERIGON_CLI_RPC_STREAMING_DISABLE"
add_option "--db.read.concurrency" "$ERIGON_CLI_DB_READ_CONCURRENCY"
add_option "--rpc.accessList" "$ERIGON_CLI_RPC_ACCESSLIST"
add_option "--trace.compat" "$ERIGON_CLI_TRACE_COMPAT"
add_option "--rpc.gascap" "$ERIGON_CLI_RPC_GASCAP"
add_option "--rpc.batch.limit" "$ERIGON_CLI_RPC_BATCH_LIMIT"
add_option "--rpc.returndata.limit" "$ERIGON_CLI_RPC_RETURNDATA_LIMIT"
add_option "--rpc.allow-unprotected-txs" "$ERIGON_CLI_RPC_ALLOW_UNPROTECTED_TXS"
add_option "--rpc.maxgetproofrewindblockcount.limit" "$ERIGON_CLI_RPC_MAXGETPROOFREWINDBLOCKCOUNT_LIMIT"
add_option "--rpc.txfeecap" "$ERIGON_CLI_RPC_TXFEECAP"
add_option "--txpool.api.addr" "$ERIGON_CLI_TXPOOL_API_ADDR"
add_option "--trace.maxtraces" "$ERIGON_CLI_TRACE_MAXTRACES"
add_option "--http.timeouts.read" "$ERIGON_CLI_HTTP_TIMEOUTS_READ"
add_option "--http.timeouts.write" "$ERIGON_CLI_HTTP_TIMEOUTS_WRITE"
add_option "--http.timeouts.idle" "$ERIGON_CLI_HTTP_TIMEOUTS_IDLE"
add_option "--authrpc.timeouts.read" "$ERIGON_CLI_AUTHRPC_TIMEOUTS_READ"
add_option "--authrpc.timeouts.write" "$ERIGON_CLI_AUTHRPC_TIMEOUTS_WRITE"
add_option "--authrpc.timeouts.idle" "$ERIGON_CLI_AUTHRPC_TIMEOUTS_IDLE"
add_option "--rpc.evmtimeout" "$ERIGON_CLI_RPC_EVMTIMEOUT"
add_option "--rpc.overlay.getlogstimeout" "$ERIGON_CLI_RPC_OVERLAY_GETLOGSTIMEOUT"
add_option "--rpc.overlay.replayblocktimeout" "$ERIGON_CLI_RPC_OVERLAY_REPLAYBLOCKTIMEOUT"
add_option "--snap.keepblocks" "$ERIGON_CLI_SNAP_KEEPBLOCKS"
add_option "--snap.stop" "$ERIGON_CLI_SNAP_STOP"
add_option "--db.pagesize" "$ERIGON_CLI_DB_PAGESIZE"
add_option "--db.size.limit" "$ERIGON_CLI_DB_SIZE_LIMIT"
add_option "--force.partial.commit" "$ERIGON_CLI_FORCE_PARTIAL_COMMIT"
add_option "--torrent.port" "$ERIGON_CLI_TORRENT_PORT"
add_option "--torrent.conns.perfile" "$ERIGON_CLI_TORRENT_CONN_PERFILE"
add_option "--torrent.download.slots" "$ERIGON_CLI_TORRENT_DOWNLOAD_SLOTS"
add_option "--torrent.staticpeers" "$ERIGON_CLI_TORRENT_STATICPEERS"
add_option "--torrent.upload.rate" "$ERIGON_CLI_TORRENT_UPLOAD_RATE"
add_option "--torrent.download.rate" "$ERIGON_CLI_TORRENT_DOWNLOAD_RATE"
add_option "--torrent.verbosity" "$ERIGON_CLI_TORRENT_VERBOSITY"
add_option "--port" "$ERIGON_CLI_PORT"
add_option "--p2p.protocol" "$ERIGON_CLI_P2P_PROTOCOL"
add_option "--p2p.allowed-ports" "$ERIGON_CLI_P2P_ALLOWED_PORTS"
add_option "--nat" "$ERIGON_CLI_NAT"
add_option "--nodiscover" "$ERIGON_CLI_NODISCOVER"
add_option "--v5disc" "$ERIGON_CLI_V5DISC"
add_option "--netrestrict" "$ERIGON_CLI_NETRESTRICT"
add_option "--nodekey" "$ERIGON_CLI_NODEKEY"
add_option "--nodekeyhex" "$ERIGON_CLI_NODEKEYHEX"
add_option "--discovery.dns" "$ERIGON_CLI_DISCOVERY_DNS"
add_option "--bootnodes" "$ERIGON_CLI_BOOTNODES"
add_option "--staticpeers" "$ERIGON_CLI_STATICPEERS"
add_option "--trustedpeers" "$ERIGON_CLI_TRUSTEDPEERS"
add_option "--maxpeers" "$ERIGON_CLI_MAXPEERS"
add_option "--chain" "$ERIGON_CLI_CHAIN"
add_option "--dev.period" "$ERIGON_CLI_DEV_PERIOD"
add_option "--vmdebug" "$ERIGON_CLI_VMDEBUG"
add_option "--networkid" "$ERIGON_CLI_NETWORKID"
add_option "--fakepow" "$ERIGON_CLI_FAKEPOW"
add_option "--gpo.blocks" "$ERIGON_CLI_GPO_BLOCKS"
add_option "--gpo.percentile" "$ERIGON_CLI_GPO_PERCENTILE"
add_option "--allow-insecure-unlock" "$ERIGON_CLI_ALLOW_INSECURE_UNLOCK"
add_option "--identity" "$ERIGON_CLI_IDENTITY"
add_option "--clique.checkpoint" "$ERIGON_CLI_CLIQUE_CHECKPOINT"
add_option "--clique.snapshots" "$ERIGON_CLI_CLIQUE_SNAPSHOTS"
add_option "--clique.signatures" "$ERIGON_CLI_CLIQUE_SIGNATURES"
add_option "--clique.datadir" "$ERIGON_CLI_CLIQUE_DATADIR"
add_option "--mine" "$ERIGON_CLI_MINE"
add_option "--proposer.disable" "$ERIGON_CLI_PROPOSER_DISABLE"
add_option "--miner.notify" "$ERIGON_CLI_MINER_NOTIFY"
add_option "--miner.gaslimit" "$ERIGON_CLI_MINER_GASLIMIT"
add_option "--miner.etherbase" "$ERIGON_CLI_MINER_ETHERBASE"
add_option "--miner.extradata" "$ERIGON_CLI_MINER_EXTRADATA"
add_option "--miner.noverify" "$ERIGON_CLI_MINER_NOVERIFY"
add_option "--miner.sigfile" "$ERIGON_CLI_MINER_SIGFILE"
add_option "--miner.recommit" "$ERIGON_CLI_MINER_RECOMMIT"
add_option "--sentry.api.addr" "$ERIGON_CLI_SENTRY_API_ADDR"
add_option "--sentry.log-peer-info" "$ERIGON_CLI_SENTRY_LOG_PEER_INFO"
add_option "--downloader.api.addr" "$ERIGON_CLI_DOWNLOADER_API_ADDR"
add_option "--downloader.disable.ipv4" "$ERIGON_CLI_DOWNLOADER_DISABLE_IPV4"
add_option "--downloader.disable.ipv6" "$ERIGON_CLI_DOWNLOADER_DISABLE_IPV6"
add_option "--no-downloader" "$ERIGON_CLI_NO_DOWNLOADER"
add_option "--downloader.verify" "$ERIGON_CLI_DOWNLOADER_VERIFY"
add_option "--healthcheck" "$ERIGON_CLI_HEALTHCHECK"
add_option "--bor.heimdall" "$ERIGON_CLI_BOR_HEIMDALL"
add_option "--webseed" "$ERIGON_CLI_WEBSEED"
add_option "--bor.withoutheimdall" "$ERIGON_CLI_BOR_WITHOUTHEIMDALL"
add_option "--bor.period" "$ERIGON_CLI_BOR_PERIOD"
add_option "--bor.minblocksize" "$ERIGON_CLI_BOR_MINBLOCKSIZE"
add_option "--bor.milestone" "$ERIGON_CLI_BOR_MILESTONE"
add_option "--bor.waypoints" "$ERIGON_CLI_BOR_WAYPOINTS"
add_option "--polygon.sync" "$ERIGON_CLI_POLYGON_SYNC"
add_option "--ethstats" "$ERIGON_CLI_ETHSTATS"
add_option "--override.prague" "$ERIGON_CLI_OVERRIDE_PRAGUE"
add_option "--lightclient.discovery.addr" "$ERIGON_CLI_LIGHTCLIENT_DISCOVERY_ADDR"
add_option "--lightclient.discovery.port" "$ERIGON_CLI_LIGHTCLIENT_DISCOVERY_PORT"
add_option "--lightclient.discovery.tcpport" "$ERIGON_CLI_LIGHTCLIENT_DISCOVERY_TCPPORT"
add_option "--sentinel.addr" "$ERIGON_CLI_SENTINEL_ADDR"
add_option "--sentinel.port" "$ERIGON_CLI_SENTINEL_PORT"
add_option "--ots.search.max.pagesize" "$ERIGON_CLI_OTS_SEARCH_MAX_PAGESIZE"
add_option "--silkworm.exec" "$ERIGON_CLI_SILKWORM_EXEC"
add_option "--silkworm.rpc" "$ERIGON_CLI_SILKWORM_RPC"
add_option "--silkworm.sentry" "$ERIGON_CLI_SILKWORM_SENTRY"
add_option "--silkworm.verbosity" "$ERIGON_CLI_SILKWORM_VERBOSITY"
add_option "--silkworm.contexts" "$ERIGON_CLI_SILKWORM_CONTEXTS"
add_option "--silkworm.rpc.log" "$ERIGON_CLI_SILKWORM_RPC_LOG"
add_option "--silkworm.rpc.log.maxsize" "$ERIGON_CLI_SILKWORM_RPC_LOG_MAXSIZE"
add_option "--silkworm.rpc.log.maxfiles" "$ERIGON_CLI_SILKWORM_RPC_LOG_MAXFILES"
add_option "--silkworm.rpc.log.response" "$ERIGON_CLI_SILKWORM_RPC_LOG_RESPONSE"
add_option "--silkworm.rpc.workers" "$ERIGON_CLI_SILKWORM_RPC_WORKERS"
add_option "--silkworm.rpc.compatibility" "$ERIGON_CLI_SILKWORM_RPC_COMPATIBILITY"
add_option "--beacon.api" "$ERIGON_CLI_BEACON_API"
add_option "--beacon.api.addr" "$ERIGON_CLI_BEACON_API_ADDR"
add_option "--beacon.api.cors.allow-methods" "$ERIGON_CLI_BEACON_API_CORS_ALLOW_METHODS"
add_option "--beacon.api.cors.allow-origins" "$ERIGON_CLI_BEACON_API_CORS_ALLOW_ORIGINS"
add_option "--beacon.api.cors.allow-credentials" "$ERIGON_CLI_BEACON_API_CORS_ALLOW_CREDENTIALS"
add_option "--beacon.api.port" "$ERIGON_CLI_BEACON_API_PORT"
add_option "--beacon.api.read.timeout" "$ERIGON_CLI_BEACON_API_READ_TIMEOUT"
add_option "--beacon.api.write.timeout" "$ERIGON_CLI_BEACON_API_WRITE_TIMEOUT"
add_option "--beacon.api.protocol" "$ERIGON_CLI_BEACON_API_PROTOCOL"
add_option "--beacon.api.ide.timeout" "$ERIGON_CLI_BEACON_API_IDE_TIMEOUT"
add_option "--caplin.backfilling" "$ERIGON_CLI_CAPLIN_BACKFILLING"
add_option "--caplin.backfilling.blob" "$ERIGON_CLI_CAPLIN_BACKFILLING_BLOB"
add_option "--caplin.backfilling.blob.no-pruning" "$ERIGON_CLI_CAPLIN_BACKFILLING_BLOB_NO_PRUNING"
add_option "--caplin.archive" "$ERIGON_CLI_CAPLIN_ARCHIVE"
add_option "--trusted-setup-file" "$ERIGON_CLI_TRUSTED_SETUP_FILE"
add_option "--rpc.slow" "$ERIGON_CLI_RPC_SLOW"
add_option "--txpool.gossip.disable" "$ERIGON_CLI_TXPOOL_GOSSIP_DISABLE"
add_option "--sync.loop.block.limit" "$ERIGON_CLI_SYNC_LOOP_BLOCK_LIMIT"
add_option "--sync.loop.break.after" "$ERIGON_CLI_SYNC_LOOP_BREAK_AFTER"
add_option "--sync.loop.prune.limit" "$ERIGON_CLI_SYNC_LOOP_PRUNE_LIMIT"
add_option "--pprof" "$ERIGON_CLI_PPROF"
add_option "--pprof.addr" "$ERIGON_CLI_PPROF_ADDR"
add_option "--pprof.port" "$ERIGON_CLI_PPROF_PORT"
add_option "--pprof.cpuprofile" "$ERIGON_CLI_PPROF_CPUPROFILE"
add_option "--trace" "$ERIGON_CLI_TRACE"
add_option "--metrics" "$ERIGON_CLI_METRICS"
add_option "--metrics.addr" "$ERIGON_CLI_METRICS_ADDR"
add_option "--metrics.port" "$ERIGON_CLI_METRICS_PORT"
add_option "--diagnostics.disabled" "$ERIGON_CLI_DIAGNOSTICS_DISABLED"
add_option "--diagnostics.endpoint.addr" "$ERIGON_CLI_DIAGNOSTICS_ENDPOINT_ADDR"
add_option "--diagnostics.endpoint.port" "$ERIGON_CLI_DIAGNOSTICS_ENDPOINT_PORT"
add_option "--log.json" "$ERIGON_CLI_LOG_JSON"
add_option "--log.console.json" "$ERIGON_CLI_LOG_CONSOLE_JSON"
add_option "--log.dir.json" "$ERIGON_CLI_LOG_DIR_JSON"
add_option "--verbosity" "$ERIGON_CLI_VERBOSITY"
add_option "--log.console.verbosity" "$ERIGON_CLI_LOG_CONSOLE_VERBOSITY"
add_option "--log.dir.disable" "$ERIGON_CLI_LOG_DIR_DISABLE"
add_option "--log.dir.path" "$ERIGON_CLI_LOG_DIR_PATH"
add_option "--log.dir.prefix" "$ERIGON_CLI_LOG_DIR_PREFIX"
add_option "--log.dir.verbosity" "$ERIGON_CLI_LOG_DIR_VERBOSITY"
add_option "--log.delays" "$ERIGON_CLI_LOG_DELAYS"
add_option "--config" "$ERIGON_CLI_CONFIG"

echo "Using Options: erigon $OPTIONS"

exec erigon $OPTIONS