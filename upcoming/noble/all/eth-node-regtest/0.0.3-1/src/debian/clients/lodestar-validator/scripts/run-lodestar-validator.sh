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

append_flag "--keymanager" "$LODESTAR_VALIDATOR_KEYMANAGER"
append_flag "--keymanager.auth" "$LODESTAR_VALIDATOR_KEYMANAGER_AUTH_ENABLED"
append_option "--keymanager.tokenFile" "$LODESTAR_VALIDATOR_KEYMANAGER_TOKEN_FILE"
append_option "--keymanager.port" "$LODESTAR_VALIDATOR_KEYMANAGER_PORT"
append_option "--keymanager.address" "$LODESTAR_VALIDATOR_KEYMANAGER_ADDRESS"
append_option "--keymanager.cors" "$LODESTAR_VALIDATOR_KEYMANAGER_CORS"

append_flag "--builder" "$LODESTAR_VALIDATOR_BUILDER"
append_option "--builder.selection" "$LODESTAR_VALIDATOR_BUILDER_SELECTION"
append_option "--builder.boostFactor" "$LODESTAR_VALIDATOR_BUILDER_BOOST_FACTOR"

append_option "--http.requestWireFormat" "$LODESTAR_VALIDATOR_HTTP_REQUEST_WIRE_FORMAT"
append_option "--http.responseWireFormat" "$LODESTAR_VALIDATOR_HTTP_RESPONSE_WIRE_FORMAT"

append_option "--externalSigner.url" "$LODESTAR_VALIDATOR_EXTERNAL_SIGNER_URL"
append_option "--externalSigner.pubkeys" "$LODESTAR_VALIDATOR_EXTERNAL_SIGNER_PUBKEYS"
append_flag "--externalSigner.fetch" "$LODESTAR_VALIDATOR_EXTERNAL_SIGNER_FETCH"
append_option "--externalSigner.fetchInterval" "$LODESTAR_VALIDATOR_EXTERNAL_SIGNER_FETCH_INTERVAL"

append_flag "--metrics" "$LODESTAR_VALIDATOR_METRICS"
append_option "--metrics.port" "$LODESTAR_VALIDATOR_METRICS_PORT"
append_option "--metrics.address" "$LODESTAR_VALIDATOR_METRICS_ADDRESS"

append_option "--monitoring.endpoint" "$LODESTAR_VALIDATOR_MONITORING_ENDPOINT"
append_option "--monitoring.interval" "$LODESTAR_VALIDATOR_MONITORING_INTERVAL"

append_option "--dataDir" "$LODESTAR_VALIDATOR_DATA_DIR"
append_option "--network" "$LODESTAR_VALIDATOR_NETWORK"
append_option "--paramsFile" "$LODESTAR_VALIDATOR_PARAMS_FILE"
append_option "--terminal-total-difficulty-override" "$LODESTAR_VALIDATOR_TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--terminal-block-hash-override" "$LODESTAR_VALIDATOR_TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-block-hash-epoch-override" "$LODESTAR_VALIDATOR_TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--rcConfig" "$LODESTAR_VALIDATOR_RC_CONFIG"
append_option "--logLevel" "$LODESTAR_VALIDATOR_LOG_LEVEL"
append_option "--logFile" "$LODESTAR_VALIDATOR_LOG_FILE"
append_option "--logFileLevel" "$LODESTAR_VALIDATOR_LOG_FILE_LEVEL"
append_option "--logFileDailyRotate" "$LODESTAR_VALIDATOR_LOG_FILE_DAILY_ROTATE"
append_option "--beaconNodes" "$LODESTAR_VALIDATOR_BEACON_NODES"
append_flag "--force" "$LODESTAR_VALIDATOR_FORCE"
append_option "--graffiti" "$LODESTAR_VALIDATOR_GRAFFITI"
append_option "--proposerSettingsFile" "$LODESTAR_VALIDATOR_PROPOSER_SETTINGS_FILE"
append_option "--suggestedFeeRecipient" "$LODESTAR_VALIDATOR_SUGGESTED_FEE_RECIPIENT"
append_flag "--strictFeeRecipientCheck" "$LODESTAR_VALIDATOR_STRICT_FEE_RECIPIENT_CHECK"
append_option "--defaultGasLimit" "$LODESTAR_VALIDATOR_DEFAULT_GAS_LIMIT"
append_flag "--useProduceBlockV3" "$LODESTAR_VALIDATOR_USE_PRODUCE_BLOCK_V3"
append_option "--broadcastValidation" "$LODESTAR_VALIDATOR_BROADCAST_VALIDATION"
append_flag "--blindedLocal" "$LODESTAR_VALIDATOR_BLINDED_LOCAL"
append_option "--importKeystores" "$LODESTAR_VALIDATOR_IMPORT_KEYSTORES"
append_option "--importKeystoresPassword" "$LODESTAR_VALIDATOR_IMPORT_KEYSTORES_PASSWORD"
append_flag "--doppelgangerProtection" "$LODESTAR_VALIDATOR_DOPPELGANGER_PROTECTION_ENABLED"
append_flag "--distributed" "$LODESTAR_VALIDATOR_DISTRIBUTED"


# Undocumented options
append_option "--keystoresDir" "$LODESTAR_VALIDATOR_KEYSTORES_DIR"
append_option "--secretsDir" "$LODESTAR_VALIDATOR_SECRETS_DIR"
append_flag "--disableKeystoresThreadPool" "$LODESTAR_VALIDATOR_DISABLE_KEYSTORES_THREAD_POOL"

echo "Using Options: $OPTIONS"

