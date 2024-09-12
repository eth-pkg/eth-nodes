#!/usr/bin/env bash 

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

append_flag "--builder-proposals" "$LIGHTHOUSE_CLI_VALIDATOR_BUILDER_PROPOSALS"
append_flag "--disable-auto-discover" "$LIGHTHOUSE_CLI_VALIDATOR_DISABLE_AUTO_DISCOVER"
append_flag "--disable-log-timestamp" "$LIGHTHOUSE_CLI_VALIDATOR_DISABLE_LOG_TIMESTAMP"
append_flag "--disable-malloc-tuning" "$LIGHTHOUSE_CLI_VALIDATOR_DISABLE_MALLOC_TUNING"
append_flag "--disable-run-on-all" "$LIGHTHOUSE_CLI_VALIDATOR_DISABLE_RUN_ON_ALL"
append_flag "--disable-slashing-protection-web3signer" "$LIGHTHOUSE_CLI_VALIDATOR_DISABLE_SLASHING_PROTECTION_WEB3SIGNER"
append_flag "--distributed" "$LIGHTHOUSE_CLI_VALIDATOR_DISTRIBUTED"
append_flag "--enable-doppelganger-protection" "$LIGHTHOUSE_CLI_VALIDATOR_ENABLE_DOPPELGANGER_PROTECTION"
append_flag "--enable-high-validator-count-metrics" "$LIGHTHOUSE_CLI_VALIDATOR_ENABLE_HIGH_VALIDATOR_COUNT_METRICS"
append_flag "--http" "$LIGHTHOUSE_CLI_VALIDATOR_HTTP"
append_flag "--http-allow-keystore-export" "$LIGHTHOUSE_CLI_VALIDATOR_HTTP_ALLOW_KEYSTORE_EXPORT"
append_flag "--http-store-passwords-in-secrets-dir" "$LIGHTHOUSE_CLI_VALIDATOR_HTTP_STORE_PASSWORDS_IN_SECRETS_DIR"
append_flag "--init-slashing-protection" "$LIGHTHOUSE_CLI_VALIDATOR_INIT_SLASHING_PROTECTION"
append_flag "--log-color" "$LIGHTHOUSE_CLI_VALIDATOR_LOG_COLOR"
append_flag "--logfile-compress" "$LIGHTHOUSE_CLI_VALIDATOR_LOGFILE_COMPRESS"
append_flag "--logfile-no-restricted-perms" "$LIGHTHOUSE_CLI_VALIDATOR_LOGFILE_NO_RESTRICTED_PERMS"
append_flag "--metrics" "$LIGHTHOUSE_CLI_VALIDATOR_METRICS"
append_flag "--prefer-builder-proposals" "$LIGHTHOUSE_CLI_VALIDATOR_PREFER_BUILDER_PROPOSALS"
append_flag "--produce-block-v3" "$LIGHTHOUSE_CLI_VALIDATOR_PRODUCE_BLOCK_V3"
append_flag "--unencrypted-http-transport" "$LIGHTHOUSE_CLI_VALIDATOR_UNENCRYPTED_HTTP_TRANSPORT"
append_flag "--use-long-timeouts" "$LIGHTHOUSE_CLI_VALIDATOR_USE_LONG_TIMEOUTS"

append_option "--beacon-nodes" "$LIGHTHOUSE_CLI_VALIDATOR_BEACON_NODES"
append_option "--beacon-nodes-tls-certs" "$LIGHTHOUSE_CLI_VALIDATOR_BEACON_NODES_TLS_CERTS"
append_option "--broadcast" "$LIGHTHOUSE_CLI_VALIDATOR_BROADCAST"
append_option "--builder-boost-factor" "$LIGHTHOUSE_CLI_VALIDATOR_BUILDER_BOOST_FACTOR"
append_option "--builder-registration-timestamp-override" "$LIGHTHOUSE_CLI_VALIDATOR_BUILDER_REGISTRATION_TIMESTAMP_OVERRIDE"
append_option "--datadir" "$LIGHTHOUSE_CLI_VALIDATOR_DATADIR"
append_option "--debug-level" "$LIGHTHOUSE_CLI_VALIDATOR_DEBUG_LEVEL"
append_option "--gas-limit" "$LIGHTHOUSE_CLI_VALIDATOR_GAS_LIMIT"
append_option "--genesis-state-url" "$LIGHTHOUSE_CLI_VALIDATOR_GENESIS_STATE_URL"
append_option "--genesis-state-url-timeout" "$LIGHTHOUSE_CLI_VALIDATOR_GENESIS_STATE_URL_TIMEOUT"
append_option "--graffiti" "$LIGHTHOUSE_CLI_VALIDATOR_GRAFFITI"
append_option "--graffiti-file" "$LIGHTHOUSE_CLI_VALIDATOR_GRAFFITI_FILE"
append_option "--http-address" "$LIGHTHOUSE_CLI_VALIDATOR_HTTP_ADDRESS"
append_option "--http-allow-origin" "$LIGHTHOUSE_CLI_VALIDATOR_HTTP_ALLOW_ORIGIN"
append_option "--http-port" "$LIGHTHOUSE_CLI_VALIDATOR_HTTP_PORT"
append_option "--latency-measurement-service" "$LIGHTHOUSE_CLI_VALIDATOR_LATENCY_MEASUREMENT_SERVICE"
append_option "--log-format" "$LIGHTHOUSE_CLI_VALIDATOR_LOG_FORMAT"
append_option "--logfile" "$LIGHTHOUSE_CLI_VALIDATOR_LOGFILE"
append_option "--logfile-debug-level" "$LIGHTHOUSE_CLI_VALIDATOR_LOGFILE_DEBUG_LEVEL"
append_option "--logfile-format" "$LIGHTHOUSE_CLI_VALIDATOR_LOGFILE_FORMAT"
append_option "--logfile-max-number" "$LIGHTHOUSE_CLI_VALIDATOR_LOGFILE_MAX_NUMBER"
append_option "--logfile-max-size" "$LIGHTHOUSE_CLI_VALIDATOR_LOGFILE_MAX_SIZE"
append_option "--metrics-address" "$LIGHTHOUSE_CLI_VALIDATOR_METRICS_ADDRESS"
append_option "--metrics-allow-origin" "$LIGHTHOUSE_CLI_VALIDATOR_METRICS_ALLOW_ORIGIN"
append_option "--metrics-port" "$LIGHTHOUSE_CLI_VALIDATOR_METRICS_PORT"
append_option "--monitoring-endpoint" "$LIGHTHOUSE_CLI_VALIDATOR_MONITORING_ENDPOINT"
append_option "--monitoring-endpoint-period" "$LIGHTHOUSE_CLI_VALIDATOR_MONITORING_ENDPOINT_PERIOD"
append_option "--network" "$LIGHTHOUSE_CLI_VALIDATOR_NETWORK"
append_option "--proposer-nodes" "$LIGHTHOUSE_CLI_VALIDATOR_PROPOSER_NODES"
append_option "--safe-slots-to-import-optimistically" "$LIGHTHOUSE_CLI_VALIDATOR_SAFE_SLOTS_TO_IMPORT_OPTIMISTICALLY"
append_option "--secrets-dir" "$LIGHTHOUSE_CLI_VALIDATOR_SECRETS_DIR"
append_option "--suggested-fee-recipient" "$LIGHTHOUSE_CLI_VALIDATOR_SUGGESTED_FEE_RECIPIENT"
append_option "--terminal-block-hash-epoch-override" "$LIGHTHOUSE_CLI_VALIDATOR_TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--terminal-block-hash-override" "$LIGHTHOUSE_CLI_VALIDATOR_TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-total-difficulty-override" "$LIGHTHOUSE_CLI_VALIDATOR_TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--testnet-dir" "$LIGHTHOUSE_CLI_VALIDATOR_TESTNET_DIR"
append_option "--validator-registration-batch-size" "$LIGHTHOUSE_CLI_VALIDATOR_VALIDATOR_REGISTRATION_BATCH_SIZE"
append_option "--validators-dir" "$LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR"
append_option "--web3-signer-keep-alive-timeout" "$LIGHTHOUSE_CLI_VALIDATOR_WEB3_SIGNER_KEEP_ALIVE_TIMEOUT"
append_option "--web3-signer-max-idle-connections" "$LIGHTHOUSE_CLI_VALIDATOR_WEB3_SIGNER_MAX_IDLE_CONNECTIONS"


echo "Using Options: $OPTIONS"

exec lighthouse validator_client $OPTIONS