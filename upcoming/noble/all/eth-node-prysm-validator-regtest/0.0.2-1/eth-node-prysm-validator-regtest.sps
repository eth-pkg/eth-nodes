name = "eth-node-prysm-validator-regtest"
bin_package = "eth-node-prysm"
binary = "/usr/lib/eth-node-prysm-validator-regtest/run-prysm-validator-service.sh"
user = { name = "eth-node-prysm-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-prysm-val-regtest
# NoNewPrivileges=true
# ProtectHome=true
# PrivateTmp=true
# PrivateDevices=true

# additional flags not specified by debcrafter
CapabilityBoundingSet=
IPAddressDeny=none
LockPersonality=true
PrivateIPC=true
PrivateUsers=true
ProtectClock=true
ProtectControlGroups=true
ProtectHostname=true
ProtectKernelLogs=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectProc=invisible
ReadWritePaths=/var/lib/eth-node-regtest/prysm-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/prysm-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-prysm-validator-service.sh /usr/lib/eth-node-prysm-validator-regtest/", 
    "debian/scripts/run-prysm-validator.sh /usr/lib/eth-node-prysm-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-prysm-validator-regtest",
    "debian/tmp/eth-node-prysm-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/prysm-validator",
    "debian/validator/passwords /var/lib/eth-node-regtest/prysm-validator",
    "debian/validator/dummy_account_password.txt /var/lib/eth-node-regtest/prysm-validator",
    "debian/validator/dummy_wallet_password.txt /var/lib/eth-node-regtest/prysm-validator",
]
provides = ["eth-node-validator-service-regtest"]
conflicts = ["eth-node-validator-service-regtest"]
depends=["eth-node-regtest-cl-service"]
summary = "validator service file for eth-node-prysm for network: regtest"

[config."prysm-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-prysm-validator-regtest/postprocess.sh"]

[config."prysm-validator.conf"]
format = "plain"

[config."prysm-validator.conf".ivars."datadir"]
type = "string"
default = "$DATA_DIR/prysm-validator"
priority = "low"
summary = "Data directory for the databases."

[config."prysm-validator.conf".ivars."accept_terms_of_use"]
type = "string"
default = "true"
priority = "low"
summary = "Accepts Terms and Conditions (for non-interactive environments). (default: false)"

[config."prysm-validator.conf".ivars."wallet_dir"]
type = "string"
default = "$DATA_DIR/prysm-validator"
priority = "low"
summary = "Path to a wallet directory on-disk for Prysm validator accounts. (default: \"$HOME/.eth2validators/prysm-wallet-v2\")"

[config."prysm-validator.conf".ivars."wallet_password_file"]
type = "string"
default = "$DATA_DIR/prysm-validator/dummy_wallet_password.txt"
priority = "low"
summary = "Path to a plain-text, .txt file containing your wallet password."


[config."prysm-validator.conf".ivars."account_password_file"]
type = "string"
default = "$DATA_DIR/prysm-validator/passwords/keystore-m_12381_3600_0_0_0-1726217560.txt"
priority = "low"
summary = ""

[config."prysm-validator.conf".ivars."wallet_keystore"]
type = "string"
default = "$DATA_DIR/prysm-validator/keys"
priority = "low"
summary = ""

[config."prysm-validator.conf".ivars."chain_config_file"]
type = "string"
default = "$TESTNET_DIR/config.yaml"
priority = "low"
summary = "Path to a YAML file with chain config values."

[config."prysm-validator.conf".ivars."suggested_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = "Sets ALL validators' mapping to a suggested eth address to receive gas fees when proposing a block. This is a suggestion when integrating with a Builder API. (default: \"0x0000000000000000000000000000000000000000\")"

[config."prysm-validator.conf".ivars."log_file"]
type = "string"
default = "$LOG_DIR/prysm-validator/prysm.log"
priority = "low"
summary = "Specifies log file name, relative or absolute."


#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################


### cmd options 

# [config."prysm-validator.conf".ivars."accept_terms_of_use"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Accepts Terms and Conditions (for non-interactive environments). (default: false)"

[config."prysm-validator.conf".ivars."api_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the timeout value for API requests in seconds. (default: 120)"

# [config."prysm-validator.conf".ivars."chain_config_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to a YAML file with chain config values."

[config."prysm-validator.conf".ivars."clear_db"]
type = "string"
default = ""
priority = "low"
summary = "Prompt for clearing any previously stored data at the data directory. (default: false)"

[config."prysm-validator.conf".ivars."config_file"]
type = "string"
default = ""
priority = "low"
summary = "Filepath to a yaml file with flag values."

# [config."prysm-validator.conf".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Data directory for the databases. (default: \"$HOME/.eth2\")"

[config."prysm-validator.conf".ivars."db_backup_output_dir"]
type = "string"
default = ""
priority = "low"
summary = "Output directory for db backups."

[config."prysm-validator.conf".ivars."disable_monitoring"]
type = "string"
default = ""
priority = "low"
summary = "Disables monitoring service. (default: false)"

[config."prysm-validator.conf".ivars."e2e_config"]
type = "string"
default = ""
priority = "low"
summary = "Enables the E2E testing config, only for use within end-to-end testing. (default: false)"

[config."prysm-validator.conf".ivars."enable_db_backup_webhook"]
type = "string"
default = ""
priority = "low"
summary = "Serves HTTP handler to initiate database backups. The handler is served on the monitoring port at path /db/backup. (default: false)"

[config."prysm-validator.conf".ivars."enable_tracing"]
type = "string"
default = ""
priority = "low"
summary = "Enables request tracing. (default: false)"

[config."prysm-validator.conf".ivars."force_clear_db"]
type = "string"
default = ""
priority = "low"
summary = "Clears any previously stored data at the data directory. (default: false)"

[config."prysm-validator.conf".ivars."grpc_max_msg_size"]
type = "string"
default = ""
priority = "low"
summary = "Integer to define max receive message call size (in bytes). Validators with as many as 10000 keys can be run with a max message size of less than 50Mb. The default is set to a high value for local users. (default: 2147483647)"

# [config."prysm-validator.conf".ivars."log_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Specifies log file name, relative or absolute."

[config."prysm-validator.conf".ivars."log_format"]
type = "string"
default = ""
priority = "low"
summary = "Specifies log formatting. Supports: text, json, fluentd, journald. (default: \"text\")"

[config."prysm-validator.conf".ivars."minimal_config"]
type = "string"
default = ""
priority = "low"
summary = "Uses minimal config with parameters as defined in the spec. (default: false)"

[config."prysm-validator.conf".ivars."monitoring_host"]
type = "string"
default = ""
priority = "low"
summary = "Host used for listening and responding metrics for prometheus. (default: \"127.0.0.1\")"

[config."prysm-validator.conf".ivars."monitoring_port"]
type = "string"
default = ""
priority = "low"
summary = "Port used to listen and respond metrics for Prometheus. (default: 8081)"

[config."prysm-validator.conf".ivars."trace_sample_fraction"]
type = "string"
default = ""
priority = "low"
summary = "Indicates what fraction of p2p messages are sampled for tracing. (default: 0.2)"

[config."prysm-validator.conf".ivars."tracing_endpoint"]
type = "string"
default = ""
priority = "low"
summary = "Tracing endpoint defines where beacon chain traces are exposed to Jaeger. (default: \"http://127.0.0.1:14268/api/traces\")"

[config."prysm-validator.conf".ivars."tracing_process_name"]
type = "string"
default = ""
priority = "low"
summary = "Name to apply to tracing tag process_name."

[config."prysm-validator.conf".ivars."verbosity"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity. (trace, debug, info, warn, error, fatal, panic) (default: \"info\")"

# [config."prysm-validator.conf".ivars."wallet_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to a wallet directory on-disk for Prysm validator accounts. (default: \"$HOME/.eth2validators/prysm-wallet-v2\")"

# [config."prysm-validator.conf".ivars."wallet_password_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to a plain-text, .txt file containing your wallet password."


#### debug options 
[config."prysm-validator.conf".ivars."blockprofilerate"]
type = "string"
default = ""
priority = "low"
summary = "Turns on block profiling with the given rate. (default: 0)"

[config."prysm-validator.conf".ivars."cpuprofile"]
type = "string"
default = ""
priority = "low"
summary = "Writes CPU profile to the given file."

[config."prysm-validator.conf".ivars."memprofilerate"]
type = "string"
default = ""
priority = "low"
summary = "Turns on memory profiling with the given rate. (default: 524288)"

[config."prysm-validator.conf".ivars."mutexprofilefraction"]
type = "string"
default = ""
priority = "low"
summary = "Turns on mutex profiling with the given rate. (default: 0)"

[config."prysm-validator.conf".ivars."pprof"]
type = "string"
default = ""
priority = "low"
summary = "Enables the pprof HTTP server. (default: false)"

[config."prysm-validator.conf".ivars."pprofaddr"]
type = "string"
default = ""
priority = "low"
summary = "pprof HTTP server listening interface. (default: \"127.0.0.1\")"

[config."prysm-validator.conf".ivars."pprofport"]
type = "string"
default = ""
priority = "low"
summary = "pprof HTTP server listening port. (default: 6060)"

[config."prysm-validator.conf".ivars."trace"]
type = "string"
default = ""
priority = "low"
summary = "Writes execution trace to the given file."


###### rpc options

[config."prysm-validator.conf".ivars."beacon_rest_api_provider"]
type = "string"
default = ""
priority = "low"
summary = "Beacon node REST API provider endpoint. (default: \"http://127.0.0.1:3500\")"

[config."prysm-validator.conf".ivars."beacon_rpc_gateway_provider"]
type = "string"
default = ""
priority = "low"
summary = "Beacon node RPC gateway provider endpoint. (default: \"127.0.0.1:3500\")"

[config."prysm-validator.conf".ivars."beacon_rpc_provider"]
type = "string"
default = ""
priority = "low"
summary = "Beacon node RPC provider endpoint. (default: \"127.0.0.1:4000\")"

[config."prysm-validator.conf".ivars."grpc_gateway_corsdomain"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of domains from which to accept cross origin requests (browser enforced). This flag has no effect if not used with --grpc-gateway-port. (default: \"http://localhost:7500,http://127.0.0.1:7500,http://0.0.0.0:7500,...\")"

[config."prysm-validator.conf".ivars."grpc_gateway_host"]
type = "string"
default = ""
priority = "low"
summary = "Host on which the gateway server runs on. (default: \"127.0.0.1\")"

[config."prysm-validator.conf".ivars."grpc_gateway_port"]
type = "string"
default = ""
priority = "low"
summary = "Enables gRPC gateway for JSON requests. (default: 7500)"

[config."prysm-validator.conf".ivars."grpc_headers"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of key value pairs to pass as gRPC headers for all gRPC calls. Example: --grpc-headers=key=value"

[config."prysm-validator.conf".ivars."grpc_retries"]
type = "string"
default = ""
priority = "low"
summary = "Number of attempts to retry gRPC requests. (default: 5)"

[config."prysm-validator.conf".ivars."grpc_retry_delay"]
type = "string"
default = ""
priority = "low"
summary = "Amount of time between gRPC retry requests. (default: 1s)"

[config."prysm-validator.conf".ivars."rpc"]
type = "string"
default = ""
priority = "low"
summary = "Enables the RPC server for the validator client (without Web UI). (default: false)"

[config."prysm-validator.conf".ivars."rpc_host"]
type = "string"
default = ""
priority = "low"
summary = "Host on which the RPC server should listen. (default: \"127.0.0.1\")"

[config."prysm-validator.conf".ivars."rpc_port"]
type = "string"
default = ""
priority = "low"
summary = "RPC port exposed by a validator client. (default: 7000)"

[config."prysm-validator.conf".ivars."tls_cert"]
type = "string"
default = ""
priority = "low"
summary = "Certificate for secure gRPC. Pass this and the tls-key flag in order to use gRPC securely."


#### proposer options
[config."prysm-validator.conf".ivars."enable_builder"]
type = "string"
default = ""
priority = "low"
summary = "Enables builder validator registration APIs for the validator client to update settings such as fee recipient and gas limit. This flag is not required if using proposer settings config file. (default: false)"

[config."prysm-validator.conf".ivars."enable_validator_registration"]
type = "string"
default = ""
priority = "low"
summary = "Enables builder validator registration APIs for the validator client to update settings such as fee recipient and gas limit. This flag is not required if using proposer settings config file. (default: false)"

[config."prysm-validator.conf".ivars."graffiti"]
type = "string"
default = ""
priority = "low"
summary = "String to include in proposed blocks."

[config."prysm-validator.conf".ivars."graffiti_file"]
type = "string"
default = ""
priority = "low"
summary = "Path to a YAML file with graffiti values."

[config."prysm-validator.conf".ivars."proposer_settings_file"]
type = "string"
default = ""
priority = "low"
summary = "Sets path to a YAML or JSON file containing validator settings used when proposing blocks such as fee recipient and gas limit. File format found in docs."

[config."prysm-validator.conf".ivars."proposer_settings_url"]
type = "string"
default = ""
priority = "low"
summary = "Sets URL to a REST endpoint containing validator settings used when proposing blocks such as fee recipient and gas limit. File format found in docs."

# [config."prysm-validator.conf".ivars."suggested_fee_recipient"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Sets ALL validators' mapping to a suggested eth address to receive gas fees when proposing a block. This is a suggestion when integrating with a Builder API. (default: \"0x0000000000000000000000000000000000000000\")"

[config."prysm-validator.conf".ivars."suggested_gas_limit"]
type = "string"
default = ""
priority = "low"
summary = "Sets gas limit for the builder to use for constructing a payload for all the validators. (default: 30000000)"

[config."prysm-validator.conf".ivars."validators_registration_batch_size"]
type = "string"
default = ""
priority = "low"
summary = "Sets the maximum size for one batch of validator registrations. Use a non-positive value to disable batching. (default: 0)"


#### remote signer options

[config."prysm-validator.conf".ivars."validators_external_signer_key_file"]
type = "string"
default = ""
priority = "low"
summary = "A file path used to load remote public validator keys and persist them through restarts."

[config."prysm-validator.conf".ivars."validators_external_signer_public_keys"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of public keys OR an external URL endpoint for the validator to retrieve public keys from for usage with web3signer."

[config."prysm-validator.conf".ivars."validators_external_signer_url"]
type = "string"
default = ""
priority = "low"
summary = "URL for ConsenSys' web3signer software to use with the Prysm validator client."


#### slasher options

[config."prysm-validator.conf".ivars."slasher_rpc_provider"]
type = "string"
default = ""
priority = "low"
summary = "Slasher node RPC provider endpoint. (default: \"127.0.0.1:4002\")"

[config."prysm-validator.conf".ivars."slasher_tls_cert"]
type = "string"
default = ""
priority = "low"
summary = "Certificate for secure slasher gRPC. Pass this and the tls-key flag in order to use gRPC securely."


#### misc options

[config."prysm-validator.conf".ivars."disable_account_metrics"]
type = "string"
default = ""
priority = "low"
summary = "Disables prometheus metrics for validator accounts. Operators with high volumes of validating keys may wish to disable granular prometheus metrics as it increases data cardinality. (default: false)"

[config."prysm-validator.conf".ivars."disable_rewards_penalties_logging"]
type = "string"
default = ""
priority = "low"
summary = "Disables reward/penalty logging during cluster deployment. (default: false)"

[config."prysm-validator.conf".ivars."distributed"]
type = "string"
default = ""
priority = "low"
summary = "Enables the use of prysm validator client in Distributed Validator Cluster. (default: false)"

[config."prysm-validator.conf".ivars."keymanager_token_file"]
type = "string"
default = ""
priority = "low"
summary = "Path to auth token file used for validator APIs. (default: \"$HOME/.eth2validators/prysm-wallet-v2/auth-token\")"

[config."prysm-validator.conf".ivars."web"]
type = "string"
default = ""
priority = "low"
summary = "(Work in progress): Enables the web portal for the validator client. (default: false)"


#### feature options

[config."prysm-validator.conf".ivars."attest_timely"]
type = "string"
default = ""
priority = "low"
summary = "Fixes validator can attest timely after current block processes. (default: false)"

[config."prysm-validator.conf".ivars."dynamic_key_reload_debounce_interval"]
type = "string"
default = ""
priority = "low"
summary = "(Advanced): Specifies the time duration the validator waits to reload new keys if they have changed on disk. (default: 1s)"

[config."prysm-validator.conf".ivars."enable_beacon_rest_api"]
type = "string"
default = ""
priority = "low"
summary = "(Experimental): Enables the beacon REST API when querying a beacon node. (default: false)"

[config."prysm-validator.conf".ivars."enable_doppelganger"]
type = "string"
default = ""
priority = "low"
summary = "Enables the validator to perform a doppelganger check. (default: false)"

[config."prysm-validator.conf".ivars."enable_minimal_slashing_protection"]
type = "string"
default = ""
priority = "low"
summary = "(Experimental): Enables minimal slashing protection. See EIP-3076 for more details. (default: false)"

[config."prysm-validator.conf".ivars."enable_slashing_protection_history_pruning"]
type = "string"
default = ""
priority = "low"
summary = "Enables the pruning of the validator client's slashing protection database. (default: false)"

[config."prysm-validator.conf".ivars."holesky"]
type = "string"
default = ""
priority = "low"
summary = "Runs Prysm configured for the Holesky test network. (default: false)"

[config."prysm-validator.conf".ivars."mainnet"]
type = "string"
default = ""
priority = "low"
summary = "Runs on Ethereum main network. (default: true)"

[config."prysm-validator.conf".ivars."sepolia"]
type = "string"
default = ""
priority = "low"
summary = "Runs Prysm configured for the Sepolia test network. (default: false)"

[config."prysm-validator.conf".ivars."write_wallet_password_on_web_onboarding"]
type = "string"
default = ""
priority = "low"
summary = "(Danger): Writes the wallet password to the wallet directory on completing Prysm web onboarding. (default: false)"


#### interop options

[config."prysm-validator.conf".ivars."interop_num_validators"]
type = "string"
default = ""
priority = "low"
summary = "Number of validators to deterministically generate. (default: 0)"

[config."prysm-validator.conf".ivars."interop_start_index"]
type = "string"
default = ""
priority = "low"
summary = "Start index to deterministically generate validator keys when used in combination with --interop-num-validators. (default: 0)"
