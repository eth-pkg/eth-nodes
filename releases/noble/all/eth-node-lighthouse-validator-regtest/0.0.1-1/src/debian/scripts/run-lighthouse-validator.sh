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

echo "Starting with configuration from $CONFIG_FILE"

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

# Boolean flags
append_flag "--builder-proposals" "$builder_proposals"
append_flag "--disable-auto-discover" "$disable_auto_discover"
append_flag "--disable-log-timestamp" "$disable_log_timestamp"
append_flag "--disable-malloc-tuning" "$disable_malloc_tuning"
append_flag "--disable-run-on-all" "$disable_run_on_all"
append_flag "--disable-slashing-protection-web3signer" "$disable_slashing_protection_web3signer"
append_flag "--distributed" "$distributed"
append_flag "--enable-doppelganger-protection" "$enable_doppelganger_protection"
append_flag "--enable-high-validator-count-metrics" "$enable_high_validator_count_metrics"
append_flag "--http" "$http"
append_flag "--http-allow-keystore-export" "$http_allow_keystore_export"
append_flag "--http-store-passwords-in-secrets-dir" "$http_store_passwords_in_secrets_dir"
append_flag "--init-slashing-protection" "$init_slashing_protection"
append_flag "--log-color" "$log_color"
append_flag "--logfile-compress" "$logfile_compress"
append_flag "--logfile-no-restricted-perms" "$logfile_no_restricted_perms"
append_flag "--metrics" "$metrics"
append_flag "--prefer-builder-proposals" "$prefer_builder_proposals"
append_flag "--produce-block-v3" "$produce_block_v3"
append_flag "--unencrypted-http-transport" "$unencrypted_http_transport"
append_flag "--use-long-timeouts" "$use_long_timeouts"

# Options
append_option "--beacon-nodes" "$beacon_nodes"
append_option "--beacon-nodes-tls-certs" "$beacon_nodes_tls_certs"
append_option "--broadcast" "$broadcast"
append_option "--builder-boost-factor" "$builder_boost_factor"
append_option "--builder-registration-timestamp-override" "$builder_registration_timestamp_override"
append_option "--datadir" "$datadir"
append_option "--debug-level" "$debug_level"
append_option "--gas-limit" "$gas_limit"
append_option "--genesis-state-url" "$genesis_state_url"
append_option "--genesis-state-url-timeout" "$genesis_state_url_timeout"
append_option "--graffiti" "$graffiti"
append_option "--graffiti-file" "$graffiti_file"
append_option "--http-address" "$http_address"
append_option "--http-allow-origin" "$http_allow_origin"
append_option "--http-port" "$http_port"
append_option "--latency-measurement-service" "$latency_measurement_service"
append_option "--log-format" "$log_format"
append_option "--logfile" "$logfile"
append_option "--logfile-debug-level" "$logfile_debug_level"
append_option "--logfile-format" "$logfile_format"
append_option "--logfile-max-number" "$logfile_max_number"
append_option "--logfile-max-size" "$logfile_max_size"
append_option "--metrics-address" "$metrics_address"
append_option "--metrics-allow-origin" "$metrics_allow_origin"
append_option "--metrics-port" "$metrics_port"
append_option "--monitoring-endpoint" "$monitoring_endpoint"
append_option "--monitoring-endpoint-period" "$monitoring_endpoint_period"
append_option "--network" "$network"
append_option "--proposer-nodes" "$proposer_nodes"
append_option "--safe-slots-to-import-optimistically" "$safe_slots_to_import_optimistically"
append_option "--secrets-dir" "$secrets_dir"
append_option "--suggested-fee-recipient" "$suggested_fee_recipient"
append_option "--terminal-block-hash-epoch-override" "$terminal_block_hash_epoch_override"
append_option "--terminal-block-hash-override" "$terminal_block_hash_override"
append_option "--terminal-total-difficulty-override" "$terminal_total_difficulty_override"
append_option "--testnet-dir" "$testnet_dir"
append_option "--validator-registration-batch-size" "$validator_registration_batch_size"
append_option "--validators-dir" "$validators_dir"
append_option "--web3-signer-keep-alive-timeout" "$web3_signer_keep_alive_timeout"
append_option "--web3-signer-max-idle-connections" "$web3_signer_max_idle_connections"


# if [ -n "$LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR" ]; then
#     echo "Importing keys"
#     password=$(ls $LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR/password | head -n 1)
#     lighthouse account validator import \
#         --testnet-dir "$LIGHTHOUSE_CLI_VALIDATOR_TESTNET_DIR" \
#         --directory "$LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR/keys" \
#         --datadir "$LIGHTHOUSE_CLI_VALIDATOR_DATADIR" \
#         --password-file "$LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR/password/$password" \
#         --reuse-password
#     # remove keys otherwise it will registered twice ???
#     rm -rf $LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR/keys  

# fi

echo "Using Options: $OPTIONS"

exec lighthouse validator_client $OPTIONS