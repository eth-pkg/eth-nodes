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

# weak subjectivity
append_option "--checkpointSyncUrl" "$checkpoint_sync_url"
append_option "--checkpointState" "$checkpoint_state"
append_option "--wssCheckpoint" "$wss_checkpoint"
append_flag "--forceCheckpointSync" "$force_checkpoint_sync"

# api
append_flag "--rest" "$rest"
append_option "--rest.namespace" "$rest_namespace"
append_option "--rest.cors" "$rest_cors"
append_option "--rest.address" "$rest_address"
append_option "--rest.port" "$rest_port"
append_flag "--rest.swaggerUI" "$rest_swagger_ui"

# chain
append_option "--suggestedFeeRecipient" "$suggested_fee_recipient"
append_flag "--emitPayloadAttributes" "$emit_payload_attributes"
append_option "--chain.archiveBlobEpochs" "$chain_archive_blob_epochs"

# eth1
append_flag "--eth1" "$eth1"
append_option "--eth1.providerUrls" "$eth1_provider_urls"

# execution
append_option "--execution.urls" "$execution_urls"
append_option "--execution.timeout" "$execution_timeout"
append_option "--execution.retries" "$execution_retries"
append_option "--execution.retryDelay" "$execution_retry_delay"
append_flag "--execution.engineMock" "$execution_engine_mock"
append_option "--jwtSecret" "$jwt_secret"
append_option "--jwtId" "$jwt_id"

# builder
append_flag "--builder" "$builder"
append_option "--builder.url" "$builder_url"
append_option "--builder.timeout" "$builder_timeout"
append_option "--builder.faultInspectionWindow" "$builder_fault_inspection_window"
append_option "--builder.allowedFaults" "$builder_allowed_faults"

# metrics
append_flag "--metrics" "$metrics"
append_option "--metrics.port" "$metrics_port"
append_option "--metrics.address" "$metrics_address"

# monitoring
append_option "--monitoring.endpoint" "$monitoring_endpoint"
append_option "--monitoring.interval" "$monitoring_interval"

# network
append_flag "--discv5" "$discv5"
append_option "--listenAddress" "$listen_address"
append_option "--port" "$port"
append_option "--discoveryPort" "$discovery_port"
append_option "--listenAddress6" "$listen_address6"
append_option "--port6" "$port6"
append_option "--discoveryPort6" "$discovery_port6"
append_option "--bootnodes" "$bootnodes"
append_option "--targetPeers" "$target_peers"
append_flag "--subscribeAllSubnets" "$subscribe_all_subnets"
append_flag "--disablePeerScoring" "$disable_peer_scoring"
append_flag "--mdns" "$mdns"

# enr
append_option "--enr.ip" "$enr_ip"
append_option "--enr.tcp" "$enr_tcp"
append_option "--enr.udp" "$enr_udp"
append_option "--enr.ip6" "$enr_ip6"
append_option "--enr.tcp6" "$enr_tcp6"
append_option "--enr.udp6" "$enr_udp6"
append_flag "--nat" "$nat"

# options
append_option "--dataDir" "$data_dir"
append_option "--network" "$network"
append_option "--paramsFile" "$params_file"
append_option "--terminal-total-difficulty-override" "$terminal_total_difficulty_override"
append_option "--terminal-block-hash-override" "$terminal_block_hash_override"
append_option "--terminal-block-hash-epoch-override" "$terminal_block_hash_epoch_override"
append_option "--rcConfig" "$rc_config"
append_flag "--private" "$private"
append_flag "--validatorMonitorLogs" "$validator_monitor_logs"
append_flag "--disableLightClientServer" "$disable_light_client_server"
append_option "--logLevel" "$log_level"
append_option "--logFile" "$log_file"
append_option "--logFileLevel" "$log_file_level"
append_option "--logFileDailyRotate" "$log_file_daily_rotate"



# if [ "$LODESTAR_CLI_DEV_REST_NAMESPACE" == "*" ]; then
#     OPTIONS="$OPTIONS --rest.namespace '*'"
# else  
#     append_option "--rest.namespace" "$LODESTAR_CLI_DEV_REST_NAMESPACE"
# fi 

# TODO lodestar undocumented options
append_option "--eth1.depositContractDeployBlock" "$eth1_deposit_contract_deploy_block"
append_option "--network.connectToDiscv5Bootnodes" "$network_connect_to_discv5_bootnodes"
append_option "--genesisStateFile" "$genesis_state_file"


echo "Starting lodestar beacon $OPTIONS"

# on ci the postrm fails, so it not in path
exec /usr/lib/eth-node-lodestar/bin/lodestar beacon $OPTIONS
