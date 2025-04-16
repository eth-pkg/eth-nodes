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

# Define options for beacon-node-api-endpoints and beacon-node-ssz-blocks-enabled
append_option "--beacon-node-api-endpoints" "$TEKU_VALIDATOR_BEACON_NODE_API_ENDPOINTS"
append_option "--beacon-node-ssz-blocks-enabled" "$TEKU_VALIDATOR_BEACON_NODE_SSZ_BLOCKS_ENABLED"
append_option "--config-file" "$TEKU_VALIDATOR_CONFIG_FILE"
append_option "--data-base-path" "$TEKU_VALIDATOR_DATA_BASE_PATH"
append_option "--data-validator-path" "$TEKU_VALIDATOR_DATA_VALIDATOR_PATH"
append_option "--doppelganger-detection-enabled" "$TEKU_VALIDATOR_DOPPELGANGER_DETECTION_ENABLED"
append_option "--exit-when-no-validator-keys-enabled" "$TEKU_VALIDATOR_EXIT_WHEN_NO_VALIDATOR_KEYS_ENABLED"
append_option "--logging" "$TEKU_VALIDATOR_LOGGING"
append_option "--log-color-enabled" "$TEKU_VALIDATOR_LOG_COLOR_ENABLED"
append_option "--log-destination" "$TEKU_VALIDATOR_LOG_DESTINATION"
append_option "--log-file" "$TEKU_VALIDATOR_LOG_FILE"
append_option "--log-file-name-pattern" "$TEKU_VALIDATOR_LOG_FILE_NAME_PATTERN"
append_option "--log-include-events-enabled" "$TEKU_VALIDATOR_LOG_INCLUDE_EVENTS_ENABLED"
append_option "--log-include-validator-duties-enabled" "$TEKU_VALIDATOR_LOG_INCLUDE_VALIDATOR_DUTIES_ENABLED"
append_option "--metrics-block-timing-tracking-enabled" "$TEKU_VALIDATOR_METRICS_BLOCK_TIMING_TRACKING_ENABLED"
append_option "--metrics-categories" "$TEKU_VALIDATOR_METRICS_CATEGORIES"
append_option "--metrics-enabled" "$TEKU_VALIDATOR_METRICS_ENABLED"
append_option "--metrics-host-allowlist" "$TEKU_VALIDATOR_METRICS_HOST_ALLOWLIST"
append_option "--metrics-interface" "$TEKU_VALIDATOR_METRICS_INTERFACE"
append_option "--metrics-port" "$TEKU_VALIDATOR_METRICS_PORT"
append_option "--metrics-publish-endpoint" "$TEKU_VALIDATOR_METRICS_PUBLISH_ENDPOINT"
append_option "--metrics-publish-interval" "$TEKU_VALIDATOR_METRICS_PUBLISH_INTERVAL"
append_option "--network" "$TEKU_VALIDATOR_NETWORK"
append_option "--shut-down-when-validator-slashed-enabled" "$TEKU_VALIDATOR_SHUT_DOWN_WHEN_VALIDATOR_SLASHED_ENABLED"
append_option "--validator-api-bearer-file" "$TEKU_VALIDATOR_VALIDATOR_API_BEARER_FILE"
append_option "--validator-api-cors-origins" "$TEKU_VALIDATOR_VALIDATOR_API_CORS_ORIGINS"
append_option "--validator-api-docs-enabled" "$TEKU_VALIDATOR_VALIDATOR_API_DOCS_ENABLED"
append_option "--validator-api-enabled" "$TEKU_VALIDATOR_VALIDATOR_API_ENABLED"
append_option "--validator-api-host-allowlist" "$TEKU_VALIDATOR_VALIDATOR_API_HOST_ALLOWLIST"
append_option "--validator-api-interface" "$TEKU_VALIDATOR_VALIDATOR_API_INTERFACE"
append_option "--validator-api-keystore-file" "$TEKU_VALIDATOR_VALIDATOR_API_KEYSTORE_FILE"
append_option "--validator-api-keystore-password-file" "$TEKU_VALIDATOR_VALIDATOR_API_KEYSTORE_PASSWORD_FILE"
append_option "--validator-api-port" "$TEKU_VALIDATOR_VALIDATOR_API_PORT"
append_option "--validator-is-local-slashing-protection-synchronized-enabled" "$TEKU_VALIDATOR_VALIDATOR_IS_LOCAL_SLASHING_PROTECTION_SYNCHRONIZED_ENABLED"
append_option "--validator-keys" "$TEKU_VALIDATOR_VALIDATOR_KEYS"
append_option "--validators-builder-registration-default-enabled" "$TEKU_VALIDATOR_VALIDATORS_BUILDER_REGISTRATION_DEFAULT_ENABLED"
append_option "--validators-early-attestations-enabled" "$TEKU_VALIDATOR_VALIDATORS_EARLY_ATTESTATIONS_ENABLED"
append_option "--validators-external-signer-keystore" "$TEKU_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_KEYSTORE"
append_option "--validators-external-signer-keystore-password-file" "$TEKU_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_KEYSTORE_PASSWORD_FILE"
append_option "--validators-external-signer-public-keys" "$TEKU_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_PUBLIC_KEYS"
append_option "--validators-external-signer-slashing-protection-enabled" "$TEKU_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_SLASHING_PROTECTION_ENABLED"
append_option "--validators-external-signer-timeout" "$TEKU_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_TIMEOUT"
append_option "--validators-external-signer-truststore" "$TEKU_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_TRUSTSTORE"
append_option "--validators-external-signer-truststore-password-file" "$TEKU_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_TRUSTSTORE_PASSWORD_FILE"
append_option "--validators-external-signer-url" "$TEKU_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_URL"
append_option "--validators-graffiti" "$TEKU_VALIDATOR_VALIDATORS_GRAFFITI"
append_option "--validators-graffiti-client-append-format" "$TEKU_VALIDATOR_VALIDATORS_GRAFFITI_CLIENT_APPEND_FORMAT"
append_option "--validators-graffiti-file" "$TEKU_VALIDATOR_VALIDATORS_GRAFFITI_FILE"
append_option "--validators-keystore-locking-enabled" "$TEKU_VALIDATOR_VALIDATORS_KEYSTORE_LOCKING_ENABLED"
append_option "--validators-performance-tracking-mode" "$TEKU_VALIDATOR_VALIDATORS_PERFORMANCE_TRACKING_MODE"
append_option "--validators-proposer-blinded-blocks-enabled" "$TEKU_VALIDATOR_VALIDATORS_PROPOSER_BLINDED_BLOCKS_ENABLED"
append_option "--validators-proposer-config" "$TEKU_VALIDATOR_VALIDATORS_PROPOSER_CONFIG"
append_option "--validators-proposer-config-refresh-enabled" "$TEKU_VALIDATOR_VALIDATORS_PROPOSER_CONFIG_REFRESH_ENABLED"
append_option "--validators-proposer-default-fee-recipient" "$TEKU_VALIDATOR_VALIDATORS_PROPOSER_DEFAULT_FEE_RECIPIENT"

echo "Using Options teku validator-client $OPTIONS"

