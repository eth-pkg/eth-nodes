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
append_option "--beacon-node-api-endpoints" "$beacon_node_api_endpoints"
append_option "--beacon-node-ssz-blocks-enabled" "$beacon_node_ssz_blocks_enabled"
append_option "--config-file" "$config_file"
append_option "--data-base-path" "$data_base_path"
append_option "--data-validator-path" "$data_validator_path"
append_option "--doppelganger-detection-enabled" "$doppelganger_detection_enabled"
append_option "--exit-when-no-validator-keys-enabled" "$exit_when_no_validator_keys_enabled"
append_option "--logging" "$logging"
append_option "--log-color-enabled" "$log_color_enabled"
append_option "--log-destination" "$log_destination"
append_option "--log-file" "$log_file"
append_option "--log-file-name-pattern" "$log_file_name_pattern"
append_option "--log-include-events-enabled" "$log_include_events_enabled"
append_option "--log-include-validator-duties-enabled" "$log_include_validator_duties_enabled"
append_option "--metrics-block-timing-tracking-enabled" "$metrics_block_timing_tracking_enabled"
append_option "--metrics-categories" "$metrics_categories"
append_option "--metrics-enabled" "$metrics_enabled"
append_option "--metrics-host-allowlist" "$metrics_host_allowlist"
append_option "--metrics-interface" "$metrics_interface"
append_option "--metrics-port" "$metrics_port"
append_option "--metrics-publish-endpoint" "$metrics_publish_endpoint"
append_option "--metrics-publish-interval" "$metrics_publish_interval"
append_option "--network" "$network"
append_option "--shut-down-when-validator-slashed-enabled" "$shut_down_when_validator_slashed_enabled"
append_option "--validator-api-bearer-file" "$validator_api_bearer_file"
append_option "--validator-api-cors-origins" "$validator_api_cors_origins"
append_option "--validator-api-docs-enabled" "$validator_api_docs_enabled"
append_option "--validator-api-enabled" "$validator_api_enabled"
append_option "--validator-api-host-allowlist" "$validator_api_host_allowlist"
append_option "--validator-api-interface" "$validator_api_interface"
append_option "--validator-api-keystore-file" "$validator_api_keystore_file"
append_option "--validator-api-keystore-password-file" "$validator_api_keystore_password_file"
append_option "--validator-api-port" "$validator_api_port"
append_option "--validator-is-local-slashing-protection-synchronized-enabled" "$validator_is_local_slashing_protection_synchronized_enabled"
append_option "--validator-keys" "$validator_keys"
append_option "--validators-builder-registration-default-enabled" "$validators_builder_registration_default_enabled"
append_option "--validators-early-attestations-enabled" "$validators_early_attestations_enabled"
append_option "--validators-external-signer-keystore" "$validators_external_signer_keystore"
append_option "--validators-external-signer-keystore-password-file" "$validators_external_signer_keystore_password_file"
append_option "--validators-external-signer-public-keys" "$validators_external_signer_public_keys"
append_option "--validators-external-signer-slashing-protection-enabled" "$validators_external_signer_slashing_protection_enabled"
append_option "--validators-external-signer-timeout" "$validators_external_signer_timeout"
append_option "--validators-external-signer-truststore" "$validators_external_signer_truststore"
append_option "--validators-external-signer-truststore-password-file" "$validators_external_signer_truststore_password_file"
append_option "--validators-external-signer-url" "$validators_external_signer_url"
append_option "--validators-graffiti" "$validators_graffiti"
append_option "--validators-graffiti-client-append-format" "$validators_graffiti_client_append_format"
append_option "--validators-graffiti-file" "$validators_graffiti_file"
append_option "--validators-keystore-locking-enabled" "$validators_keystore_locking_enabled"
append_option "--validators-performance-tracking-mode" "$validators_performance_tracking_mode"
append_option "--validators-proposer-blinded-blocks-enabled" "$validators_proposer_blinded_blocks_enabled"
append_option "--validators-proposer-config" "$validators_proposer_config"
append_option "--validators-proposer-config-refresh-enabled" "$validators_proposer_config_refresh_enabled"
append_option "--validators-proposer-default-fee-recipient" "$validators_proposer_default_fee_recipient"

echo "Using Options teku validator-client $OPTIONS"

exec teku validator-client $OPTIONS