set -e 

display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --env-file FILE, -e FILE   Path to .conf formatted configuration file."    
    echo "  --help, -h                    Displays this help text and exits."
    echo "  --version, -v                 Displays the version and exits."
    exit 0
}

display_version() {
    local version=$(basename "$(dirname "$(realpath "$0")")")
    echo "$0 version $version"
    exit 0
}

CONFIG_FILE=""
HELP=false
VERSION=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --env-file|-e)
            CONFIG_FILE="$2"
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

if [ -z "$CONFIG_FILE" ]; then
    echo "Error: Configuration file is required. Use --config-file option."
    display_help
fi

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

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

append_flag "--keymanager" "$LODESTAR_CLI_VALIDATOR_KEYMANAGER"
append_flag "--keymanager.auth" "$LODESTAR_CLI_VALIDATOR_KEYMANAGER_AUTH_ENABLED"
append_option "--keymanager.tokenFile" "$LODESTAR_CLI_VALIDATOR_KEYMANAGER_TOKENFILE"
append_option "--keymanager.port" "$LODESTAR_CLI_VALIDATOR_KEYMANAGER_PORT"
append_option "--keymanager.address" "$LODESTAR_CLI_VALIDATOR_KEYMANAGER_ADDRESS"
append_option "--keymanager.cors" "$LODESTAR_CLI_VALIDATOR_KEYMANAGER_CORS"

append_flag "--builder" "$LODESTAR_CLI_VALIDATOR_BUILDER"
append_option "--builder.selection" "$LODESTAR_CLI_VALIDATOR_BUILDER_SELECTION"
append_option "--builder.boostFactor" "$LODESTAR_CLI_VALIDATOR_BUILDER_BOOSTFACTOR"

append_option "--externalSigner.url" "$LODESTAR_CLI_VALIDATOR_EXTERNALSIGNER_URL"
append_option "--externalSigner.pubkeys" "$LODESTAR_CLI_VALIDATOR_EXTERNALSIGNER_PUBKEYS"
append_flag "--externalSigner.fetch" "$LODESTAR_CLI_VALIDATOR_EXTERNALSIGNER_FETCH"
append_option "--externalSigner.fetchInterval" "$LODESTAR_CLI_VALIDATOR_EXTERNALSIGNER_FETCHINTERVAL"

append_flag "--metrics" "$LODESTAR_CLI_VALIDATOR_METRICS"
append_option "--metrics.port" "$LODESTAR_CLI_VALIDATOR_METRICS_PORT"
append_option "--metrics.address" "$LODESTAR_CLI_VALIDATOR_METRICS_ADDRESS"

append_option "--monitoring.endpoint" "$LODESTAR_CLI_VALIDATOR_MONITORING_ENDPOINT"
append_option "--monitoring.interval" "$LODESTAR_CLI_VALIDATOR_MONITORING_INTERVAL"

append_option "--dataDir" "$LODESTAR_CLI_VALIDATOR_DATADIR"
append_option "--network" "$LODESTAR_CLI_VALIDATOR_NETWORK"
append_option "--paramsFile" "$LODESTAR_CLI_VALIDATOR_PARAMSFILE"
append_option "--terminal-total-difficulty-override" "$LODESTAR_CLI_VALIDATOR_TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--terminal-block-hash-override" "$LODESTAR_CLI_VALIDATOR_TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-block-hash-epoch-override" "$LODESTAR_CLI_VALIDATOR_TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--rcConfig" "$LODESTAR_CLI_VALIDATOR_RCCONFIG"
append_option "--logLevel" "$LODESTAR_CLI_VALIDATOR_LOGLEVEL"
append_option "--logFile" "$LODESTAR_CLI_VALIDATOR_LOGFILE"
append_option "--logFileLevel" "$LODESTAR_CLI_VALIDATOR_LOGFILELEVEL"
append_option "--logFileDailyRotate" "$LODESTAR_CLI_VALIDATOR_LOGFILEDAILYROTATE"
append_option "--beaconNodes" "$LODESTAR_CLI_VALIDATOR_BEACONNODES"
append_flag "--force" "$LODESTAR_CLI_VALIDATOR_FORCE"
append_option "--graffiti" "$LODESTAR_CLI_VALIDATOR_GRAFFITI"
append_option "--proposerSettingsFile" "$LODESTAR_CLI_VALIDATOR_PROPOSERSETTINGSFILE"
append_option "--suggestedFeeRecipient" "$LODESTAR_CLI_VALIDATOR_SUGGESTEDFEERECIPIENT"
append_flag "--strictFeeRecipientCheck" "$LODESTAR_CLI_VALIDATOR_STRICTFEERECIPIENTCHECK"
append_option "--defaultGasLimit" "$LODESTAR_CLI_VALIDATOR_DEFAULTGASLIMIT"
append_flag "--useProduceBlockV3" "$LODESTAR_CLI_VALIDATOR_USEPRODUCEBLOCKV3"
append_option "--broadcastValidation" "$LODESTAR_CLI_VALIDATOR_BROADCASTVALIDATION"
append_flag "--blindedLocal" "$LODESTAR_CLI_VALIDATOR_BLINDEDLOCAL"
append_option "--importKeystores" "$LODESTAR_CLI_VALIDATOR_IMPORTKEYSTORES"
append_option "--importKeystoresPassword" "$LODESTAR_CLI_VALIDATOR_IMPORTKEYSTORESPASSWORD"
append_flag "--doppelgangerProtection" "$LODESTAR_CLI_VALIDATOR_DOPPELGANGERPROTECTIONENABLED"
append_flag "--distributed" "$LODESTAR_CLI_VALIDATOR_DISTRIBUTED"

echo "Using Options: $OPTIONS"

exec docker run chainsafe/lodestar validator $OPTIONS