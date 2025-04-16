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

append_option "--config-file" "$NIMBUS_ETH2_VALIDATOR_CONFIG_FILE"
append_option "--log-level" "$NIMBUS_ETH2_VALIDATOR_LOG_LEVEL"
append_option "--log-file" "$NIMBUS_ETH2_VALIDATOR_LOG_FILE"
append_option "--data-dir" "$NIMBUS_ETH2_VALIDATOR_DATADIR"
append_option "--doppelganger-detection" "$NIMBUS_ETH2_VALIDATOR_DOPPELGANGER_DETECTION"
append_option "--non-interactive" "$NIMBUS_ETH2_VALIDATOR_NON_INTERACTIVE"
append_option "--validators-dir" "$NIMBUS_ETH2_VALIDATOR_VALIDATORS_DIR"
append_option "--verifying-web3-signer-url" "$NIMBUS_ETH2_VALIDATOR_VERIFYING_WEB3_SIGNER_URL"
append_option "--proven-block-property" "$NIMBUS_ETH2_VALIDATOR_PROVEN_BLOCK_PROPERTY"
append_option "--web3-signer-update-interval" "$NIMBUS_ETH2_VALIDATOR_WEB3_SIGNER_UPDATE_INTERVAL"
append_option "--web3-signer-url" "$NIMBUS_ETH2_VALIDATOR_WEB3_SIGNER_URL"
append_option "--secrets-dir" "$NIMBUS_ETH2_VALIDATOR_SECRETS_DIR"
append_option "--rest-request-timeout" "$NIMBUS_ETH2_VALIDATOR_REST_REQUEST_TIMEOUT"
append_option "--rest-max-body-size" "$NIMBUS_ETH2_VALIDATOR_REST_MAX_BODY_SIZE"
append_option "--rest-max-headers-size" "$NIMBUS_ETH2_VALIDATOR_REST_MAX_HEADERS_SIZE"
append_option "--suggested-fee-recipient" "$NIMBUS_ETH2_VALIDATOR_SUGGESTED_FEE_RECIPIENT"
append_option "--suggested-gas-limit" "$NIMBUS_ETH2_VALIDATOR_SUGGESTED_GAS_LIMIT"
append_option "--keymanager" "$NIMBUS_ETH2_VALIDATOR_KEYMANAGER"
append_option "--keymanager-port" "$NIMBUS_ETH2_VALIDATOR_KEYMANAGER_PORT"
append_option "--keymanager-address" "$NIMBUS_ETH2_VALIDATOR_KEYMANAGER_ADDRESS"
append_option "--keymanager-allow-origin" "$NIMBUS_ETH2_VALIDATOR_KEYMANAGER_ALLOW_ORIGIN"
append_option "--keymanager-token-file" "$NIMBUS_ETH2_VALIDATOR_KEYMANAGER_TOKEN_FILE"
append_option "--metrics" "$NIMBUS_ETH2_VALIDATOR_METRICS"
append_option "--metrics-address" "$NIMBUS_ETH2_VALIDATOR_METRICS_ADDRESS"
append_option "--metrics-port" "$NIMBUS_ETH2_VALIDATOR_METRICS_PORT"
append_option "--graffiti" "$NIMBUS_ETH2_VALIDATOR_GRAFFITI"
append_option "--debug-stop-at-epoch" "$NIMBUS_ETH2_VALIDATOR_DEBUG_STOP_AT_EPOCH"
append_option "--payload-builder" "$NIMBUS_ETH2_VALIDATOR_PAYLOAD_BUILDER"
append_option "--distributed" "$NIMBUS_ETH2_VALIDATOR_DISTRIBUTED"
append_option "--builder-boost-factor" "$NIMBUS_ETH2_VALIDATOR_BUILDER_BOOST_FACTOR"
append_option "--beacon-node" "$NIMBUS_ETH2_VALIDATOR_BEACON_NODE"
append_option "--block-monitor-type" "$NIMBUS_ETH2_VALIDATOR_BLOCK_MONITOR_TYPE"

echo "Using Options /usr/lib/eth-node-nimbus-eth2/bin/validator: $OPTIONS"

# /usr/lib/eth-node-nimbus-eth2/bin/nimbus_beacon_node deposits import keys --data-dir=.
# chmod +rwx secrets validators
# TODO generated by hand, need to fix this
# /usr/lib/eth-node-nimbus-eth2/bin/nimbus_beacon_node deposits import \
#    "/var/lib/eth-node-regtest/nimbus-eth2-validator/keys" \
#   --data-dir:/var/lib/eth-node-regtest/nimbus-eth2-validator

# TODO
exec /usr/lib/eth-node-nimbus-eth2/bin/nimbus_validator_client $OPTIONS >$log_file
