name = "eth-node-nimbus-eth2-validator-regtest"
bin_package = "eth-node-nimbus-eth2"
binary = "/usr/lib/eth-node-nimbus-eth2/bin/nimbus_validator_client"
conf_param = "--beacon-node='http://localhost:5052' --config-file="
user = { name = "eth-node-nimbus-eth2-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "network.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-nimbus-eth2-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/nimbus-eth2-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/nimbus-eth2-validator

# Standard output and error handling
StandardOutput=append:/var/logs/eth-node-regtest/nimbus-eth2-validator/nimbus-eth2-validator.log
StandardError=append:/var/logs/eth-node-regtest/nimbus-eth2-validator/nimbus-eth2-validator.error.log

# Logging options
SyslogIdentifier=nimbus-eth2-val-regtest
LogRateLimitIntervalSec=0
LogRateLimitBurst=0

ExecStartPre=/bin/mkdir -p /var/logs/eth-node-regtest/nimbus-eth2-validator
ExecStartPre=/bin/chown eth-node-nimbus-eth2-val-regtest:eth-node-nimbus-eth2-val-regtest /var/logs/eth-node-regtest/nimbus-eth2-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/postprocess.sh /usr/lib/eth-node-nimbus-eth2-validator-regtest",
    "debian/tmp/eth-node-nimbus-eth2-validator-regtest.service /lib/systemd/system/",
    # only included as reference for now, as secrets and validators are generated seperately 
    "debian/validator/keys /var/lib/eth-node-regtest/nimbus-eth2-validator",
    "debian/validator/validators /var/lib/eth-node-regtest/nimbus-eth2-validator",
    "debian/validator/secrets /var/lib/eth-node-regtest/nimbus-eth2-validator",
]
provides = ["eth-node-validator-service-regtest"]
conflicts = ["eth-node-validator-service-regtest"]
depends=["eth-node-regtest-cl-service"]
summary = "validator service file for eth-node-nimbus-eth2 for network: regtest"

[config."nimbus-eth2-validator.toml".postprocess]
command = ["bash", "/usr/lib/eth-node-nimbus-eth2-validator-regtest/postprocess.sh"]


[config."nimbus-eth2-validator.toml".hvars."DATA_DIR"]
type = "string"
constant = "/var/lib/eth-node-regtest"
store = false

[config."nimbus-eth2-validator.toml".hvars."JWT_FILE"]
type = "path"
file_type = "regular"
constant = "/etc/eth-node-regtest/jwt.hex"
store = false

[config."nimbus-eth2-validator.toml".hvars."NETWORK_ID"]
type = "string"
constant = "1337"
store = false

[config."nimbus-eth2-validator.toml".hvars."TESTNET_DIR"]
type = "string"
constant = "/var/lib/eth-node-regtest/regtest/genesis"
store = false

[config."nimbus-eth2-validator.toml".hvars."EL_RPC_PORT"]
type = "string"
constant = "8545"
store = false

[config."nimbus-eth2-validator.toml".hvars."ENGINE_IP"]
type = "string"
constant = "127.0.0.1"
store = false

[config."nimbus-eth2-validator.toml".hvars."LOG_DIR"]
type = "string"
constant = "/var/logs/eth-node-regtest"
# priority = "low"
ignore_empty = true
# summary = "Base dir for logging"
store = false


[config."nimbus-eth2-validator.toml".hvars."ENGINE_API_PORT"]
type = "string"
constant = "8551"
store = false
# priority = "low"
ignore_empty = true
# summary = "Port for Execution Layer (EL) and Consensus Layer (CL) communication"

[config."nimbus-eth2-validator.toml".hvars."ENGINE_SCHEME"]
type = "string"
constant = "http"
store = false
# priority = "low"
# summary = "Scheme for EL and CL communication"

[config."nimbus-eth2-validator.toml".hvars."ENGINE_HOST"]
type = "string"
constant = "localhost"
store = false
# priority = "low"
# summary = "Host for EL and CL communication"


[config."nimbus-eth2-validator.toml".hvars."ENDPOINT_URL"]
type = "string"
template = "{/ENGINE_SCHEME}://{/ENGINE_HOST}:{/ENGINE_API_PORT}"
# priority = "low"
ignore_empty = true
# summary = "Base dir for logging"
store = false


[config."nimbus-eth2-validator.toml".hvars."CL_RPC_PORT"]
type = "string"
constant = "5052"
# priority = "low"
ignore_empty = true
# summary = "Base dir for logging"
store = false 

[config."nimbus-eth2-validator.toml".hvars."VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"]
type = "string"
template = "0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73"
store = false 
# priority = "low"
ignore_empty = true
# summary = "Shared fee recipient address for validator"

[config."nimbus-eth2-validator.toml"]
format = "toml"

[config."nimbus-eth2-validator.toml".hvars."data-dir"]
type = "string"
template = "{/DATA_DIR}/nimbus-eth2-validator"
# priority = "low"
ignore_empty = true
# summary = "The directory where Nimbus will store all blockchain data."

[config."nimbus-eth2-validator.toml".hvars."validators-dir"]
type = "string"
template = "{/DATA_DIR}/nimbus-eth2-validator/validators"
# priority = "low"
ignore_empty = true
# summary = "A directory containing validator keystores."

[config."nimbus-eth2-validator.toml".hvars."secrets-dir"]
type = "string"
template = "{/DATA_DIR}/nimbus-eth2-validator/secrets"
# priority = "low"
ignore_empty = true
# summary = "A directory containing validator keystore passwords."

# TODO array format
# [config."nimbus-eth2-validator.toml".ivars."beacon-node"]
# type = "string"
# default = "http://127.0.0.1:5052"
# priority = "low"
# ignore_empty = true
# summary = "URL addresses to one or more beacon node HTTP REST APIs [=$defaultBeaconNodeUri]."

[config."nimbus-eth2-validator.toml".hvars."suggested-fee-recipient"]
type = "string"
template = "{/VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS}"
# priority = "low"
ignore_empty = true
# summary = "Suggested fee recipient."

# [config."nimbus-eth2-validator.toml".ivars."log_file"]
# type = "string"
# default = "$LOG_DIR/nimbus-eth2-validator/nimbus-eth2.log"
# priority = "low"
# ignore_empty = true
# summary = "Specifies a path for the written JSON log file (deprecated)."

#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################

# [config."nimbus-eth2-validator.toml".ivars."config_file"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Loads the configuration from a TOML file."

[config."nimbus-eth2-validator.toml".ivars."log_level"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the log level [=INFO]."

# [config."nimbus-eth2-validator.toml".ivars."log_file"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Specifies a path for the written JSON log file (deprecated)."

# [config."nimbus-eth2-validator.toml".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "The directory where Nimbus will store all blockchain data."

[config."nimbus-eth2-validator.toml".ivars."doppelganger_detection"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "If enabled, the validator client prudently listens for 2 epochs for attestations from a validator with the same index (a doppelganger), before sending an attestation itself."

[config."nimbus-eth2-validator.toml".ivars."non_interactive"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Do not display interactive prompts. Quit on missing configuration."

# [config."nimbus-eth2-validator.toml".ivars."validators_dir"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "A directory containing validator keystores."

[config."nimbus-eth2-validator.toml".ivars."verifying_web3_signer_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Remote Web3Signer URL that will be used as a source of validators."

[config."nimbus-eth2-validator.toml".ivars."proven_block_property"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The field path of a block property that will be sent for verification to the verifying Web3Signer."

[config."nimbus-eth2-validator.toml".ivars."web3_signer_update_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of seconds between validator list updates [=3600]."

[config."nimbus-eth2-validator.toml".ivars."web3_signer_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Remote Web3Signer URL that will be used as a source of validators."

# [config."nimbus-eth2-validator.toml".ivars."secrets_dir"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "A directory containing validator keystore passwords."

[config."nimbus-eth2-validator.toml".ivars."rest_request_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The number of seconds to wait until complete REST request will be received [=infinite]."

[config."nimbus-eth2-validator.toml".ivars."rest_max_body_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum size of REST request body (kilobytes) [=16384]."

[config."nimbus-eth2-validator.toml".ivars."rest_max_headers_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum size of REST request headers (kilobytes) [=64]."

# [config."nimbus-eth2-validator.toml".ivars."suggested_fee_recipient"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Suggested fee recipient."

[config."nimbus-eth2-validator.toml".ivars."suggested_gas_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Suggested gas limit [=defaultGasLimit]."

[config."nimbus-eth2-validator.toml".ivars."keymanager"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable the REST keymanager API [=false]."

[config."nimbus-eth2-validator.toml".ivars."keymanager_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening port for the REST keymanager API [=5052]."

[config."nimbus-eth2-validator.toml".ivars."keymanager_address"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening address for the REST keymanager API [=127.0.0.1]."

[config."nimbus-eth2-validator.toml".ivars."keymanager_allow_origin"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Limit the access to the Keymanager API to a particular hostname (for CORS-enabled clients such as browsers)."

[config."nimbus-eth2-validator.toml".ivars."keymanager_token_file"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "A file specifying the authorization token required for accessing the keymanager API."

[config."nimbus-eth2-validator.toml".ivars."metrics"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable the metrics server (BETA) [=false]."

[config."nimbus-eth2-validator.toml".ivars."metrics_address"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening address of the metrics server (BETA) [=127.0.0.1]."

[config."nimbus-eth2-validator.toml".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening HTTP port of the metrics server (BETA) [=8108]."

[config."nimbus-eth2-validator.toml".ivars."graffiti"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The graffiti value that will appear in proposed blocks. You can use a 0x-prefixed hex encoded string to specify raw bytes."

[config."nimbus-eth2-validator.toml".ivars."debug_stop_at_epoch"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "A positive epoch selects the epoch at which to stop [=0]."

[config."nimbus-eth2-validator.toml".ivars."payload_builder"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable usage of beacon node with external payload builder (BETA) [=false]."

[config."nimbus-eth2-validator.toml".ivars."distributed"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable usage of Obol middleware (BETA) [=false]."

[config."nimbus-eth2-validator.toml".ivars."builder_boost_factor"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Percentage multiplier to apply to the builder's payload value when choosing between a builder payload header and payload from the paired execution node [=100]."

# [config."nimbus-eth2-validator.toml".ivars."beacon_node"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "URL addresses to one or more beacon node HTTP REST APIs [=$defaultBeaconNodeUri]."

[config."nimbus-eth2-validator.toml".ivars."block_monitor_type"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable block monitoring which are seen by beacon node (BETA) [=BlockMonitoringType.Event]."
