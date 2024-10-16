name = "eth-node-nimbus-eth2-validator-regtest"
bin_package = "eth-node-nimbus-eth2"
binary = "/usr/lib/eth-node-nimbus-eth2-validator-regtest/run-nimbus-eth2-validator-service.sh"
user = { name = "eth-node-nimbus-eth2-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
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
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-nimbus-eth2-validator-service.sh /usr/lib/eth-node-nimbus-eth2-validator-regtest/", 
    "debian/scripts/run-nimbus-eth2-validator.sh /usr/lib/eth-node-nimbus-eth2-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-nimbus-eth2-validator-regtest",
    "debian/tmp/eth-node-nimbus-eth2-validator-regtest.service /lib/systemd/system/",
    # only included as reference for now, as secrets and validators are generated seperately 
    "debian/validator/keys /var/lib/eth-node-regtest/nimbus-eth2-validator",
    "debian/validator/validators /var/lib/eth-node-regtest/nimbus-eth2-validator",
    "debian/validator/secrets /var/lib/eth-node-regtest/nimbus-eth2-validator",
]
provides = ["eth-node-regtest-validator"]
conflicts = ["eth-node-regtest-validator"]
depends=["eth-node-regtest-cl-service"]
summary = "validator service file for eth-node-nimbus-eth2 for network: regtest"

[config."nimbus-eth2-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-nimbus-eth2-validator-regtest/postprocess.sh"]

[config."nimbus-eth2-validator.conf"]
format = "plain"

[config."nimbus-eth2-validator.conf".ivars."datadir"]
type = "string"
default = "$DATA_DIR/nimbus-eth2-validator"
priority = "low"
summary = "The directory where Nimbus will store all blockchain data."

[config."nimbus-eth2-validator.conf".ivars."validators_dir"]
type = "string"
default = "$DATA_DIR/nimbus-eth2-validator/validators"
priority = "low"
summary = "A directory containing validator keystores."

[config."nimbus-eth2-validator.conf".ivars."secrets_dir"]
type = "string"
default = "$DATA_DIR/nimbus-eth2-validator/secrets"
priority = "low"
summary = "A directory containing validator keystore passwords."

[config."nimbus-eth2-validator.conf".ivars."beacon_node"]
type = "string"
default = "http://127.0.0.1:5052"
priority = "low"
summary = "URL addresses to one or more beacon node HTTP REST APIs [=$defaultBeaconNodeUri]."

[config."nimbus-eth2-validator.conf".ivars."suggested_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = "Suggested fee recipient."

#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################

[config."nimbus-eth2-validator.conf".ivars."config_file"]
type = "string"
default = ""
priority = "low"
summary = "Loads the configuration from a TOML file."

[config."nimbus-eth2-validator.conf".ivars."log_level"]
type = "string"
default = ""
priority = "low"
summary = "Sets the log level [=INFO]."

[config."nimbus-eth2-validator.conf".ivars."log_file"]
type = "string"
default = ""
priority = "low"
summary = "Specifies a path for the written JSON log file (deprecated)."

# [config."nimbus-eth2-validator.conf".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The directory where Nimbus will store all blockchain data."

[config."nimbus-eth2-validator.conf".ivars."doppelganger_detection"]
type = "string"
default = ""
priority = "low"
summary = "If enabled, the validator client prudently listens for 2 epochs for attestations from a validator with the same index (a doppelganger), before sending an attestation itself."

[config."nimbus-eth2-validator.conf".ivars."non_interactive"]
type = "string"
default = ""
priority = "low"
summary = "Do not display interactive prompts. Quit on missing configuration."

# [config."nimbus-eth2-validator.conf".ivars."validators_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "A directory containing validator keystores."

[config."nimbus-eth2-validator.conf".ivars."verifying_web3_signer_url"]
type = "string"
default = ""
priority = "low"
summary = "Remote Web3Signer URL that will be used as a source of validators."

[config."nimbus-eth2-validator.conf".ivars."proven_block_property"]
type = "string"
default = ""
priority = "low"
summary = "The field path of a block property that will be sent for verification to the verifying Web3Signer."

[config."nimbus-eth2-validator.conf".ivars."web3_signer_update_interval"]
type = "string"
default = ""
priority = "low"
summary = "Number of seconds between validator list updates [=3600]."

[config."nimbus-eth2-validator.conf".ivars."web3_signer_url"]
type = "string"
default = ""
priority = "low"
summary = "Remote Web3Signer URL that will be used as a source of validators."

# [config."nimbus-eth2-validator.conf".ivars."secrets_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "A directory containing validator keystore passwords."

[config."nimbus-eth2-validator.conf".ivars."rest_request_timeout"]
type = "string"
default = ""
priority = "low"
summary = "The number of seconds to wait until complete REST request will be received [=infinite]."

[config."nimbus-eth2-validator.conf".ivars."rest_max_body_size"]
type = "string"
default = ""
priority = "low"
summary = "Maximum size of REST request body (kilobytes) [=16384]."

[config."nimbus-eth2-validator.conf".ivars."rest_max_headers_size"]
type = "string"
default = ""
priority = "low"
summary = "Maximum size of REST request headers (kilobytes) [=64]."

# [config."nimbus-eth2-validator.conf".ivars."suggested_fee_recipient"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Suggested fee recipient."

[config."nimbus-eth2-validator.conf".ivars."suggested_gas_limit"]
type = "string"
default = ""
priority = "low"
summary = "Suggested gas limit [=defaultGasLimit]."

[config."nimbus-eth2-validator.conf".ivars."keymanager"]
type = "string"
default = ""
priority = "low"
summary = "Enable the REST keymanager API [=false]."

[config."nimbus-eth2-validator.conf".ivars."keymanager_port"]
type = "string"
default = ""
priority = "low"
summary = "Listening port for the REST keymanager API [=5052]."

[config."nimbus-eth2-validator.conf".ivars."keymanager_address"]
type = "string"
default = ""
priority = "low"
summary = "Listening address for the REST keymanager API [=127.0.0.1]."

[config."nimbus-eth2-validator.conf".ivars."keymanager_allow_origin"]
type = "string"
default = ""
priority = "low"
summary = "Limit the access to the Keymanager API to a particular hostname (for CORS-enabled clients such as browsers)."

[config."nimbus-eth2-validator.conf".ivars."keymanager_token_file"]
type = "string"
default = ""
priority = "low"
summary = "A file specifying the authorization token required for accessing the keymanager API."

[config."nimbus-eth2-validator.conf".ivars."metrics"]
type = "string"
default = ""
priority = "low"
summary = "Enable the metrics server (BETA) [=false]."

[config."nimbus-eth2-validator.conf".ivars."metrics_address"]
type = "string"
default = ""
priority = "low"
summary = "Listening address of the metrics server (BETA) [=127.0.0.1]."

[config."nimbus-eth2-validator.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = "Listening HTTP port of the metrics server (BETA) [=8108]."

[config."nimbus-eth2-validator.conf".ivars."graffiti"]
type = "string"
default = ""
priority = "low"
summary = "The graffiti value that will appear in proposed blocks. You can use a 0x-prefixed hex encoded string to specify raw bytes."

[config."nimbus-eth2-validator.conf".ivars."debug_stop_at_epoch"]
type = "string"
default = ""
priority = "low"
summary = "A positive epoch selects the epoch at which to stop [=0]."

[config."nimbus-eth2-validator.conf".ivars."payload_builder"]
type = "string"
default = ""
priority = "low"
summary = "Enable usage of beacon node with external payload builder (BETA) [=false]."

[config."nimbus-eth2-validator.conf".ivars."distributed"]
type = "string"
default = ""
priority = "low"
summary = "Enable usage of Obol middleware (BETA) [=false]."

[config."nimbus-eth2-validator.conf".ivars."builder_boost_factor"]
type = "string"
default = ""
priority = "low"
summary = "Percentage multiplier to apply to the builder's payload value when choosing between a builder payload header and payload from the paired execution node [=100]."

# [config."nimbus-eth2-validator.conf".ivars."beacon_node"]
# type = "string"
# default = ""
# priority = "low"
# summary = "URL addresses to one or more beacon node HTTP REST APIs [=$defaultBeaconNodeUri]."

[config."nimbus-eth2-validator.conf".ivars."block_monitor_type"]
type = "string"
default = ""
priority = "low"
summary = "Enable block monitoring which are seen by beacon node (BETA) [=BlockMonitoringType.Event]."
