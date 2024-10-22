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

# cmd options

append_flag   "--accept-terms-of-use" "$accept_terms_of_use"
append_option "--api-timeout" "$api_timeout"
append_option "--chain-config-file" "$chain_config_file"
append_flag   "--clear-db" "$clear_db"
append_option "--config-file" "$config_file"
append_option "--datadir" "$datadir"
append_option "--db-backup-output-dir" "$db_backup_output_dir"
append_flag   "--disable-monitoring" "$disable_monitoring"
append_flag   "--e2e-config" "$e2e_config"
append_flag   "--enable-db-backup-webhook" "$enable_db_backup_webhook"
append_flag   "--enable-tracing" "$enable_tracing"
append_flag   "--force-clear-db" "$force_clear_db"
append_option "--grpc-max-msg-size" "$grpc_max_msg_size"
append_option "--log-file" "$log_file"
append_option "--log-format" "$log_format"
append_flag   "--minimal-config" "$minimal_config"
append_option "--monitoring-host" "$monitoring_host"
append_option "--monitoring-port" "$monitoring_port"
append_option "--trace-sample-fraction" "$trace_sample_fraction"
append_option "--tracing-endpoint" "$tracing_endpoint"
append_option "--tracing-process-name" "$tracing_process_name"
append_option "--verbosity" "$verbosity"
append_option "--wallet-dir" "$wallet_dir"
append_option "--wallet-password-file" "$wallet_password_file"

# debug options

append_option "--blockprofilerate" "$blockprofilerate"
append_option "--cpuprofile" "$cpuprofile"
append_option "--memprofilerate" "$memprofilerate"
append_option "--mutexprofilefraction" "$mutexprofilefraction"
append_flag   "--pprof" "$pprof"
append_option "--pprofaddr" "$pprofaddr"
append_option "--pprofport" "$pprofport"
append_option "--trace" "$trace"

# rpc options

append_option "--beacon-rest-api-provider" "$beacon_rest_api_provider"
append_option "--beacon-rpc-gateway-provider" "$beacon_rpc_gateway_provider"
append_option "--beacon-rpc-provider" "$beacon_rpc_provider"
append_option "--grpc-gateway-corsdomain" "$grpc_gateway_corsdomain"
append_option "--grpc-gateway-host" "$grpc_gateway_host"
append_option "--grpc-gateway-port" "$grpc_gateway_port"
append_option "--grpc-headers" "$grpc_headers"
append_option "--grpc-retries" "$grpc_retries"
append_option "--grpc-retry-delay" "$grpc_retry_delay"
append_flag   "--rpc" "$rpc"
append_option "--rpc-host" "$rpc_host"
append_option "--rpc-port" "$rpc_port"
append_option "--tls-cert" "$tls_cert"

# Proposer Options
append_flag   "--enable-builder" "$enable_builder"
append_flag   "--enable-validator-registration" "$enable_validator_registration"
append_option "--graffiti" "$graffiti"
append_option "--graffiti-file" "$graffiti_file"
append_option "--proposer-settings-file" "$proposer_settings_file"
append_option "--proposer-settings-url" "$proposer_settings_url"
append_option "--suggested-fee-recipient" "$suggested_fee_recipient"
append_option "--suggested-gas-limit" "$suggested_gas_limit"
append_option "--validators-registration-batch-size" "$validators_registration_batch_size"

# Remote Signer Options
append_option "--validators-external-signer-key-file" "$validators_external_signer_key_file"
append_option "--validators-external-signer-public-keys" "$validators_external_signer_public_keys"
append_option "--validators-external-signer-url" "$validators_external_signer_url"

# Slasher Options
append_option "--slasher-rpc-provider" "$slasher_rpc_provider"
append_option "--slasher-tls-cert" "$slasher_tls_cert"

# Misc Options
append_flag   "--disable-account-metrics" "$disable_account_metrics"
append_flag   "--disable-rewards-penalties-logging" "$disable_rewards_penalties_logging"
append_flag   "--distributed" "$distributed"
append_option "--keymanager-token-file" "$keymanager_token_file"
append_flag   "--web" "$web"

# Features Options
append_flag   "--attest-timely" "$attest_timely"
append_option "--dynamic-key-reload-debounce-interval" "$dynamic_key_reload_debounce_interval"
append_flag   "--enable-beacon-rest-api" "$enable_beacon_rest_api"
append_flag   "--enable-doppelganger" "$enable_doppelganger"
append_flag   "--enable-minimal-slashing-protection" "$enable_minimal_slashing_protection"
append_flag   "--enable-slashing-protection-history-pruning" "$enable_slashing_protection_history_pruning"
append_flag   "--holesky" "$holesky"
append_flag   "--mainnet" "$mainnet"
append_flag   "--sepolia" "$sepolia"
append_flag   "--write-wallet-password-on-web-onboarding" "$write_wallet_password_on_web_onboarding"


echo "Importing validator accounts: /usr/lib/eth-node-prysm/bin/validator accounts import --keys-dir=$wallet_keystore --wallet-dir=$wallet_dir --wallet-password-file=$wallet_password_file --account-password-file=$account_password_file" 

/usr/lib/eth-node-prysm/bin/validator accounts import --keys-dir="$wallet_keystore" \
                                    --wallet-dir="$wallet_dir" \
                                    --wallet-password-file="$wallet_password_file" \
                                    --account-password-file="$account_password_file" \
                                    --accept-terms-of-use

echo "Using Options  /usr/lib/eth-node-prysm/bin/validator: $OPTIONS"

# TODO 
/usr/lib/eth-node-prysm/bin/validator $OPTIONS