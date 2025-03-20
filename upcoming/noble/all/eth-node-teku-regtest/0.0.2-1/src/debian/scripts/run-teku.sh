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

OPTIONS=""

append_option() {
  local option=$1
  local value=$2
  if [ -n "$value" ]; then
    OPTIONS="$OPTIONS $option $value"
  fi
}

append_flag(){
 local option=$1
  local value=$2
  if [ "$value" = "true" ]; then
    OPTIONS="$OPTIONS $option"
  fi 
}

append_option "--config-file" "$config_file"
# network 
append_option "--checkpoint-sync-url" "$checkpoint_sync_url"
append_option "--eth1-deposit-contract-address" "$eth1_deposit_contract_address"
append_option "--genesis-state" "$genesis_state"
append_option "--ignore-weak-subjectivity-period-enabled" "$ignore_weak_subjectivity_period_enabled"
append_option "--initial-state" "$initial_state"
append_option "--network" "$network"

# p2p 
append_option "--p2p-advertised-ip" "$p2p_advertised_ip"
append_option "--p2p-advertised-port" "$p2p_advertised_port"
append_option "--p2p-advertised-port-ipv6" "$p2p_advertised_port_ipv6"
append_option "--p2p-advertised-udp-port" "$p2p_advertised_udp_port"
append_option "--p2p-advertised-udp-port-ipv6" "$p2p_advertised_udp_port_ipv6"
append_option "--p2p-direct-peers" "$p2p_direct_peers"
append_option "--p2p-discovery-bootnodes" "$p2p_discovery_bootnodes"
append_option "--p2p-discovery-enabled" "$p2p_discovery_enabled"
append_option "--p2p-discovery-site-local-addresses-enabled" "$p2p_discovery_site_local_addresses_enabled"
append_option "--p2p-enabled" "$p2p_enabled"
append_option "--p2p-interface" "$p2p_interface"
append_option "--p2p-nat-method" "$p2p_nat_method"
append_option "--p2p-peer-lower-bound" "$p2p_peer_lower_bound"
append_option "--p2p-peer-upper-bound" "$p2p_peer_upper_bound"
append_option "--p2p-port" "$p2p_port"
append_option "--p2p-port-ipv6" "$p2p_port_ipv6"
append_option "--p2p-private-key-file" "$p2p_private_key_file"
append_option "--p2p-static-peers" "$p2p_static_peers"
append_option "--p2p-subscribe-all-subnets-enabled" "$p2p_subscribe_all_subnets_enabled"
append_option "--p2p-udp-port" "$p2p_udp_port"
append_option "--p2p-udp-port-ipv6" "$p2p_udp_port_ipv6"

# validator 
append_option "--doppelganger-detection-enabled" "$doppelganger_detection_enabled"
append_option "--exit-when-no-validator-keys-enabled" "$exit_when_no_validator_keys_enabled"
append_option "--shut-down-when-validator-slashed-enabled" "$shut_down_when_validator_slashed_enabled"
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


# execution layer 
append_option "--builder-bid-compare-factor" "$builder_bid_compare_factor"
append_option "--builder-endpoint" "$builder_endpoint"
append_option "--builder-set-user-agent-header" "$builder_set_user_agent_header"
append_option "--deposit-snapshot-enabled" "$deposit_snapshot_enabled"
append_option "--ee-endpoint" "$ee_endpoint"
append_option "--ee-jwt-claim-id" "$ee_jwt_claim_id"
append_option "--ee-jwt-secret-file" "$ee_jwt_secret_file"
append_option "--eth1-deposit-contract-max-request-size" "$eth1_deposit_contract_max_request_size"
append_option "--eth1-endpoint" "$eth1_endpoint"
append_option "--exchange-capabilities-monitoring-enabled" "$exchange_capabilities_monitoring_enabled"

# data storage 
append_option "--data-beacon-path" "$data_beacon_path"
append_option "--data-path" "$data_path"
append_option "--data-storage-archive-frequency" "$data_storage_archive_frequency"
append_option "--data-storage-mode" "$data_storage_mode"
append_option "--data-storage-non-canonical-blocks-enabled" "$data_storage_non_canonical_blocks_enabled"
append_option "--data-validator-path" "$data_validator_path"
append_option "--reconstruct-historic-states" "$reconstruct_historic_states"

# beacon rest api 
append_option "--beacon-liveness-tracking-enabled" "$beacon_liveness_tracking_enabled"
append_option "--rest-api-cors-origins" "$rest_api_cors_origins"
append_option "--rest-api-docs-enabled" "$rest_api_docs_enabled"
append_option "--rest-api-enabled" "$rest_api_enabled"
append_option "--rest-api-host-allowlist" "$rest_api_host_allowlist"
append_option "--rest-api-interface" "$rest_api_interface"
append_option "--rest-api-port" "$rest_api_port"

# validator rest api 
append_option "--validator-api-bearer-file" "$validator_api_bearer_file"
append_option "--validator-api-cors-origins" "$validator_api_cors_origins"
append_option "--validator-api-docs-enabled" "$validator_api_docs_enabled"
append_option "--validator-api-enabled" "$validator_api_enabled"
append_option "--validator-api-host-allowlist" "$validator_api_host_allowlist"
append_option "--validator-api-interface" "$validator_api_interface"
append_option "--validator-api-keystore-file" "$validator_api_keystore_file"
append_option "--validator-api-keystore-password-file" "$validator_api_keystore_password_file"
append_option "--validator-api-port" "$validator_api_port"

# weak subjectivity 
append_option "--ws-checkpoint" "$ws_checkpoint"


# logging 
append_option "--logging" "$logging"
append_option "--log-color-enabled" "$log_color_enabled"
append_option "--log-destination" "$log_destination"
append_option "--log-file" "$log_file"
append_option "--log-file-name-pattern" "$log_file_name_pattern"
append_option "--log-include-events-enabled" "$log_include_events_enabled"
append_option "--log-include-validator-duties-enabled" "$log_include_validator_duties_enabled"

# metrics 
append_option "--metrics-block-timing-tracking-enabled" "$metrics_block_timing_tracking_enabled"
append_option "--metrics-categories" "$metrics_categories"
append_option "--metrics-enabled" "$metrics_enabled"
append_option "--metrics-host-allowlist" "$metrics_host_allowlist"
append_option "--metrics-interface" "$metrics_interface"
append_option "--metrics-port" "$metrics_port"
append_option "--metrics-publish-endpoint" "$metrics_publish_endpoint"
append_option "--metrics-publish-interval" "$metrics_publish_interval"


echo "Using Options: teku $OPTIONS"

exec teku $OPTIONS