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

OPTIONS=""

append_option() {
    local option=$1
    local value=$2
    if [ -n "$value" ]; then
        OPTIONS="$OPTIONS $option $value"
    fi
}

append_flag() {
    local option=$1
    local value=$2
    if [ "$value" = "true" ]; then
        OPTIONS="$OPTIONS $option"
    fi
}

append_option "--config-file" "$TEKU_CONFIG_FILE"
# network
append_option "--checkpoint-sync-url" "$TEKU_CHECKPOINT_SYNC_URL"
append_option "--eth1-deposit-contract-address" "$TEKU_ETH1_DEPOSIT_CONTRACT_ADDRESS"
append_option "--genesis-state" "$TEKU_GENESIS_STATE"
append_option "--ignore-weak-subjectivity-period-enabled" "$TEKU_IGNORE_WEAK_SUBJECTIVITY_PERIOD_ENABLED"
append_option "--initial-state" "$TEKU_INITIAL_STATE"
append_option "--network" "$TEKU_NETWORK"

# p2p
append_option "--p2p-advertised-ip" "$TEKU_P2P_ADVERTISED_IP"
append_option "--p2p-advertised-port" "$TEKU_P2P_ADVERTISED_PORT"
append_option "--p2p-advertised-port-ipv6" "$TEKU_P2P_ADVERTISED_PORT_IPV6"
append_option "--p2p-advertised-udp-port" "$TEKU_P2P_ADVERTISED_UDP_PORT"
append_option "--p2p-advertised-udp-port-ipv6" "$TEKU_P2P_ADVERTISED_UDP_PORT_IPV6"
append_option "--p2p-direct-peers" "$TEKU_P2P_DIRECT_PEERS"
append_option "--p2p-discovery-bootnodes" "$TEKU_P2P_DISCOVERY_BOOTNODES"
append_option "--p2p-discovery-enabled" "$TEKU_P2P_DISCOVERY_ENABLED"
append_option "--p2p-discovery-site-local-addresses-enabled" "$TEKU_P2P_DISCOVERY_SITE_LOCAL_ADDRESSES_ENABLED"
append_option "--p2p-enabled" "$TEKU_P2P_ENABLED"
append_option "--p2p-interface" "$TEKU_P2P_INTERFACE"
append_option "--p2p-nat-method" "$TEKU_P2P_NAT_METHOD"
append_option "--p2p-peer-lower-bound" "$TEKU_P2P_PEER_LOWER_BOUND"
append_option "--p2p-peer-upper-bound" "$TEKU_P2P_PEER_UPPER_BOUND"
append_option "--p2p-port" "$TEKU_P2P_PORT"
append_option "--p2p-port-ipv6" "$TEKU_P2P_PORT_IPV6"
append_option "--p2p-private-key-file" "$TEKU_P2P_PRIVATE_KEY_FILE"
append_option "--p2p-static-peers" "$TEKU_P2P_STATIC_PEERS"
append_option "--p2p-subscribe-all-subnets-enabled" "$TEKU_P2P_SUBSCRIBE_ALL_SUBNETS_ENABLED"
append_option "--p2p-udp-port" "$TEKU_P2P_UDP_PORT"
append_option "--p2p-udp-port-ipv6" "$TEKU_P2P_UDP_PORT_IPV6"

# validator
append_option "--doppelganger-detection-enabled" "$TEKU_DOPPELGANGER_DETECTION_ENABLED"
append_option "--exit-when-no-validator-keys-enabled" "$TEKU_EXIT_WHEN_NO_VALIDATOR_KEYS_ENABLED"
append_option "--shut-down-when-validator-slashed-enabled" "$TEKU_SHUT_DOWN_WHEN_VALIDATOR_SLASHED_ENABLED"
append_option "--validator-is-local-slashing-protection-synchronized-enabled" "$TEKU_VALIDATOR_IS_LOCAL_SLASHING_PROTECTION_SYNCHRONIZED_ENABLED"
append_option "--validator-keys" "$TEKU_VALIDATOR_KEYS"
append_option "--validators-builder-registration-default-enabled" "$TEKU_VALIDATORS_BUILDER_REGISTRATION_DEFAULT_ENABLED"
append_option "--validators-early-attestations-enabled" "$TEKU_VALIDATORS_EARLY_ATTESTATIONS_ENABLED"
append_option "--validators-external-signer-keystore" "$TEKU_VALIDATORS_EXTERNAL_SIGNER_KEYSTORE"
append_option "--validators-external-signer-keystore-password-file" "$TEKU_VALIDATORS_EXTERNAL_SIGNER_KEYSTORE_PASSWORD_FILE"
append_option "--validators-external-signer-public-keys" "$TEKU_VALIDATORS_EXTERNAL_SIGNER_PUBLIC_KEYS"
append_option "--validators-external-signer-slashing-protection-enabled" "$TEKU_VALIDATORS_EXTERNAL_SIGNER_SLASHING_PROTECTION_ENABLED"
append_option "--validators-external-signer-timeout" "$TEKU_VALIDATORS_EXTERNAL_SIGNER_TIMEOUT"
append_option "--validators-external-signer-truststore" "$TEKU_VALIDATORS_EXTERNAL_SIGNER_TRUSTSTORE"
append_option "--validators-external-signer-truststore-password-file" "$TEKU_VALIDATORS_EXTERNAL_SIGNER_TRUSTSTORE_PASSWORD_FILE"
append_option "--validators-external-signer-url" "$TEKU_VALIDATORS_EXTERNAL_SIGNER_URL"
append_option "--validators-graffiti" "$TEKU_VALIDATORS_GRAFFITI"
append_option "--validators-graffiti-client-append-format" "$TEKU_VALIDATORS_GRAFFITI_CLIENT_APPEND_FORMAT"
append_option "--validators-graffiti-file" "$TEKU_VALIDATORS_GRAFFITI_FILE"
append_option "--validators-keystore-locking-enabled" "$TEKU_VALIDATORS_KEYSTORE_LOCKING_ENABLED"
append_option "--validators-performance-tracking-mode" "$TEKU_VALIDATORS_PERFORMANCE_TRACKING_MODE"
append_option "--validators-proposer-blinded-blocks-enabled" "$TEKU_VALIDATORS_PROPOSER_BLINDED_BLOCKS_ENABLED"
append_option "--validators-proposer-config" "$TEKU_VALIDATORS_PROPOSER_CONFIG"
append_option "--validators-proposer-config-refresh-enabled" "$TEKU_VALIDATORS_PROPOSER_CONFIG_REFRESH_ENABLED"
append_option "--validators-proposer-default-fee-recipient" "$TEKU_VALIDATORS_PROPOSER_DEFAULT_FEE_RECIPIENT"

# execution layer
append_option "--builder-bid-compare-factor" "$TEKU_BUILDER_BID_COMPARE_FACTOR"
append_option "--builder-endpoint" "$TEKU_BUILDER_ENDPOINT"
append_option "--builder-set-user-agent-header" "$TEKU_BUILDER_SET_USER_AGENT_HEADER"
append_option "--deposit-snapshot-enabled" "$TEKU_DEPOSIT_SNAPSHOT_ENABLED"
append_option "--ee-endpoint" "$TEKU_EE_ENDPOINT"
append_option "--ee-jwt-claim-id" "$TEKU_EE_JWT_CLAIM_ID"
append_option "--ee-jwt-secret-file" "$TEKU_EE_JWT_SECRET_FILE"
append_option "--eth1-deposit-contract-max-request-size" "$TEKU_ETH1_DEPOSIT_CONTRACT_MAX_REQUEST_SIZE"
append_option "--eth1-endpoint" "$TEKU_ETH1_ENDPOINT"
append_option "--exchange-capabilities-monitoring-enabled" "$TEKU_EXCHANGE_CAPABILITIES_MONITORING_ENABLED"

# data storage
append_option "--data-beacon-path" "$TEKU_DATA_BEACON_PATH"
append_option "--data-path" "$TEKU_DATA_PATH"
append_option "--data-storage-archive-frequency" "$TEKU_DATA_STORAGE_ARCHIVE_FREQUENCY"
append_option "--data-storage-mode" "$TEKU_DATA_STORAGE_MODE"
append_option "--data-storage-non-canonical-blocks-enabled" "$TEKU_DATA_STORAGE_NON_CANONICAL_BLOCKS_ENABLED"
append_option "--data-validator-path" "$TEKU_DATA_VALIDATOR_PATH"
append_option "--reconstruct-historic-states" "$TEKU_RECONSTRUCT_HISTORIC_STATES"

# beacon rest api
append_option "--beacon-liveness-tracking-enabled" "$TEKU_BEACON_LIVENESS_TRACKING_ENABLED"
append_option "--rest-api-cors-origins" "$TEKU_REST_API_CORS_ORIGINS"
append_option "--rest-api-docs-enabled" "$TEKU_REST_API_DOCS_ENABLED"
append_option "--rest-api-enabled" "$TEKU_REST_API_ENABLED"
append_option "--rest-api-host-allowlist" "$TEKU_REST_API_HOST_ALLOWLIST"
append_option "--rest-api-interface" "$TEKU_REST_API_INTERFACE"
append_option "--rest-api-port" "$TEKU_REST_API_PORT"

# validator rest api
append_option "--validator-api-bearer-file" "$TEKU_VALIDATOR_API_BEARER_FILE"
append_option "--validator-api-cors-origins" "$TEKU_VALIDATOR_API_CORS_ORIGINS"
append_option "--validator-api-docs-enabled" "$TEKU_VALIDATOR_API_DOCS_ENABLED"
append_option "--validator-api-enabled" "$TEKU_VALIDATOR_API_ENABLED"
append_option "--validator-api-host-allowlist" "$TEKU_VALIDATOR_API_HOST_ALLOWLIST"
append_option "--validator-api-interface" "$TEKU_VALIDATOR_API_INTERFACE"
append_option "--validator-api-keystore-file" "$TEKU_VALIDATOR_API_KEYSTORE_FILE"
append_option "--validator-api-keystore-password-file" "$TEKU_VALIDATOR_API_KEYSTORE_PASSWORD_FILE"
append_option "--validator-api-port" "$TEKU_VALIDATOR_API_PORT"

# weak subjectivity
append_option "--ws-checkpoint" "$TEKU_WS_CHECKPOINT"

# logging
append_option "--logging" "$TEKU_LOGGING"
append_option "--log-color-enabled" "$TEKU_LOG_COLOR_ENABLED"
append_option "--log-destination" "$TEKU_LOG_DESTINATION"
append_option "--log-file" "$TEKU_LOG_FILE"
append_option "--log-file-name-pattern" "$TEKU_LOG_FILE_NAME_PATTERN"
append_option "--log-include-events-enabled" "$TEKU_LOG_INCLUDE_EVENTS_ENABLED"
append_option "--log-include-validator-duties-enabled" "$TEKU_LOG_INCLUDE_VALIDATOR_DUTIES_ENABLED"

# metrics
append_option "--metrics-block-timing-tracking-enabled" "$TEKU_METRICS_BLOCK_TIMING_TRACKING_ENABLED"
append_option "--metrics-categories" "$TEKU_METRICS_CATEGORIES"
append_option "--metrics-enabled" "$TEKU_METRICS_ENABLED"
append_option "--metrics-host-allowlist" "$TEKU_METRICS_HOST_ALLOWLIST"
append_option "--metrics-interface" "$TEKU_METRICS_INTERFACE"
append_option "--metrics-port" "$TEKU_METRICS_PORT"
append_option "--metrics-publish-endpoint" "$TEKU_METRICS_PUBLISH_ENDPOINT"
append_option "--metrics-publish-interval" "$TEKU_METRICS_PUBLISH_INTERVAL"

echo "Using Options: teku $OPTIONS"

exec teku $OPTIONS
