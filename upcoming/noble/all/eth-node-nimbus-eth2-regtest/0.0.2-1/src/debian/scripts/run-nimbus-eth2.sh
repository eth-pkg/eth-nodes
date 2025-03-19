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






add_option "--config-file" "$config_file"
add_option "--log-level" "$log_level"
# add_option "--log-file" "$log_file"
add_option "--network" "$network"
add_option "--data-dir" "$data_dir"
add_option "--validators-dir" "$validators_dir"
add_option "--verifying-web3-signer-url" "$verifying_web3_signer_url"
add_option "--proven-block-property" "$proven_block_property"
add_option "--web3-signer-url" "$web3_signer_url"
add_option "--web3-signer-update-interval" "$web3_signer_update_interval"
add_option "--secrets-dir" "$secrets_dir"
add_option "--wallets-dir" "$wallets_dir"
add_option "--web3-url" "$web3_url"
add_option "--el" "$el"
add_option "--no-el" "$no_el"
add_option "--non-interactive" "$non_interactive"
add_option "--netkey-file" "$netkey_file"
add_option "--insecure-netkey-password" "$insecure_netkey_password"
add_option "--agent-string" "$agent_string"
add_option "--subscribe-all-subnets" "$subscribe_all_subnets"
add_option "--num-threads" "$num_threads"
add_option "--jwt-secret" "$jwt_secret"
add_option "--bootstrap-node" "$bootstrap_node"
add_option "--bootstrap-file" "$bootstrap_file"
add_option "--listen-address" "$listen_address"

add_option "--tcp-port" "$tcp_port"
add_option "--udp-port" "$udp_port"
add_option "--max-peers" "$max_peers"
add_option "--hard-max-peers" "$hard_max_peers"
add_option "--nat" "$nat"
add_option "--enr-auto-update" "$enr_auto_update"
add_option "--weak-subjectivity-checkpoint" "$weak_subjectivity_checkpoint"
add_option "--external-beacon-api-url" "$external_beacon_api_url"
add_option "--sync-light-client" "$sync_light_client"
add_option "--trusted-block-root" "$trusted_block_root"
add_option "--trusted-state-root" "$trusted_state_root"
add_option "--finalized-checkpoint-state" "$finalized_checkpoint_state"
add_option "--genesis-state" "$genesis_state"
add_option "--genesis-state-url" "$genesis_state_url"
add_option "--finalized-deposit-tree-snapshot" "$finalized_deposit_tree_snapshot"
add_option "--node-name" "$node_name"
add_option "--graffiti" "$graffiti"
add_option "--metrics" "$metrics"
add_option "--metrics-address" "$metrics_address"
add_option "--metrics-port" "$metrics_port"
add_option "--status-bar" "$status_bar"
add_option "--status-bar-contents" "$status_bar_contents"
add_option "--rest" "$rest"

add_option "--rest-port" "$rest_port"
add_option "--rest-address" "$rest_address"
add_option "--rest-allow-origin" "$rest_allow_origin"
add_option "--rest-statecache-size" "$rest_statecache_size"
add_option "--rest-statecache-ttl" "$rest_statecache_ttl"
add_option "--rest-request-timeout" "$rest_request_timeout"
add_option "--rest-max-body-size" "$rest_max_body_size"
add_option "--rest-max-headers-size" "$rest_max_headers_size"
add_option "--keymanager" "$keymanager"
add_option "--keymanager-port" "$keymanager_port"
add_option "--keymanager-address" "$keymanager_address"
add_option "--keymanager-allow-origin" "$keymanager_allow_origin"
add_option "--keymanager-token-file" "$keymanager_token_file"
add_option "--light-client-data-serve" "$light_client_data_serve"
add_option "--light-client-data-import-mode" "$light_client_data_import_mode"
add_option "--light-client-data-max-periods" "$light_client_data_max_periods"
add_option "--in-process-validators" "$in_process_validators"
add_option "--discv5" "$discv5"
add_option "--dump" "$dump"
add_option "--direct-peer" "$direct_peer"
add_option "--doppelganger-detection" "$doppelganger_detection"
add_option "--validator-monitor-auto" "$validator_monitor_auto"
add_option "--validator-monitor-pubkey" "$validator_monitor_pubkey"
add_option "--validator-monitor-details" "$validator_monitor_details"
add_option "--suggested-fee-recipient" "$suggested_fee_recipient"
add_option "--suggested-gas-limit" "$suggested_gas_limit"
add_option "--payload-builder" "$payload_builder"
add_option "--payload-builder-url" "$payload_builder_url"
add_option "--local-block-value-boost" "$local_block_value_boost"
add_option "--history" "$history"


echo "Using Options: nimbus_beacon_node $OPTIONS"

# hack to download state before starting client
if [ -n "$finalized_checkpoint_state" ]; then
    echo "Downloading checkpoint state for nimbus-eth2"
    echo "curl -o $finalized_checkpoint_state \
            -H 'Accept: application/octet-stream' \
            $CL_CHECKPPOINT_SYNC_URL/eth/v2/debug/beacon/states/finalized"
    if [ "$finalized_checkpoint_state" != "" ]; then
        curl -o $finalized_checkpoint_state \
            -H 'Accept: application/octet-stream' \
            $CL_CHECKPPOINT_SYNC_URL/eth/v2/debug/beacon/states/finalized

    fi
fi

# on ci the postrm fails, so it not in path
exec /usr/lib/eth-node-nimbus-eth2/bin/nimbus_beacon_node $OPTIONS > $log_file
