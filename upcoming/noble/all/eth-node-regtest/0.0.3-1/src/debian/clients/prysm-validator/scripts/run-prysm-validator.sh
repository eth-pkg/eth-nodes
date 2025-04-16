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

# cmd options

append_flag "--accept-terms-of-use" "$PRYSM_VALIDATOR_ACCEPT_TERMS_OF_USE"
append_option "--api-timeout" "$PRYSM_VALIDATOR_API_TIMEOUT"
append_option "--chain-config-file" "$PRYSM_VALIDATOR_CHAIN_CONFIG_FILE"
append_flag "--clear-db" "$PRYSM_VALIDATOR_CLEAR_DB"
append_option "--config-file" "$PRYSM_VALIDATOR_CONFIG_FILE"
append_option "--datadir" "$PRYSM_VALIDATOR_DATADIR"
append_option "--db-backup-output-dir" "$PRYSM_VALIDATOR_DB_BACKUP_OUTPUT_DIR"
append_flag "--disable-monitoring" "$PRYSM_VALIDATOR_DISABLE_MONITORING"
append_flag "--e2e-config" "$PRYSM_VALIDATOR_E2E_CONFIG"
append_flag "--enable-db-backup-webhook" "$PRYSM_VALIDATOR_ENABLE_DB_BACKUP_WEBHOOK"
append_flag "--enable-tracing" "$PRYSM_VALIDATOR_ENABLE_TRACING"
append_flag "--force-clear-db" "$PRYSM_VALIDATOR_FORCE_CLEAR_DB"
append_option "--grpc-max-msg-size" "$PRYSM_VALIDATOR_GRPC_MAX_MSG_SIZE"
append_option "--log-file" "$PRYSM_VALIDATOR_LOG_FILE"
append_option "--log-format" "$PRYSM_VALIDATOR_LOG_FORMAT"
append_flag "--minimal-config" "$PRYSM_VALIDATOR_MINIMAL_CONFIG"
append_option "--monitoring-host" "$PRYSM_VALIDATOR_MONITORING_HOST"
append_option "--monitoring-port" "$PRYSM_VALIDATOR_MONITORING_PORT"
append_option "--trace-sample-fraction" "$PRYSM_VALIDATOR_TRACE_SAMPLE_FRACTION"
append_option "--tracing-endpoint" "$PRYSM_VALIDATOR_TRACING_ENDPOINT"
append_option "--tracing-process-name" "$PRYSM_VALIDATOR_TRACING_PROCESS_NAME"
append_option "--verbosity" "$PRYSM_VALIDATOR_VERBOSITY"
append_option "--wallet-dir" "$PRYSM_VALIDATOR_WALLET_DIR"
append_option "--wallet-password-file" "$PRYSM_VALIDATOR_WALLET_PASSWORD_FILE"

# debug options

append_option "--blockprofilerate" "$PRYSM_VALIDATOR_BLOCKPROFILERATE"
append_option "--cpuprofile" "$PRYSM_VALIDATOR_CPUPROFILE"
append_option "--memprofilerate" "$PRYSM_VALIDATOR_MEMPROFILERATE"
append_option "--mutexprofilefraction" "$PRYSM_VALIDATOR_MUTEXPROFILEFRACTION"
append_flag "--pprof" "$PRYSM_VALIDATOR_PPROF"
append_option "--pprofaddr" "$PRYSM_VALIDATOR_PPROFADDR"
append_option "--pprofport" "$PRYSM_VALIDATOR_PPROFPORT"
append_option "--trace" "$PRYSM_VALIDATOR_TRACE"

# rpc options

append_option "--beacon-rest-api-provider" "$PRYSM_VALIDATOR_BEACON_REST_API_PROVIDER"
append_option "--beacon-rpc-gateway-provider" "$PRYSM_VALIDATOR_BEACON_RPC_GATEWAY_PROVIDER"
append_option "--beacon-rpc-provider" "$PRYSM_VALIDATOR_BEACON_RPC_PROVIDER"
append_option "--grpc-gateway-corsdomain" "$PRYSM_VALIDATOR_GRPC_GATEWAY_CORSDOMAIN"
append_option "--grpc-gateway-host" "$PRYSM_VALIDATOR_GRPC_GATEWAY_HOST"
append_option "--grpc-gateway-port" "$PRYSM_VALIDATOR_GRPC_GATEWAY_PORT"
append_option "--grpc-headers" "$PRYSM_VALIDATOR_GRPC_HEADERS"
append_option "--grpc-retries" "$PRYSM_VALIDATOR_GRPC_RETRIES"
append_option "--grpc-retry-delay" "$PRYSM_VALIDATOR_GRPC_RETRY_DELAY"
append_flag "--rpc" "$PRYSM_VALIDATOR_RPC"
append_option "--rpc-host" "$PRYSM_VALIDATOR_RPC_HOST"
append_option "--rpc-port" "$PRYSM_VALIDATOR_RPC_PORT"
append_option "--tls-cert" "$PRYSM_VALIDATOR_TLS_CERT"

# Proposer Options
append_flag "--enable-builder" "$PRYSM_VALIDATOR_ENABLE_BUILDER"
append_flag "--enable-validator-registration" "$PRYSM_VALIDATOR_ENABLE_VALIDATOR_REGISTRATION"
append_option "--graffiti" "$PRYSM_VALIDATOR_GRAFFITI"
append_option "--graffiti-file" "$PRYSM_VALIDATOR_GRAFFITI_FILE"
append_option "--proposer-settings-file" "$PRYSM_VALIDATOR_PROPOSER_SETTINGS_FILE"
append_option "--proposer-settings-url" "$PRYSM_VALIDATOR_PROPOSER_SETTINGS_URL"
append_option "--suggested-fee-recipient" "$PRYSM_VALIDATOR_SUGGESTED_FEE_RECIPIENT"
append_option "--suggested-gas-limit" "$PRYSM_VALIDATOR_SUGGESTED_GAS_LIMIT"
append_option "--validators-registration-batch-size" "$PRYSM_VALIDATOR_VALIDATORS_REGISTRATION_BATCH_SIZE"

# Remote Signer Options
append_option "--validators-external-signer-key-file" "$PRYSM_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_KEY_FILE"
append_option "--validators-external-signer-public-keys" "$PRYSM_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_PUBLIC_KEYS"
append_option "--validators-external-signer-url" "$PRYSM_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_URL"

# Slasher Options
append_option "--slasher-rpc-provider" "$PRYSM_VALIDATOR_SLASHER_RPC_PROVIDER"
append_option "--slasher-tls-cert" "$PRYSM_VALIDATOR_SLASHER_TLS_CERT"

# Misc Options
append_flag "--disable-account-metrics" "$PRYSM_VALIDATOR_DISABLE_ACCOUNT_METRICS"
append_flag "--disable-rewards-penalties-logging" "$PRYSM_VALIDATOR_DISABLE_REWARDS_PENALTIES_LOGGING"
append_flag "--distributed" "$PRYSM_VALIDATOR_DISTRIBUTED"
append_option "--keymanager-token-file" "$PRYSM_VALIDATOR_KEYMANAGER_TOKEN_FILE"
append_flag "--web" "$PRYSM_VALIDATOR_WEB"

# Features Options
append_flag "--attest-timely" "$PRYSM_VALIDATOR_ATTEST_TIMELY"
append_option "--dynamic-key-reload-debounce-interval" "$PRYSM_VALIDATOR_DYNAMIC_KEY_RELOAD_DEBOUNCE_INTERVAL"
append_flag "--enable-beacon-rest-api" "$PRYSM_VALIDATOR_ENABLE_BEACON_REST_API"
append_flag "--enable-doppelganger" "$PRYSM_VALIDATOR_ENABLE_DOPPELGANGER"
append_flag "--enable-minimal-slashing-protection" "$PRYSM_VALIDATOR_ENABLE_MINIMAL_SLASHING_PROTECTION"
append_flag "--enable-slashing-protection-history-pruning" "$PRYSM_VALIDATOR_ENABLE_SLASHING_PROTECTION_HISTORY_PRUNING"
append_flag "--holesky" "$PRYSM_VALIDATOR_HOLESKY"
append_flag "--mainnet" "$PRYSM_VALIDATOR_MAINNET"
append_flag "--sepolia" "$PRYSM_VALIDATOR_SEPOLIA"
append_flag "--write-wallet-password-on-web-onboarding" "$PRYSM_VALIDATOR_WRITE_WALLET_PASSWORD_ON_WEB_ONBOARDING"

echo "Importing validator accounts: /usr/lib/eth-node-prysm/bin/validator accounts import --keys-dir=$wallet_keystore --wallet-dir=$wallet_dir --wallet-password-file=$wallet_password_file --account-password-file=$account_password_file"

/usr/lib/eth-node-prysm/bin/validator accounts import --keys-dir="$wallet_keystore" \
    --wallet-dir="$wallet_dir" \
    --wallet-password-file="$wallet_password_file" \
    --account-password-file="$account_password_file" \
    --accept-terms-of-use

echo "Using Options  /usr/lib/eth-node-prysm/bin/validator $OPTIONS"

# TODO

exec /usr/lib/eth-node-prysm/bin/validator $OPTIONS
