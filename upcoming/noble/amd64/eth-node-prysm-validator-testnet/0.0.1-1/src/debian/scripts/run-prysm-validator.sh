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

# Capital Case Options
append_flag "--accept-terms-of-use" "$PRYSM_CLI_VALIDATOR_ACCEPT_TERMS_OF_USE"
append_option "--api-timeout" "$PRYSM_CLI_VALIDATOR_API_TIMEOUT"
append_option "--chain-config-file" "$PRYSM_CLI_VALIDATOR_CHAIN_CONFIG_FILE"
append_flag "--clear-db" "$PRYSM_CLI_VALIDATOR_CLEAR_DB"
append_option "--config-file" "$PRYSM_CLI_VALIDATOR_CONFIG_FILE"
append_option "--datadir" "$PRYSM_CLI_VALIDATOR_DATADIR"
append_option "--db-backup-output-dir" "$PRYSM_CLI_VALIDATOR_DB_BACKUP_OUTPUT_DIR"
append_flag "--disable-monitoring" "$PRYSM_CLI_VALIDATOR_DISABLE_MONITORING"
append_flag "--e2e-config" "$PRYSM_CLI_VALIDATOR_E2E_CONFIG"
append_flag "--enable-db-backup-webhook" "$PRYSM_CLI_VALIDATOR_ENABLE_DB_BACKUP_WEBHOOK"
append_flag "--enable-tracing" "$PRYSM_CLI_VALIDATOR_ENABLE_TRACING"
append_flag "--force-clear-db" "$PRYSM_CLI_VALIDATOR_FORCE_CLEAR_DB"
append_option "--grpc-max-msg-size" "$PRYSM_CLI_VALIDATOR_GRPC_MAX_MSG_SIZE"
append_option "--log-file" "$PRYSM_CLI_VALIDATOR_LOG_FILE"
append_option "--log-format" "$PRYSM_CLI_VALIDATOR_LOG_FORMAT"
append_flag "--minimal-config" "$PRYSM_CLI_VALIDATOR_MINIMAL_CONFIG"
append_option "--monitoring-host" "$PRYSM_CLI_VALIDATOR_MONITORING_HOST"
append_option "--monitoring-port" "$PRYSM_CLI_VALIDATOR_MONITORING_PORT"
append_option "--trace-sample-fraction" "$PRYSM_CLI_VALIDATOR_TRACE_SAMPLE_FRACTION"
append_option "--tracing-endpoint" "$PRYSM_CLI_VALIDATOR_TRACING_ENDPOINT"
append_option "--tracing-process-name" "$PRYSM_CLI_VALIDATOR_TRACING_PROCESS_NAME"
append_option "--verbosity" "$PRYSM_CLI_VALIDATOR_VERBOSITY"

# Debug Options
append_option "--blockprofilerate" "$PRYSM_CLI_VALIDATOR_BLOCKPROFILERATE"
append_option "--cpuprofile" "$PRYSM_CLI_VALIDATOR_CPUPROFILE"
append_option "--memprofilerate" "$PRYSM_CLI_VALIDATOR_MEMPROFILERATE"
append_option "--mutexprofilefraction" "$PRYSM_CLI_VALIDATOR_MUTEXPROFILEFRACTION"
append_flag "--pprof" "$PRYSM_CLI_VALIDATOR_PPROF"
append_option "--pprofaddr" "$PRYSM_CLI_VALIDATOR_PPROFADDR"
append_option "--pprofport" "$PRYSM_CLI_VALIDATOR_PPROFPORT"
append_option "--trace" "$PRYSM_CLI_VALIDATOR_TRACE"

# Validator Options
append_option "--beacon-rest-api-provider" "$PRYSM_CLI_VALIDATOR_BEACON_REST_API_PROVIDER"
append_option "--beacon-rpc-gateway-provider" "$PRYSM_CLI_VALIDATOR_BEACON_RPC_GATEWAY_PROVIDER"
append_option "--beacon-rpc-provider" "$PRYSM_CLI_VALIDATOR_BEACON_RPC_PROVIDER"
append_flag "--disable-account-metrics" "$PRYSM_CLI_VALIDATOR_DISABLE_ACCOUNT_METRICS"
append_flag "--disable-rewards-penalties-logging" "$PRYSM_CLI_VALIDATOR_DISABLE_REWARDS_PENALTIES_LOGGING"
append_flag "--distributed" "$PRYSM_CLI_VALIDATOR_DISTRIBUTED"
append_flag "--enable-builder" "$PRYSM_CLI_VALIDATOR_ENABLE_BUILDER"
append_option "--graffiti" "$PRYSM_CLI_VALIDATOR_GRAFFITI"
append_option "--graffiti-file" "$PRYSM_CLI_VALIDATOR_GRAFFITI_FILE"
append_option "--grpc-gateway-corsdomain" "$PRYSM_CLI_VALIDATOR_GRPC_GATEWAY_CORSDOMAIN"
append_option "--grpc-gateway-host" "$PRYSM_CLI_VALIDATOR_GRPC_GATEWAY_HOST"
append_option "--grpc-gateway-port" "$PRYSM_CLI_VALIDATOR_GRPC_GATEWAY_PORT"
append_option "--grpc-headers" "$PRYSM_CLI_VALIDATOR_GRPC_HEADERS"
append_option "--grpc-retries" "$PRYSM_CLI_VALIDATOR_GRPC_RETRIES"
append_option "--grpc-retry-delay" "$PRYSM_CLI_VALIDATOR_GRPC_RETRY_DELAY"
append_option "--proposer-settings-file" "$PRYSM_CLI_VALIDATOR_PROPOSER_SETTINGS_FILE"
append_option "--proposer-settings-url" "$PRYSM_CLI_VALIDATOR_PROPOSER_SETTINGS_URL"
append_flag "--rpc" "$PRYSM_CLI_VALIDATOR_RPC"
append_option "--rpc-host" "$PRYSM_CLI_VALIDATOR_RPC_HOST"
append_option "--rpc-port" "$PRYSM_CLI_VALIDATOR_RPC_PORT"
append_option "--slasher-rpc-provider" "$PRYSM_CLI_VALIDATOR_SLASHER_RPC_PROVIDER"
append_option "--slasher-tls-cert" "$PRYSM_CLI_VALIDATOR_SLASHER_TLS_CERT"
append_option "--suggested-fee-recipient" "$PRYSM_CLI_VALIDATOR_SUGGESTED_FEE_RECIPIENT"
append_option "--suggested-gas-limit" "$PRYSM_CLI_VALIDATOR_SUGGESTED_GAS_LIMIT"
append_option "--tls-cert" "$PRYSM_CLI_VALIDATOR_TLS_CERT"
append_option "--validators-external-signer-public-keys" "$PRYSM_CLI_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_PUBLIC_KEYS"
append_option "--validators-external-signer-url" "$PRYSM_CLI_VALIDATOR_VALIDATORS_EXTERNAL_SIGNER_URL"
append_option "--validators-registration-batch-size" "$PRYSM_CLI_VALIDATOR_VALIDATORS_REGISTRATION_BATCH_SIZE"
append_option "--wallet-dir" "$PRYSM_CLI_VALIDATOR_WALLET_DIR"
append_option "--wallet-password-file" "$PRYSM_CLI_VALIDATOR_WALLET_PASSWORD_FILE"
append_flag "--web" "$PRYSM_CLI_VALIDATOR_WEB"

# Features Options
append_flag "--attest-timely" "$PRYSM_CLI_VALIDATOR_ATTEST_TIMELY"
append_option "--dynamic-key-reload-debounce-interval" "$PRYSM_CLI_VALIDATOR_DYNAMIC_KEY_RELOAD_DEBOUNCE_INTERVAL"
append_flag "--enable-beacon-rest-api" "$PRYSM_CLI_VALIDATOR_ENABLE_BEACON_REST_API"
append_flag "--enable-doppelganger" "$PRYSM_CLI_VALIDATOR_ENABLE_DOPPELGANGER"
append_flag "--enable-minimal-slashing-protection" "$PRYSM_CLI_VALIDATOR_ENABLE_MINIMAL_SLASHING_PROTECTION"
append_flag "--enable-slashing-protection-history-pruning" "$PRYSM_CLI_VALIDATOR_ENABLE_SLASHING_PROTECTION_HISTORY_PRUNING"
append_flag "--holesky" "$PRYSM_CLI_VALIDATOR_HOLESKY"
append_flag "--mainnet" "$PRYSM_CLI_VALIDATOR_MAINNET"
append_flag "--prater" "$PRYSM_CLI_VALIDATOR_PRATER"
append_flag "--sepolia" "$PRYSM_CLI_VALIDATOR_SEPOLIA"
append_flag "--write-wallet-password-on-web-onboarding" "$PRYSM_CLI_VALIDATOR_WRITE_WALLET_PASSWORD_ON_WEB_ONBOARDING"

# Interop Options
append_option "--interop-num-validators" "$PRYSM_CLI_VALIDATOR_INTEROP_NUM_VALIDATORS"
append_option "--interop-start-index" "$PRYSM_CLI_VALIDATOR_INTEROP_START_INDEX"

echo "Using Options: $OPTIONS"

# TODO 
exec /usr/lib/eth-node-prysm/bin/validator $OPTIONS