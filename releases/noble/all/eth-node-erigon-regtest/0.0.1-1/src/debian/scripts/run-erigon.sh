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
append_flag "--snapshots" "$snapshots"
append_flag "--internalcl" "$internalcl"
append_flag "--txpool.disable" "$txpool_disable"
add_option  "--txpool.locals" "$txpool_locals"
append_flag "--txpool.nolocals" "$txpool_nolocals"
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
append_flag "--tls" "$tls"
add_option  "--tls.cert" "$tls_cert"
add_option  "--tls.key" "$tls_key"
add_option  "--tls.cacert" "$tls_cacert"
append_flag "--state.stream.disable" "$state_stream_disable"
add_option  "--sync.loop.throttle" "$sync_loop_throttle"
add_option  "--bad.block" "$bad_block"
append_flag "--http" "$http"
append_flag "--http.enabled" "$http_enabled"
append_flag "--graphql" "$graphql"
add_option  "--http.addr" "$http_addr"
add_option  "--http.port" "$http_port"
add_option  "--authrpc.addr" "$authrpc_addr"
add_option  "--authrpc.port" "$authrpc_port"
add_option  "--authrpc.jwtsecret" "$authrpc_jwtsecret"
append_flag "--http.compression" "$http_compression"
add_option  "--http.corsdomain" "$http_corsdomain"
add_option  "--http.vhosts" "$http_vhosts"
add_option  "--authrpc.vhosts" "$authrpc_vhosts"
add_option  "--http.api" "$http_api"
add_option  "--ws.port" "$ws_port"
append_flag "--ws" "$ws"
append_flag "--ws.compression" "$ws_compression"
append_flag "--http.trace" "$http_trace"
append_flag "--http.dbg.single" "$http_dbg_single"
add_option  "--state.cache" "$state_cache"
add_option  "--rpc.batch.concurrency" "$rpc_batch_concurrency"
append_flag "--rpc.streaming.disable" "$rpc_streaming_disable"
add_option  "--db.read.concurrency" "$db_read_concurrency"
add_option  "--rpc.accesslist" "$rpc_accesslist"
append_flag "--trace.compat" "$trace_compat"
add_option  "--rpc.gascap" "$rpc_gascap"
add_option  "--rpc.batch.limit" "$rpc_batch_limit"
add_option  "--rpc.returndata.limit" "$rpc_returndata_limit"
append_flag "--rpc.allow-unprotected-txs" "$rpc_allow_unprotected_txs"
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
append_flag "--snap.stop" "$snap_stop"
add_option  "--db.pagesize" "$db_pagesize"
add_option  "--db.size.limit" "$db_size_limit"
append_flag "--force.partial.commit" "$force_partial_commit"
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
append_flag "--nodiscover" "$nodiscover"
append_flag "--v5disc" "$v5disc"
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
append_flag "--vmdebug" "$vmdebug"
add_option  "--networkid" "$networkid"
append_flag "--fakepow" "$fakepow"
add_option  "--gpo.blocks" "$gpo_blocks"
add_option  "--gpo.percentile" "$gpo_percentile"
append_flag "--allow-insecure-unlock" "$allow_insecure_unlock"
add_option  "--identity" "$identity"
add_option  "--clique.checkpoint" "$clique_checkpoint"
add_option  "--clique.snapshots" "$clique_snapshots"
add_option  "--clique.signatures" "$clique_signatures"
add_option  "--clique.datadir" "$clique_datadir"
append_flag "--mine" "$mine"
append_flag "--proposer.disable" "$proposer_disable"
add_option  "--miner.notify" "$miner_notify"
add_option  "--miner.gaslimit" "$miner_gaslimit"
add_option  "--miner.etherbase" "$miner_etherbase"
add_option  "--miner.extradata" "$miner_extradata"
append_flag "--miner.noverify" "$miner_noverify"
add_option  "--miner.sigfile" "$miner_sigfile"
add_option  "--miner.recommit" "$miner_recommit"
add_option  "--sentry.api.addr" "$sentry_api_addr"
append_flag "--sentry.log-peer-info" "$sentry_log_peer_info"
add_option  "--downloader.api.addr" "$downloader_api_addr"
append_flag "--downloader.disable.ipv4" "$downloader_disable_ipv4"
append_flag "--downloader.disable.ipv6" "$downloader_disable_ipv6"
append_flag "--no-downloader" "$no_downloader"
append_flag "--downloader.verify" "$downloader_verify"
append_flag "--healthcheck" "$healthcheck"
add_option  "--bor.heimdall" "$bor_heimdall"
add_option  "--webseed" "$webseed"
append_flag "--bor.withoutheimdall" "$bor_withoutheimdall"
add_option  "--bor.period" "$bor_period"
add_option  "--bor.minblocksize" "$bor_minblocksize"
append_flag "--bor.milestone" "$bor_milestone"
append_flag "--bor.waypoints" "$bor_waypoints"
append_flag "--polygon.sync" "$polygon_sync"
add_option  "--ethstats" "$ethstats"
add_option  "--override.prague" "$override_prague"
add_option  "--lightclient.discovery.addr" "$lightclient_discovery_addr"
add_option  "--lightclient.discovery.port" "$lightclient_discovery_port"
add_option  "--lightclient.discovery.tcpport" "$lightclient_discovery_tcpport"
add_option  "--sentinel.addr" "$sentinel_addr"
add_option  "--sentinel.port" "$sentinel_port"
add_option  "--ots.search.max.pagesize" "$ots_search_max_pagesize"
append_flag "--silkworm.exec" "$silkworm_exec"
append_flag "--silkworm.rpc" "$silkworm_rpc"
append_flag "--silkworm.sentry" "$silkworm_sentry"
add_option  "--silkworm.verbosity" "$silkworm_verbosity"
add_option  "--silkworm.contexts" "$silkworm_contexts"
append_flag "--silkworm.rpc.log" "$silkworm_rpc_log"
add_option  "--silkworm.rpc.log.maxsize" "$silkworm_rpc_log_maxsize"
add_option  "--silkworm.rpc.log.maxfiles" "$silkworm_rpc_log_maxfiles"
append_flag "--silkworm.rpc.log.response" "$silkworm_rpc_log_response"
add_option  "--silkworm.rpc.workers" "$silkworm_rpc_workers"
append_flag "--silkworm.rpc.compatibility" "$silkworm_rpc_compatibility"
add_option  "--beacon.api" "$beacon_api"
add_option  "--beacon.api.addr" "$beacon_api_addr"
add_option  "--beacon.api.cors.allow-methods" "$beacon_api_cors_allow_methods"
add_option  "--beacon.api.cors.allow-origins" "$beacon_api_cors_allow_origins"
append_flag "--beacon.api.cors.allow-credentials" "$beacon_api_cors_allow_credentials"
add_option  "--beacon.api.port" "$beacon_api_port"
add_option  "--beacon.api.read.timeout" "$beacon_api_read_timeout"
add_option  "--beacon.api.write.timeout" "$beacon_api_write_timeout"
add_option  "--beacon.api.protocol" "$beacon_api_protocol"
add_option  "--beacon.api.ide.timeout" "$beacon_api_ide_timeout"
append_flag "--caplin.backfilling" "$caplin_backfilling"
append_flag "--caplin.backfilling.blob" "$caplin_backfilling_blob"
append_flag "--caplin.backfilling.blob.no-pruning" "$caplin_backfilling_blob_no_pruning"
append_flag "--caplin.archive" "$caplin_archive"
add_option  "--trusted-setup-file" "$trusted_setup_file"
add_option  "--rpc.slow" "$rpc_slow"
append_flag "--txpool.gossip.disable" "$txpool_gossip_disable"
add_option  "--sync.loop.block.limit" "$sync_loop_block_limit"
add_option  "--sync.loop.break.after" "$sync_loop_break_after"
add_option  "--sync.loop.prune.limit" "$sync_loop_prune_limit"
append_flag "--pprof" "$pprof"
add_option  "--pprof.addr" "$pprof_addr"
add_option  "--pprof.port" "$pprof_port"
add_option  "--pprof.cpuprofile" "$pprof_cpuprofile"
add_option  "--trace" "$trace"
append_flag "--metrics" "$metrics"
add_option  "--metrics.addr" "$metrics_addr"
add_option  "--metrics.port" "$metrics_port"
append_flag "--diagnostics.disabled" "$diagnostics_disabled"
add_option  "--diagnostics.endpoint.addr" "$diagnostics_endpoint_addr"
add_option  "--diagnostics.endpoint.port" "$diagnostics_endpoint_port"
append_flag "--log.json" "$log_json"
append_flag "--log.console.json" "$log_console_json"
append_flag "--log.dir.json" "$log_dir_json"
add_option  "--verbosity" "$verbosity"
add_option  "--log.console.verbosity" "$log_console_verbosity"
append_flag "--log.dir.disable" "$log_dir_disable"
add_option  "--log.dir.path" "$log_dir_path"
add_option  "--log.dir.prefix" "$log_dir_prefix"
add_option  "--log.dir.verbosity" "$log_dir_verbosity"
append_flag "--log.delays" "$log_delays"
add_option  "--config" "$config"


if [ -n "$TESTNET_DIR" ]; then
    echo "Importing genesis state"
    erigon init --datadir "$datadir" "$TESTNET_DIR/genesis.json"
fi

echo "Using Options: erigon $OPTIONS"

exec erigon $OPTIONS