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

add_option() {
    local option=$1
    local value=$2
    if [ -n "$value" ]; then
        if [ "$value" == "" ]; then
            OPTIONS="$OPTIONS $option"
        else
            OPTIONS="$OPTIONS $option=$value"
        fi
    fi
}

append_flag() {
    local option=$1
    local value=$2
    if [ "$value" = "true" ]; then
        OPTIONS="$OPTIONS $option"
    fi
}

add_option "--datadir" "$ERIGON_DATADIR"
add_option "--ethash.dagdir" "$ERIGON_ETHASH_DAGDIR"
append_flag "--snapshots" "$ERIGON_SNAPSHOTS"
append_flag "--internalcl" "$ERIGON_INTERNALCL"
append_flag "--txpool.disable" "$ERIGON_TXPOOL_DISABLE"
add_option "--txpool.locals" "$ERIGON_TXPOOL_LOCALS"
append_flag "--txpool.nolocals" "$ERIGON_TXPOOL_NOLOCALS"
add_option "--txpool.pricelimit" "$ERIGON_TXPOOL_PRICELIMIT"
add_option "--txpool.pricebump" "$ERIGON_TXPOOL_PRICEBUMP"
add_option "--txpool.blobpricebump" "$ERIGON_TXPOOL_BLOBPRICEBUMP"
add_option "--txpool.accountslots" "$ERIGON_TXPOOL_ACCOUNTSLOTS"
add_option "--txpool.blobslots" "$ERIGON_TXPOOL_BLOBSLOTS"
add_option "--txpool.totalblobpoollimit" "$ERIGON_TXPOOL_TOTALBLOBPOOLLIMIT"
add_option "--txpool.globalslots" "$ERIGON_TXPOOL_GLOBALSLOTS"
add_option "--txpool.globalbasefeeslots" "$ERIGON_TXPOOL_GLOBALBASEFEESLOTS"
add_option "--txpool.accountqueue" "$ERIGON_TXPOOL_ACCOUNTQUEUE"
add_option "--txpool.globalqueue" "$ERIGON_TXPOOL_GLOBALQUEUE"
add_option "--txpool.lifetime" "$ERIGON_TXPOOL_LIFETIME"
add_option "--txpool.trace.senders" "$ERIGON_TXPOOL_TRACE_SENDERS"
add_option "--txpool.commit.every" "$ERIGON_TXPOOL_COMMIT_EVERY"
add_option "--prune" "$ERIGON_PRUNE"
add_option "--prune.h.older" "$ERIGON_PRUNE_H_OLDER"
add_option "--prune.r.older" "$ERIGON_PRUNE_R_OLDER"
add_option "--prune.t.older" "$ERIGON_PRUNE_T_OLDER"
add_option "--prune.c.older" "$ERIGON_PRUNE_C_OLDER"
add_option "--prune.h.before" "$ERIGON_PRUNE_H_BEFORE"
add_option "--prune.r.before" "$ERIGON_PRUNE_R_BEFORE"
add_option "--prune.t.before" "$ERIGON_PRUNE_T_BEFORE"
add_option "--prune.c.before" "$ERIGON_PRUNE_C_BEFORE"
add_option "--batchsize" "$ERIGON_BATCHSIZE"
add_option "--bodies.cache" "$ERIGON_BODIES_CACHE"
add_option "--database.verbosity" "$ERIGON_DATABASE_VERBOSITY"
add_option "--private.api.addr" "$ERIGON_PRIVATE_API_ADDR"
add_option "--private.api.ratelimit" "$ERIGON_PRIVATE_API_RATELIMIT"
add_option "--etl.buffersize" "$ERIGON_ETL_BUFFERSIZE"
append_flag "--tls" "$ERIGON_TLS"
add_option "--tls.cert" "$ERIGON_TLS_CERT"
add_option "--tls.key" "$ERIGON_TLS_KEY"
add_option "--tls.cacert" "$ERIGON_TLS_CACERT"
append_flag "--state.stream.disable" "$ERIGON_STATE_STREAM_DISABLE"
add_option "--sync.loop.throttle" "$ERIGON_SYNC_LOOP_THROTTLE"
add_option "--bad.block" "$ERIGON_BAD_BLOCK"
append_flag "--http" "$ERIGON_HTTP"
append_flag "--http.enabled" "$ERIGON_HTTP_ENABLED"
append_flag "--graphql" "$ERIGON_GRAPHQL"
add_option "--http.addr" "$ERIGON_HTTP_ADDR"
add_option "--http.port" "$ERIGON_HTTP_PORT"
add_option "--authrpc.addr" "$ERIGON_AUTHRPC_ADDR"
add_option "--authrpc.port" "$ERIGON_AUTHRPC_PORT"
add_option "--authrpc.jwtsecret" "$ERIGON_AUTHRPC_JWTSECRET"
append_flag "--http.compression" "$ERIGON_HTTP_COMPRESSION"
add_option "--http.corsdomain" "$ERIGON_HTTP_CORSDOMAIN"
add_option "--http.vhosts" "$ERIGON_HTTP_VHOSTS"
add_option "--authrpc.vhosts" "$ERIGON_AUTHRPC_VHOSTS"
add_option "--http.api" "$ERIGON_HTTP_API"
add_option "--ws.port" "$ERIGON_WS_PORT"
append_flag "--ws" "$ERIGON_WS"
append_flag "--ws.compression" "$ERIGON_WS_COMPRESSION"
append_flag "--http.trace" "$ERIGON_HTTP_TRACE"
append_flag "--http.dbg.single" "$ERIGON_HTTP_DBG_SINGLE"
add_option "--state.cache" "$ERIGON_STATE_CACHE"
add_option "--rpc.batch.concurrency" "$ERIGON_RPC_BATCH_CONCURRENCY"
append_flag "--rpc.streaming.disable" "$ERIGON_RPC_STREAMING_DISABLE"
add_option "--db.read.concurrency" "$ERIGON_DB_READ_CONCURRENCY"
add_option "--rpc.accesslist" "$ERIGON_RPC_ACCESSLIST"
append_flag "--trace.compat" "$ERIGON_TRACE_COMPAT"
add_option "--rpc.gascap" "$ERIGON_RPC_GASCAP"
add_option "--rpc.batch.limit" "$ERIGON_RPC_BATCH_LIMIT"
add_option "--rpc.returndata.limit" "$ERIGON_RPC_RETURNDATA_LIMIT"
append_flag "--rpc.allow-unprotected-txs" "$ERIGON_RPC_ALLOW_UNPROTECTED_TXS"
add_option "--rpc.maxgetproofrewindblockcount.limit" "$ERIGON_RPC_MAXGETPROOFREWINDBLOCKCOUNT_LIMIT"
add_option "--rpc.txfeecap" "$ERIGON_RPC_TXFEECAP"
add_option "--txpool.api.addr" "$ERIGON_TXPOOL_API_ADDR"
add_option "--trace.maxtraces" "$ERIGON_TRACE_MAXTRACES"
add_option "--http.timeouts.read" "$ERIGON_HTTP_TIMEOUTS_READ"
add_option "--http.timeouts.write" "$ERIGON_HTTP_TIMEOUTS_WRITE"
add_option "--http.timeouts.idle" "$ERIGON_HTTP_TIMEOUTS_IDLE"
add_option "--authrpc.timeouts.read" "$ERIGON_AUTHRPC_TIMEOUTS_READ"
add_option "--authrpc.timeouts.write" "$ERIGON_AUTHRPC_TIMEOUTS_WRITE"
add_option "--authrpc.timeouts.idle" "$ERIGON_AUTHRPC_TIMEOUTS_IDLE"
add_option "--rpc.evmtimeout" "$ERIGON_RPC_EVMTIMEOUT"
add_option "--rpc.overlay.getlogstimeout" "$ERIGON_RPC_OVERLAY_GETLOGSTIMEOUT"
add_option "--rpc.overlay.replayblocktimeout" "$ERIGON_RPC_OVERLAY_REPLAYBLOCKTIMEOUT"
add_option "--snap.keepblocks" "$ERIGON_SNAP_KEEPBLOCKS"
append_flag "--snap.stop" "$ERIGON_SNAP_STOP"
add_option "--db.pagesize" "$ERIGON_DB_PAGESIZE"
add_option "--db.size.limit" "$ERIGON_DB_SIZE_LIMIT"
append_flag "--force.partial.commit" "$ERIGON_FORCE_PARTIAL_COMMIT"
add_option "--torrent.port" "$ERIGON_TORRENT_PORT"
add_option "--torrent.conns.perfile" "$ERIGON_TORRENT_CONNS_PERFILE"
add_option "--torrent.download.slots" "$ERIGON_TORRENT_DOWNLOAD_SLOTS"
add_option "--torrent.staticpeers" "$ERIGON_TORRENT_STATICPEERS"
add_option "--torrent.upload.rate" "$ERIGON_TORRENT_UPLOAD_RATE"
add_option "--torrent.download.rate" "$ERIGON_TORRENT_DOWNLOAD_RATE"
add_option "--torrent.verbosity" "$ERIGON_TORRENT_VERBOSITY"
add_option "--port" "$ERIGON_PORT"
add_option "--p2p.protocol" "$ERIGON_P2P_PROTOCOL"
add_option "--p2p.allowed-ports" "$ERIGON_P2P_ALLOWED_PORTS"
add_option "--nat" "$ERIGON_NAT"
append_flag "--nodiscover" "$ERIGON_NODISCOVER"
append_flag "--v5disc" "$ERIGON_V5DISC"
add_option "--netrestrict" "$ERIGON_NETRESTRICT"
add_option "--nodekey" "$ERIGON_NODEKEY"
add_option "--nodekeyhex" "$ERIGON_NODEKEYHEX"
add_option "--discovery.dns" "$ERIGON_DISCOVERY_DNS"
add_option "--bootnodes" "$ERIGON_BOOTNODES"
add_option "--staticpeers" "$ERIGON_STATICPEERS"
add_option "--trustedpeers" "$ERIGON_TRUSTEDPEERS"
add_option "--maxpeers" "$ERIGON_MAXPEERS"
add_option "--chain" "$ERIGON_CHAIN"
add_option "--dev.period" "$ERIGON_DEV_PERIOD"
append_flag "--vmdebug" "$ERIGON_VMDEBUG"
add_option "--networkid" "$ERIGON_NETWORKID"
append_flag "--fakepow" "$ERIGON_FAKEPOW"
add_option "--gpo.blocks" "$ERIGON_GPO_BLOCKS"
add_option "--gpo.percentile" "$ERIGON_GPO_PERCENTILE"
append_flag "--allow-insecure-unlock" "$ERIGON_ALLOW_INSECURE_UNLOCK"
add_option "--identity" "$ERIGON_IDENTITY"
add_option "--clique.checkpoint" "$ERIGON_CLIQUE_CHECKPOINT"
add_option "--clique.snapshots" "$ERIGON_CLIQUE_SNAPSHOTS"
add_option "--clique.signatures" "$ERIGON_CLIQUE_SIGNATURES"
add_option "--clique.datadir" "$ERIGON_CLIQUE_DATADIR"
append_flag "--mine" "$ERIGON_MINE"
append_flag "--proposer.disable" "$ERIGON_PROPOSER_DISABLE"
add_option "--miner.notify" "$ERIGON_MINER_NOTIFY"
add_option "--miner.gaslimit" "$ERIGON_MINER_GASLIMIT"
add_option "--miner.etherbase" "$ERIGON_MINER_ETHERBASE"
add_option "--miner.extradata" "$ERIGON_MINER_EXTRADATA"
append_flag "--miner.noverify" "$ERIGON_MINER_NOVERIFY"
add_option "--miner.sigfile" "$ERIGON_MINER_SIGFILE"
add_option "--miner.recommit" "$ERIGON_MINER_RECOMMIT"
add_option "--sentry.api.addr" "$ERIGON_SENTRY_API_ADDR"
append_flag "--sentry.log-peer-info" "$ERIGON_SENTRY_LOG_PEER_INFO"
add_option "--downloader.api.addr" "$ERIGON_DOWNLOADER_API_ADDR"
append_flag "--downloader.disable.ipv4" "$ERIGON_DOWNLOADER_DISABLE_IPV4"
append_flag "--downloader.disable.ipv6" "$ERIGON_DOWNLOADER_DISABLE_IPV6"
append_flag "--no-downloader" "$ERIGON_NO_DOWNLOADER"
append_flag "--downloader.verify" "$ERIGON_DOWNLOADER_VERIFY"
append_flag "--healthcheck" "$ERIGON_HEALTHCHECK"
add_option "--bor.heimdall" "$ERIGON_BOR_HEIMDALL"
add_option "--webseed" "$ERIGON_WEBSEED"
append_flag "--bor.withoutheimdall" "$ERIGON_BOR_WITHOUTHEIMDALL"
add_option "--bor.period" "$ERIGON_BOR_PERIOD"
add_option "--bor.minblocksize" "$ERIGON_BOR_MINBLOCKSIZE"
append_flag "--bor.milestone" "$ERIGON_BOR_MILESTONE"
append_flag "--bor.waypoints" "$ERIGON_BOR_WAYPOINTS"
append_flag "--polygon.sync" "$ERIGON_POLYGON_SYNC"
add_option "--ethstats" "$ERIGON_ETHSTATS"
add_option "--override.prague" "$ERIGON_OVERRIDE_PRAGUE"
add_option "--lightclient.discovery.addr" "$ERIGON_LIGHTCLIENT_DISCOVERY_ADDR"
add_option "--lightclient.discovery.port" "$ERIGON_LIGHTCLIENT_DISCOVERY_PORT"
add_option "--lightclient.discovery.tcpport" "$ERIGON_LIGHTCLIENT_DISCOVERY_TCPPORT"
add_option "--sentinel.addr" "$ERIGON_SENTINEL_ADDR"
add_option "--sentinel.port" "$ERIGON_SENTINEL_PORT"
add_option "--ots.search.max.pagesize" "$ERIGON_OTS_SEARCH_MAX_PAGESIZE"
append_flag "--silkworm.exec" "$ERIGON_SILKWORM_EXEC"
append_flag "--silkworm.rpc" "$ERIGON_SILKWORM_RPC"
append_flag "--silkworm.sentry" "$ERIGON_SILKWORM_SENTRY"
add_option "--silkworm.verbosity" "$ERIGON_SILKWORM_VERBOSITY"
add_option "--silkworm.contexts" "$ERIGON_SILKWORM_CONTEXTS"
append_flag "--silkworm.rpc.log" "$ERIGON_SILKWORM_RPC_LOG"
add_option "--silkworm.rpc.log.maxsize" "$ERIGON_SILKWORM_RPC_LOG_MAXSIZE"
add_option "--silkworm.rpc.log.maxfiles" "$ERIGON_SILKWORM_RPC_LOG_MAXFILES"
append_flag "--silkworm.rpc.log.response" "$ERIGON_SILKWORM_RPC_LOG_RESPONSE"
add_option "--silkworm.rpc.workers" "$ERIGON_SILKWORM_RPC_WORKERS"
append_flag "--silkworm.rpc.compatibility" "$ERIGON_SILKWORM_RPC_COMPATIBILITY"
add_option "--beacon.api" "$ERIGON_BEACON_API"
add_option "--beacon.api.addr" "$ERIGON_BEACON_API_ADDR"
add_option "--beacon.api.cors.allow-methods" "$ERIGON_BEACON_API_CORS_ALLOW_METHODS"
add_option "--beacon.api.cors.allow-origins" "$ERIGON_BEACON_API_CORS_ALLOW_ORIGINS"
append_flag "--beacon.api.cors.allow-credentials" "$ERIGON_BEACON_API_CORS_ALLOW_CREDENTIALS"
add_option "--beacon.api.port" "$ERIGON_BEACON_API_PORT"
add_option "--beacon.api.read.timeout" "$ERIGON_BEACON_API_READ_TIMEOUT"
add_option "--beacon.api.write.timeout" "$ERIGON_BEACON_API_WRITE_TIMEOUT"
add_option "--beacon.api.protocol" "$ERIGON_BEACON_API_PROTOCOL"
add_option "--beacon.api.ide.timeout" "$ERIGON_BEACON_API_IDE_TIMEOUT"
append_flag "--caplin.backfilling" "$ERIGON_CAPLIN_BACKFILLING"
append_flag "--caplin.backfilling.blob" "$ERIGON_CAPLIN_BACKFILLING_BLOB"
append_flag "--caplin.backfilling.blob.no-pruning" "$ERIGON_CAPLIN_BACKFILLING_BLOB_NO_PRUNING"
append_flag "--caplin.archive" "$ERIGON_CAPLIN_ARCHIVE"
add_option "--trusted-setup-file" "$ERIGON_TRUSTED_SETUP_FILE"
add_option "--rpc.slow" "$ERIGON_RPC_SLOW"
append_flag "--txpool.gossip.disable" "$ERIGON_TXPOOL_GOSSIP_DISABLE"
add_option "--sync.loop.block.limit" "$ERIGON_SYNC_LOOP_BLOCK_LIMIT"
add_option "--sync.loop.break.after" "$ERIGON_SYNC_LOOP_BREAK_AFTER"
add_option "--sync.loop.prune.limit" "$ERIGON_SYNC_LOOP_PRUNE_LIMIT"
append_flag "--pprof" "$ERIGON_PPROF"
add_option "--pprof.addr" "$ERIGON_PPROF_ADDR"
add_option "--pprof.port" "$ERIGON_PPROF_PORT"
add_option "--pprof.cpuprofile" "$ERIGON_PPROF_CPUPROFILE"
add_option "--trace" "$ERIGON_TRACE"
append_flag "--metrics" "$ERIGON_METRICS"
add_option "--metrics.addr" "$ERIGON_METRICS_ADDR"
add_option "--metrics.port" "$ERIGON_METRICS_PORT"
append_flag "--diagnostics.disabled" "$ERIGON_DIAGNOSTICS_DISABLED"
add_option "--diagnostics.endpoint.addr" "$ERIGON_DIAGNOSTICS_ENDPOINT_ADDR"
add_option "--diagnostics.endpoint.port" "$ERIGON_DIAGNOSTICS_ENDPOINT_PORT"
append_flag "--log.json" "$ERIGON_LOG_JSON"
append_flag "--log.console.json" "$ERIGON_LOG_CONSOLE_JSON"
append_flag "--log.dir.json" "$ERIGON_LOG_DIR_JSON"
add_option "--verbosity" "$ERIGON_VERBOSITY"
add_option "--log.console.verbosity" "$ERIGON_LOG_CONSOLE_VERBOSITY"
append_flag "--log.dir.disable" "$ERIGON_LOG_DIR_DISABLE"
add_option "--log.dir.path" "$ERIGON_LOG_DIR_PATH"
add_option "--log.dir.prefix" "$ERIGON_LOG_DIR_PREFIX"
add_option "--log.dir.verbosity" "$ERIGON_LOG_DIR_VERBOSITY"
append_flag "--log.delays" "$ERIGON_LOG_DELAYS"
add_option "--config" "$ERIGON_CONFIG"

append_flag "--externalcl" "$ERIGON_EXTERNALCL"

if [ -n "$BASECONF_TESTNET_DIR" ]; then
    echo "Importing genesis state"
    erigon init --datadir "$ERIGON_DATA_DIR" "$BASECONF_TESTNET_DIR/genesis.json"
fi

echo "Using Options: erigon $OPTIONS"

exec erigon $OPTIONS
