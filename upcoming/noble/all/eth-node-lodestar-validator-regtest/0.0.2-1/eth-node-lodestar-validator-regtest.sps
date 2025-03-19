name = "eth-node-lodestar-validator-regtest"
bin_package = "eth-node-lodestar"
binary = "/usr/lib/eth-node-lodestar-validator-regtest/run-lodestar-validator-service.sh"
user = { name = "eth-node-lodestar-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-lodestar-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/lodestar-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
# SystemCallArchitectures=native
# SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/lodestar-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lodestar-validator-service.sh /usr/lib/eth-node-lodestar-validator-regtest/", 
    "debian/scripts/run-lodestar-validator.sh /usr/lib/eth-node-lodestar-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lodestar-validator-regtest",
    "debian/tmp/eth-node-lodestar-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/lodestar-validator",
    "debian/validator/passwords /var/lib/eth-node-regtest/lodestar-validator",
]
provides = ["eth-node-validator-service-regtest"]
conflicts = ["eth-node-validator-service-regtest"]
depends=["eth-node-regtest-cl-service"]
summary = "validator service file for eth-node-lodestar for network: regtest"

[config."lodestar-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lodestar-validator-regtest/postprocess.sh"]

[config."lodestar-validator.conf"]
format = "plain"


# [config."lodestar-validator.conf".ivars."validators_dir"]
# type = "string"
# default = "/var/lib/eth-node-regtest/lodestar-validator"
# priority = "low"
# summary = "Path to validators dir"

[config."lodestar-validator.conf".ivars."params_file"]
type = "string"
default = "$TESTNET_DIR/config.yaml"
priority = "low"
summary = "Network configuration file"

[config."lodestar-validator.conf".ivars."beacon_nodes"]
type = "string"
default = "http://127.0.0.1:$CL_RPC_PORT"
priority = "low"
summary = "Bootnodes for discv5 discovery"

[config."lodestar-validator.conf".ivars."use_produce_block_v3"]
type = "string"
default = "true"
priority = "low"
summary = "Enable/disable usage of produceBlockV3 for block production"


[config."lodestar-validator.conf".ivars."import_keystores"]
type = "string"
default = "$DATA_DIR/lodestar-validator/keys"
priority = "low"
summary = "Path(s) to a directory or single file path to validator keystores"


[config."lodestar-validator.conf".ivars."import_keystores_password"]
type = "string"
default = "$DATA_DIR/lodestar-validator/passwords/keystore-m_12381_3600_0_0_0-1728531488.txt"
priority = "low"
summary = "Path to a file with password to decrypt all keystores from importKeystores"


[config."lodestar-validator.conf".ivars."disable_keystores_thread_pool"]
type = "string"
default = "true"
priority = "low"
summary = "Disable the thread pool for keystore operations"


[config."lodestar-validator.conf".ivars."data_dir"]
type = "string"
default = "$DATA_DIR/lodestar-validator"
priority = "low"
summary = "Lodestar root data directory"


[config."lodestar-validator.conf".ivars."suggested_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = "Specify fee recipient default for collecting EL block fees and rewards"

[config."lodestar-validator.conf".ivars."log_file"]
type = "string"
default = "$LOG_DIR/lodestar-validator/lodestar.log"
priority = "low"
summary = "Path to output all logs to a persistent log file"


#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################

[config."lodestar-validator.conf".ivars."keymanager"]
type = "string"
default = ""
priority = "low"
summary = "Enable key manager API server"

[config."lodestar-validator.conf".ivars."keymanager_auth"]
type = "string"
default = ""
priority = "low"
summary = "Enable token bearer authentication for key manager API server"

[config."lodestar-validator.conf".ivars."keymanager_token_file"]
type = "string"
default = ""
priority = "low"
summary = "Path to file containing bearer token used for key manager API authentication"

[config."lodestar-validator.conf".ivars."keymanager_port"]
type = "string"
default = ""
priority = "low"
summary = "Set port for key manager API"

[config."lodestar-validator.conf".ivars."keymanager_address"]
type = "string"
default = ""
priority = "low"
summary = "Set host for key manager API"

[config."lodestar-validator.conf".ivars."keymanager_cors"]
type = "string"
default = ""
priority = "low"
summary = "Configures the Access-Control-Allow-Origin CORS header for key manager API"

[config."lodestar-validator.conf".ivars."builder"]
type = "string"
default = ""
priority = "low"
summary = "An alias for builder.selection default for the builder flow"

[config."lodestar-validator.conf".ivars."builder_selection"]
type = "string"
default = ""
priority = "low"
summary = "Builder block selection strategy"

[config."lodestar-validator.conf".ivars."builder_boost_factor"]
type = "string"
default = ""
priority = "low"
summary = "Percentage multiplier to boost or dampen builder block value for selection"

[config."lodestar-validator.conf".ivars."http_request_wire_format"]
type = "string"
default = ""
priority = "low"
summary = "Wire format to use in HTTP requests to beacon node"

[config."lodestar-validator.conf".ivars."http_response_wire_format"]
type = "string"
default = ""
priority = "low"
summary = "Preferred wire format for HTTP responses from beacon node"

[config."lodestar-validator.conf".ivars."external_signer_url"]
type = "string"
default = ""
priority = "low"
summary = "URL to connect to an external signing server"

[config."lodestar-validator.conf".ivars."external_signer_pubkeys"]
type = "string"
default = ""
priority = "low"
summary = "List of validator public keys used by an external signer"

[config."lodestar-validator.conf".ivars."external_signer_fetch"]
type = "string"
default = ""
priority = "low"
summary = "Fetch the list of public keys to validate from an external signer"

[config."lodestar-validator.conf".ivars."external_signer_fetch_interval"]
type = "string"
default = ""
priority = "low"
summary = "Interval in milliseconds between fetching the list of public keys from external signer"

[config."lodestar-validator.conf".ivars."metrics"]
type = "string"
default = ""
priority = "low"
summary = "Enable the Prometheus metrics HTTP server"

[config."lodestar-validator.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = "Listen TCP port for the Prometheus metrics HTTP server"

[config."lodestar-validator.conf".ivars."metrics_address"]
type = "string"
default = ""
priority = "low"
summary = "Listen address for the Prometheus metrics HTTP server"

[config."lodestar-validator.conf".ivars."monitoring_endpoint"]
type = "string"
default = ""
priority = "low"
summary = "Enables monitoring service for sending clients stats to a remote service"

[config."lodestar-validator.conf".ivars."monitoring_interval"]
type = "string"
default = ""
priority = "low"
summary = "Interval in milliseconds between sending client stats to the remote service"

# [config."lodestar-validator.conf".ivars."data_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Lodestar root data directory"

[config."lodestar-validator.conf".ivars."network"]
type = "string"
default = ""
priority = "low"
summary = "Name of the Ethereum Consensus chain network to join"

# [config."lodestar-validator.conf".ivars."params_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Network configuration file"

[config."lodestar-validator.conf".ivars."terminal_total_difficulty_override"]
type = "string"
default = ""
priority = "low"
summary = "Terminal PoW block TTD override"

[config."lodestar-validator.conf".ivars."terminal_block_hash_override"]
type = "string"
default = ""
priority = "low"
summary = "Terminal PoW block hash override"

[config."lodestar-validator.conf".ivars."terminal_block_hash_epoch_override"]
type = "string"
default = ""
priority = "low"
summary = "Terminal PoW block hash override activation epoch"

[config."lodestar-validator.conf".ivars."rc_config"]
type = "string"
default = ""
priority = "low"
summary = "RC file to supplement command line arguments"

[config."lodestar-validator.conf".ivars."log_level"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity level for emitting logs to terminal"

# [config."lodestar-validator.conf".ivars."log_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to output all logs to a persistent log file"

[config."lodestar-validator.conf".ivars."log_file_level"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity level for emitting logs to file"

[config."lodestar-validator.conf".ivars."log_file_daily_rotate"]
type = "string"
default = ""
priority = "low"
summary = "Daily rotate log files, set to an integer to limit the file count"

# [config."lodestar-validator.conf".ivars."beacon_nodes"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Addresses to connect to BeaconNode"

[config."lodestar-validator.conf".ivars."force"]
type = "string"
default = ""
priority = "low"
summary = "Open validators even if there's a lockfile"

[config."lodestar-validator.conf".ivars."graffiti"]
type = "string"
default = ""
priority = "low"
summary = "Specify custom graffiti to be included in blocks"

[config."lodestar-validator.conf".ivars."proposer_settings_file"]
type = "string"
default = ""
priority = "low"
summary = "A yaml file to specify customized proposer settings"

# [config."lodestar-validator.conf".ivars."suggested_fee_recipient"]
# type = "string"
# default = "0x0000000000000000000000000000000000000000"
# priority = "low"
# summary = "Specify fee recipient default for collecting EL block fees and rewards"

[config."lodestar-validator.conf".ivars."strict_fee_recipient_check"]
type = "string"
default = ""
priority = "low"
summary = "Enable strict checking of validator's feeRecipient with the one returned by engine"

[config."lodestar-validator.conf".ivars."default_gas_limit"]
type = "string"
default = ""
priority = "low"
summary = "Suggested gas limit to the engine/builder for building execution payloads"

# [config."lodestar-validator.conf".ivars."use_produce_block_v3"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Enable/disable usage of produceBlockV3 for block production"

[config."lodestar-validator.conf".ivars."broadcast_validation"]
type = "string"
default = ""
priority = "low"
summary = "Validations to be run by beacon node for the signed block prior to publishing"

[config."lodestar-validator.conf".ivars."blinded_local"]
type = "string"
default = ""
priority = "low"
summary = "Request fetching local block in blinded format for produceBlockV3"

# [config."lodestar-validator.conf".ivars."import_keystores"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path(s) to a directory or single file path to validator keystores"

# [config."lodestar-validator.conf".ivars."import_keystores_password"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to a file with password to decrypt all keystores from importKeystores"

[config."lodestar-validator.conf".ivars."doppelganger_protection_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enables Doppelganger protection"

[config."lodestar-validator.conf".ivars."distributed"]
type = "string"
default = ""
priority = "low"
summary = "Enables specific features required for distributed validation"



########################### Undocumented options #####################################################

[config."lodestar-validator.conf".ivars."keystores_dir"]
type = "string"
default = ""
priority = "low"
summary = "Path to the directory where validator keystores are stored"

[config."lodestar-validator.conf".ivars."secrets_dir"]
type = "string"
default = ""
priority = "low"
summary = "Path to the directory where validator secrets are stored"

# [config."lodestar-validator.conf".ivars."disable_keystores_thread_pool"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Disable the thread pool for keystore operations"
