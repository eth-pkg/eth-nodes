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

append_flag(){
 local option=$1
  local value=$2
  if [ "$value" = "true" ]; then
    OPTIONS="$OPTIONS $option"
  fi 
}

add_option  "--datadir" "$datadir"
add_option  "--ethash.dagdir" "$ethash_dagdir"
append_flag "--snapshots" "$ERIGON_SNAPSHOTS"
append_flag "--internalcl" "$ERIGON_INTERNALCL"
append_flag "--txpool.disable" "$ERIGON_TXPOOL_DISABLE"
add_option  "--txpool.locals" "$txpool_locals"
append_flag "--txpool.nolocals" "$ERIGON_TXPOOL_NOLOCALS"
add_option  "--txpool.pricelimit" "$txpool_pricelimit"
add_option  "--txpool.pricebump" "$txpool_pricebump"
add_option  "--txpool.blobpricebump" "$txpool_blobpricebump"
add_option  "--txpool.accountslots" "$txpool_accountslots"
add_option  "--txpool.blobslots" "$txpool_blobslots"
add_option  "--txpool.totalblobpoollimit" "$txpool_totalblobpoollimit"
add_option  "--txpool.globalslots" "$txpool_globalslots"
add_option  "--txpool.globalbasefeeslots" "$txpool_globalbasefeeslots"
add_option  "--txpool.accountqueue" "$txpool_accountqueue"
add_option  "--txpool.globalqueue" "$txpool_globalqueue"
add_option  "--txpool.lifetime" "$txpool_lifetime"
add_option  "--txpool.trace.senders" "$txpool_trace_senders"
add_option  "--txpool.commit.every" "$txpool_commit_every"
add_option  "--prune" "$prune"
add_option  "--prune.h.older" "$prune_h_older"
add_option  "--prune.r.older" "$prune_r_older"
add_option  "--prune.t.older" "$prune_t_older"
add_option  "--prune.c.older" "$prune_c_older"
add_option  "--prune.h.before" "$prune_h_before"
add_option  "--prune.r.before" "$prune_r_before"
add_option  "--prune.t.before" "$prune_t_before"
add_option  "--prune.c.before" "$prune_c_before"
add_option  "--batchsize" "$batchsize"
add_option  "--bodies.cache" "$bodies_cache"
add_option  "--database.verbosity" "$database_verbosity"
add_option  "--private.api.addr" "$private_api_addr"
add_option  "--private.api.ratelimit" "$private_api_ratelimit"
add_option  "--etl.buffersize" "$etl_buffersize"
append_flag "--tls" "$ERIGON_TLS"
add_option  "--tls.cert" "$tls_cert"
add_option  "--tls.key" "$tls_key"
add_option  "--tls.cacert" "$tls_cacert"
append_flag "--state.stream.disable" "$ERIGON_STATE_STREAM_DISABLE"
add_option  "--sync.loop.throttle" "$sync_loop_throttle"
add_option  "--bad.block" "$bad_block"
append_flag "--http" "$ERIGON_HTTP"
append_flag "--http.enabled" "$ERIGON_HTTP_ENABLED"
append_flag "--graphql" "$ERIGON_GRAPHQL"
add_option  "--http.addr" "$http_addr"
add_option  "--http.port" "$http_port"
add_option  "--authrpc.addr" "$authrpc_addr"
add_option  "--authrpc.port" "$authrpc_port"
add_option  "--authrpc.jwtsecret" "$authrpc_jwtsecret"
append_flag "--http.compression" "$ERIGON_HTTP_COMPRESSION"
add_option  "--http.corsdomain" "$http_corsdomain"
add_option  "--http.vhosts" "$http_vhosts"
add_option  "--authrpc.vhosts" "$authrpc_vhosts"
add_option  "--http.api" "$http_api"
add_option  "--ws.port" "$ws_port"
append_flag "--ws" "$ERIGON_WS"
append_flag "--ws.compression" "$ERIGON_WS_COMPRESSION"
append_flag "--http.trace" "$ERIGON_HTTP_TRACE"
append_flag "--http.dbg.single" "$ERIGON_HTTP_DBG_SINGLE"
add_option  "--state.cache" "$state_cache"
add_option  "--rpc.batch.concurrency" "$rpc_batch_concurrency"
append_flag "--rpc.streaming.disable" "$ERIGON_RPC_STREAMING_DISABLE"
add_option  "--db.read.concurrency" "$db_read_concurrency"
add_option  "--rpc.accesslist" "$rpc_accesslist"
append_flag "--trace.compat" "$ERIGON_TRACE_COMPAT"
add_option  "--rpc.gascap" "$rpc_gascap"
add_option  "--rpc.batch.limit" "$rpc_batch_limit"
add_option  "--rpc.returndata.limit" "$rpc_returndata_limit"
append_flag "--rpc.allow-unprotected-txs" "$ERIGON_RPC_ALLOW_UNPROTECTED_TXS"
add_option  "--rpc.maxgetproofrewindblockcount.limit" "$rpc_maxgetproofrewindblockcount_limit"
add_option  "--rpc.txfeecap" "$rpc_txfeecap"
add_option  "--txpool.api.addr" "$txpool_api_addr"
add_option  "--trace.maxtraces" "$trace_maxtraces"
add_option  "--http.timeouts.read" "$http_timeouts_read"
add_option  "--http.timeouts.write" "$http_timeouts_write"
add_option  "--http.timeouts.idle" "$http_timeouts_idle"
add_option  "--authrpc.timeouts.read" "$authrpc_timeouts_read"
add_option  "--authrpc.timeouts.write" "$authrpc_timeouts_write"
add_option  "--authrpc.timeouts.idle" "$authrpc_timeouts_idle"
add_option  "--rpc.evmtimeout" "$rpc_evmtimeout"
add_option  "--rpc.overlay.getlogstimeout" "$rpc_overlay_getlogstimeout"
add_option  "--rpc.overlay.replayblocktimeout" "$rpc_overlay_replayblocktimeout"
add_option  "--snap.keepblocks" "$snap_keepblocks"
append_flag "--snap.stop" "$ERIGON_SNAP_STOP"
add_option  "--db.pagesize" "$db_pagesize"
add_option  "--db.size.limit" "$db_size_limit"
append_flag "--force.partial.commit" "$ERIGON_FORCE_PARTIAL_COMMIT"
add_option  "--torrent.port" "$torrent_port"
add_option  "--torrent.conns.perfile" "$torrent_conns_perfile"
add_option  "--torrent.download.slots" "$torrent_download_slots"
add_option  "--torrent.staticpeers" "$torrent_staticpeers"
add_option  "--torrent.upload.rate" "$torrent_upload_rate"
add_option  "--torrent.download.rate" "$torrent_download_rate"
add_option  "--torrent.verbosity" "$torrent_verbosity"
add_option  "--port" "$port"
add_option  "--p2p.protocol" "$p2p_protocol"
add_option  "--p2p.allowed-ports" "$p2p_allowed_ports"
add_option  "--nat" "$nat"
append_flag "--nodiscover" "$ERIGON_NODISCOVER"
append_flag "--v5disc" "$ERIGON_V5DISC"
add_option  "--netrestrict" "$netrestrict"
add_option  "--nodekey" "$nodekey"
add_option  "--nodekeyhex" "$nodekeyhex"
add_option  "--discovery.dns" "$discovery_dns"
add_option  "--bootnodes" "$bootnodes"
add_option  "--staticpeers" "$staticpeers"
add_option  "--trustedpeers" "$trustedpeers"
add_option  "--maxpeers" "$maxpeers"
add_option  "--chain" "$chain"
add_option  "--dev.period" "$dev_period"
append_flag "--vmdebug" "$ERIGON_VMDEBUG"
add_option  "--networkid" "$networkid"
append_flag "--fakepow" "$ERIGON_FAKEPOW"
add_option  "--gpo.blocks" "$gpo_blocks"
add_option  "--gpo.percentile" "$gpo_percentile"
append_flag "--allow-insecure-unlock" "$ERIGON_ALLOW_INSECURE_UNLOCK"
add_option  "--identity" "$identity"
add_option  "--clique.checkpoint" "$clique_checkpoint"
add_option  "--clique.snapshots" "$clique_snapshots"
add_option  "--clique.signatures" "$clique_signatures"
add_option  "--clique.datadir" "$clique_datadir"
append_flag "--mine" "$ERIGON_MINE"
append_flag "--proposer.disable" "$ERIGON_PROPOSER_DISABLE"
add_option  "--miner.notify" "$miner_notify"
add_option  "--miner.gaslimit" "$miner_gaslimit"
add_option  "--miner.etherbase" "$miner_etherbase"
add_option  "--miner.extradata" "$miner_extradata"
append_flag "--miner.noverify" "$ERIGON_MINER_NOVERIFY"
add_option  "--miner.sigfile" "$miner_sigfile"
add_option  "--miner.recommit" "$miner_recommit"
add_option  "--sentry.api.addr" "$sentry_api_addr"
append_flag "--sentry.log-peer-info" "$ERIGON_SENTRY_LOG_PEER_INFO"
add_option  "--downloader.api.addr" "$downloader_api_addr"
append_flag "--downloader.disable.ipv4" "$ERIGON_DOWNLOADER_DISABLE_IPV4"
append_flag "--downloader.disable.ipv6" "$ERIGON_DOWNLOADER_DISABLE_IPV6"
append_flag "--no-downloader" "$ERIGON_NO_DOWNLOADER"
append_flag "--downloader.verify" "$ERIGON_DOWNLOADER_VERIFY"
append_flag "--healthcheck" "$ERIGON_HEALTHCHECK"
add_option  "--bor.heimdall" "$bor_heimdall"
add_option  "--webseed" "$webseed"
append_flag "--bor.withoutheimdall" "$ERIGON_BOR_WITHOUTHEIMDALL"
add_option  "--bor.period" "$bor_period"
add_option  "--bor.minblocksize" "$bor_minblocksize"
append_flag "--bor.milestone" "$ERIGON_BOR_MILESTONE"
append_flag "--bor.waypoints" "$ERIGON_BOR_WAYPOINTS"
append_flag "--polygon.sync" "$ERIGON_POLYGON_SYNC"
add_option  "--ethstats" "$ethstats"
add_option  "--override.prague" "$override_prague"
add_option  "--lightclient.discovery.addr" "$lightclient_discovery_addr"
add_option  "--lightclient.discovery.port" "$lightclient_discovery_port"
add_option  "--lightclient.discovery.tcpport" "$lightclient_discovery_tcpport"
add_option  "--sentinel.addr" "$sentinel_addr"
add_option  "--sentinel.port" "$sentinel_port"
add_option  "--ots.search.max.pagesize" "$ots_search_max_pagesize"
append_flag "--silkworm.exec" "$ERIGON_SILKWORM_EXEC"
append_flag "--silkworm.rpc" "$ERIGON_SILKWORM_RPC"
append_flag "--silkworm.sentry" "$ERIGON_SILKWORM_SENTRY"
add_option  "--silkworm.verbosity" "$silkworm_verbosity"
add_option  "--silkworm.contexts" "$silkworm_contexts"
append_flag "--silkworm.rpc.log" "$ERIGON_SILKWORM_RPC_LOG"
add_option  "--silkworm.rpc.log.maxsize" "$silkworm_rpc_log_maxsize"
add_option  "--silkworm.rpc.log.maxfiles" "$silkworm_rpc_log_maxfiles"
append_flag "--silkworm.rpc.log.response" "$ERIGON_SILKWORM_RPC_LOG_RESPONSE"
add_option  "--silkworm.rpc.workers" "$silkworm_rpc_workers"
append_flag "--silkworm.rpc.compatibility" "$ERIGON_SILKWORM_RPC_COMPATIBILITY"
add_option  "--beacon.api" "$beacon_api"
add_option  "--beacon.api.addr" "$beacon_api_addr"
add_option  "--beacon.api.cors.allow-methods" "$beacon_api_cors_allow_methods"
add_option  "--beacon.api.cors.allow-origins" "$beacon_api_cors_allow_origins"
append_flag "--beacon.api.cors.allow-credentials" "$ERIGON_BEACON_API_CORS_ALLOW_CREDENTIALS"
add_option  "--beacon.api.port" "$beacon_api_port"
add_option  "--beacon.api.read.timeout" "$beacon_api_read_timeout"
add_option  "--beacon.api.write.timeout" "$beacon_api_write_timeout"
add_option  "--beacon.api.protocol" "$beacon_api_protocol"
add_option  "--beacon.api.ide.timeout" "$beacon_api_ide_timeout"
append_flag "--caplin.backfilling" "$ERIGON_CAPLIN_BACKFILLING"
append_flag "--caplin.backfilling.blob" "$ERIGON_CAPLIN_BACKFILLING_BLOB"
append_flag "--caplin.backfilling.blob.no-pruning" "$ERIGON_CAPLIN_BACKFILLING_BLOB_NO_PRUNING"
append_flag "--caplin.archive" "$ERIGON_CAPLIN_ARCHIVE"
add_option  "--trusted-setup-file" "$trusted_setup_file"
add_option  "--rpc.slow" "$rpc_slow"
append_flag "--txpool.gossip.disable" "$ERIGON_TXPOOL_GOSSIP_DISABLE"
add_option  "--sync.loop.block.limit" "$sync_loop_block_limit"
add_option  "--sync.loop.break.after" "$sync_loop_break_after"
add_option  "--sync.loop.prune.limit" "$sync_loop_prune_limit"
append_flag "--pprof" "$ERIGON_PPROF"
add_option  "--pprof.addr" "$pprof_addr"
add_option  "--pprof.port" "$pprof_port"
add_option  "--pprof.cpuprofile" "$pprof_cpuprofile"
add_option  "--trace" "$trace"
append_flag "--metrics" "$ERIGON_METRICS"
add_option  "--metrics.addr" "$metrics_addr"
add_option  "--metrics.port" "$metrics_port"
append_flag "--diagnostics.disabled" "$ERIGON_DIAGNOSTICS_DISABLED"
add_option  "--diagnostics.endpoint.addr" "$diagnostics_endpoint_addr"
add_option  "--diagnostics.endpoint.port" "$diagnostics_endpoint_port"
append_flag "--log.json" "$ERIGON_LOG_JSON"
append_flag "--log.console.json" "$ERIGON_LOG_CONSOLE_JSON"
append_flag "--log.dir.json" "$ERIGON_LOG_DIR_JSON"
add_option  "--verbosity" "$verbosity"
add_option  "--log.console.verbosity" "$log_console_verbosity"
append_flag "--log.dir.disable" "$ERIGON_LOG_DIR_DISABLE"
add_option  "--log.dir.path" "$log_dir_path"
add_option  "--log.dir.prefix" "$log_dir_prefix"
add_option  "--log.dir.verbosity" "$log_dir_verbosity"
append_flag "--log.delays" "$ERIGON_LOG_DELAYS"
add_option  "--config" "$config"


if [ -n "$TESTNET_DIR" ]; then
    echo "Importing genesis state"
    erigon init --datadir "$datadir" "$TESTNET_DIR/genesis.json"
fi

echo "Using Options: erigon $OPTIONS"

