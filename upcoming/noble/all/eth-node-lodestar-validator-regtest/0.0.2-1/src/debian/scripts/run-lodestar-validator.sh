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

append_flag "--keymanager" "$keymanager"
append_flag "--keymanager.auth" "$keymanager_auth_enabled"
append_option "--keymanager.tokenFile" "$keymanager_token_file"
append_option "--keymanager.port" "$keymanager_port"
append_option "--keymanager.address" "$keymanager_address"
append_option "--keymanager.cors" "$keymanager_cors"

append_flag "--builder" "$builder"
append_option "--builder.selection" "$builder_selection"
append_option "--builder.boostFactor" "$builder_boost_factor"

append_option "--http.requestWireFormat" "$http_request_wire_format"
append_option "--http.responseWireFormat" "$http_response_wire_format"

append_option "--externalSigner.url" "$external_signer_url"
append_option "--externalSigner.pubkeys" "$external_signer_pubkeys"
append_flag "--externalSigner.fetch" "$external_signer_fetch"
append_option "--externalSigner.fetchInterval" "$external_signer_fetch_interval"

append_flag "--metrics" "$metrics"
append_option "--metrics.port" "$metrics_port"
append_option "--metrics.address" "$metrics_address"

append_option "--monitoring.endpoint" "$monitoring_endpoint"
append_option "--monitoring.interval" "$monitoring_interval"

append_option "--dataDir" "$data_dir"
append_option "--network" "$network"
append_option "--paramsFile" "$params_file"
append_option "--terminal-total-difficulty-override" "$terminal_total_difficulty_override"
append_option "--terminal-block-hash-override" "$terminal_block_hash_override"
append_option "--terminal-block-hash-epoch-override" "$terminal_block_hash_epoch_override"
append_option "--rcConfig" "$rc_config"
append_option "--logLevel" "$log_level"
append_option "--logFile" "$log_file"
append_option "--logFileLevel" "$log_file_level"
append_option "--logFileDailyRotate" "$log_file_daily_rotate"
append_option "--beaconNodes" "$beacon_nodes"
append_flag "--force" "$force"
append_option "--graffiti" "$graffiti"
append_option "--proposerSettingsFile" "$proposer_settings_file"
append_option "--suggestedFeeRecipient" "$suggested_fee_recipient"
append_flag "--strictFeeRecipientCheck" "$strict_fee_recipient_check"
append_option "--defaultGasLimit" "$default_gas_limit"
append_flag "--useProduceBlockV3" "$use_produce_block_v3"
append_option "--broadcastValidation" "$broadcast_validation"
append_flag "--blindedLocal" "$blinded_local"
append_option "--importKeystores" "$import_keystores"
append_option "--importKeystoresPassword" "$import_keystores_password"
append_flag "--doppelgangerProtection" "$doppelganger_protection_enabled"
append_flag "--distributed" "$distributed"


# Undocumented options
append_option "--keystoresDir" "$keystores_dir"
append_option "--secretsDir" "$secrets_dir"
append_flag "--disableKeystoresThreadPool" "$disable_keystores_thread_pool"

echo "Using Options: $OPTIONS"

exec lodestar validator $OPTIONS