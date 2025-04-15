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

echo "Starting with configuration from $CONFIG_FILE"

OPTIONS=""

append_option() {
    local option=$1
    local value=$2
    if [ -n "$value" ]; then
        OPTIONS="$OPTIONS $option=$value"
    fi
}

append_flag() {
    local option=$1
    local value=$2
    if [ "$value" = "true" ]; then
        OPTIONS="$OPTIONS $option"
    fi
}

# Boolean flags
append_flag "--builder-proposals" "$BUILDER_PROPOSALS"
append_flag "--disable-auto-discover" "$DISABLE_AUTO_DISCOVER"
append_flag "--disable-log-timestamp" "$DISABLE_LOG_TIMESTAMP"
append_flag "--disable-malloc-tuning" "$DISABLE_MALLOC_TUNING"
append_flag "--disable-run-on-all" "$DISABLE_RUN_ON_ALL"
append_flag "--disable-slashing-protection-web3signer" "$DISABLE_SLASHING_PROTECTION_WEB3SIGNER"
append_flag "--distributed" "$DISTRIBUTED"
append_flag "--enable-doppelganger-protection" "$ENABLE_DOPPELGANGER_PROTECTION"
append_flag "--enable-high-validator-count-metrics" "$ENABLE_HIGH_VALIDATOR_COUNT_METRICS"
append_flag "--http" "$HTTP"
append_flag "--http-allow-keystore-export" "$HTTP_ALLOW_KEYSTORE_EXPORT"
append_flag "--http-store-passwords-in-secrets-dir" "$HTTP_STORE_PASSWORDS_IN_SECRETS_DIR"
append_flag "--init-slashing-protection" "$INIT_SLASHING_PROTECTION"
append_flag "--log-color" "$LOG_COLOR"
append_flag "--logfile-compress" "$LOGFILE_COMPRESS"
append_flag "--logfile-no-restricted-perms" "$LOGFILE_NO_RESTRICTED_PERMS"
append_flag "--metrics" "$METRICS"
append_flag "--prefer-builder-proposals" "$PREFER_BUILDER_PROPOSALS"
append_flag "--produce-block-v3" "$PRODUCE_BLOCK_V3"
append_flag "--unencrypted-http-transport" "$UNENCRYPTED_HTTP_TRANSPORT"
append_flag "--use-long-timeouts" "$USE_LONG_TIMEOUTS"
# Options
append_option "--beacon-nodes" "$BEACON_NODES"
append_option "--beacon-nodes-tls-certs" "$BEACON_NODES_TLS_CERTS"
append_option "--broadcast" "$BROADCAST"
append_option "--builder-boost-factor" "$BUILDER_BOOST_FACTOR"
append_option "--builder-registration-timestamp-override" "$BUILDER_REGISTRATION_TIMESTAMP_OVERRIDE"
append_option "--datadir" "$DATADIR"
append_option "--debug-level" "$DEBUG_LEVEL"
append_option "--gas-limit" "$GAS_LIMIT"
append_option "--genesis-state-url" "$GENESIS_STATE_URL"
append_option "--genesis-state-url-timeout" "$GENESIS_STATE_URL_TIMEOUT"
append_option "--graffiti" "$GRAFFITI"
append_option "--graffiti-file" "$GRAFFITI_FILE"
append_option "--http-address" "$HTTP_ADDRESS"
append_option "--http-allow-origin" "$HTTP_ALLOW_ORIGIN"
append_option "--http-port" "$HTTP_PORT"
append_option "--latency-measurement-service" "$LATENCY_MEASUREMENT_SERVICE"
append_option "--log-format" "$LOG_FORMAT"
append_option "--logfile" "$LOGFILE"
append_option "--logfile-debug-level" "$LOGFILE_DEBUG_LEVEL"
append_option "--logfile-format" "$LOGFILE_FORMAT"
append_option "--logfile-max-number" "$LOGFILE_MAX_NUMBER"
append_option "--logfile-max-size" "$LOGFILE_MAX_SIZE"
append_option "--metrics-address" "$METRICS_ADDRESS"
append_option "--metrics-allow-origin" "$METRICS_ALLOW_ORIGIN"
append_option "--metrics-port" "$METRICS_PORT"
append_option "--monitoring-endpoint" "$MONITORING_ENDPOINT"
append_option "--monitoring-endpoint-period" "$MONITORING_ENDPOINT_PERIOD"
append_option "--network" "$NETWORK"
append_option "--proposer-nodes" "$PROPOSER_NODES"
append_option "--safe-slots-to-import-optimistically" "$SAFE_SLOTS_TO_IMPORT_OPTIMISTICALLY"
append_option "--secrets-dir" "$SECRETS_DIR"
append_option "--suggested-fee-recipient" "$SUGGESTED_FEE_RECIPIENT"
append_option "--terminal-block-hash-epoch-override" "$TERMINAL_BLOCK_HASH_EPOCH_OVERRIDE"
append_option "--terminal-block-hash-override" "$TERMINAL_BLOCK_HASH_OVERRIDE"
append_option "--terminal-total-difficulty-override" "$TERMINAL_TOTAL_DIFFICULTY_OVERRIDE"
append_option "--testnet-dir" "$TESTNET_DIR"
append_option "--validator-registration-batch-size" "$VALIDATOR_REGISTRATION_BATCH_SIZE"
append_option "--validators-dir" "$VALIDATORS_DIR"
append_option "--web3-signer-keep-alive-timeout" "$WEB3_SIGNER_KEEP_ALIVE_TIMEOUT"
append_option "--web3-signer-max-idle-connections" "$WEB3_SIGNER_MAX_IDLE_CONNECTIONS"

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

echo "Using Options: lighthouse validator_client $OPTIONS"

exec lighthouse validator_client $OPTIONS
