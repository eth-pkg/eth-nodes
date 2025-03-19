name = "eth-node-lighthouse-validator-regtest"
bin_package = "eth-node-lighthouse"
binary = "/usr/lib/eth-node-lighthouse-validator-regtest/run-lighthouse-validator-service.sh"
user = { name = "eth-node-lighthouse-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-lighthouse-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/lighthouse-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/lighthouse-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lighthouse-validator-service.sh /usr/lib/eth-node-lighthouse-validator-regtest/", 
    "debian/scripts/run-lighthouse-validator.sh /usr/lib/eth-node-lighthouse-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lighthouse-validator-regtest",
    "debian/tmp/eth-node-lighthouse-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/lighthouse-validator",
    "debian/validator/password /var/lib/eth-node-regtest/lighthouse-validator",
    "debian/validator/validators /var/lib/eth-node-regtest/lighthouse-validator",
    "debian/validator/validator_definitions.yml /var/lib/eth-node-regtest/lighthouse-validator",
]
provides = ["eth-node-validator-service-regtest"]
conflicts = ["eth-node-validator-service-regtest"]
depends=["eth-node-regtest-cl-service"]
summary = "validator service file for eth-node-lighthouse for network: regtest"

[config."lighthouse-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lighthouse-validator-regtest/postprocess.sh"]

[config."lighthouse-validator.conf"]
format = "plain"


[config."lighthouse-validator.conf".ivars."testnet_dir"]
type = "string"
default = "$TESTNET_DIR"
priority = "low"
summary = "Path to directory containing Eth2 testnet specs."

[config."lighthouse-validator.conf".ivars."validators_dir"]
type = "string"
default = "$DATA_DIR/lighthouse-validator"
priority = "low"
summary = "Directory containing validator keystores, deposit data, and the slashing protection database."


[config."lighthouse-validator.conf".ivars."secrets_dir"]
type = "string"
default = "/var/lib/eth-node-regtest/lighthouse-validator/password"
priority = "low"
summary = "Directory containing passwords to unlock validator keypairs."


# [config."lighthouse-validator.conf".ivars."datadir"]
# type = "string"
# default = "/var/lib/eth-node-regtest/lighthouse-validator"
# priority = "low"
# summary = "Custom root data directory for Lighthouse keys and databases."


[config."lighthouse-validator.conf".ivars."init_slashing_protection"]
type = "string"
default = "true"
priority = "low"
summary = ""

[config."lighthouse-validator.conf".ivars."beacon_nodes"]
type = "string"
default = "http://localhost:5052"
priority = "low"
summary = "Comma-separated addresses of one or more beacon node HTTP APIs."


[config."lighthouse-validator.conf".ivars."suggested_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = "The address that will receive transaction fees post-merge."

[config."lighthouse-validator.conf".ivars."logfile"]
type = "string"
default = "$LOG_DIR/lighthouse-validator/lighthouse.log"
priority = "low"
summary = "File path where the log file will be stored."


#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################


[config."lighthouse-validator.conf".ivars."builder_proposals"]
type = "string"
default = ""
priority = "low"
summary = "If set, Lighthouse will query the Beacon Node for block headers during proposals and will sign over headers."

[config."lighthouse-validator.conf".ivars."disable_auto_discover"]
type = "string"
default = ""
priority = "low"
summary = "If set, Lighthouse will not attempt to auto-discover new validators in the validators-dir."

[config."lighthouse-validator.conf".ivars."disable_log_timestamp"]
type = "string"
default = ""
priority = "low"
summary = "If set, Lighthouse will not include timestamps in logging output."

[config."lighthouse-validator.conf".ivars."disable_malloc_tuning"]
type = "string"
default = ""
priority = "low"
summary = "If set, Lighthouse will not configure the system allocator, which may increase memory usage."

[config."lighthouse-validator.conf".ivars."disable_run_on_all"]
type = "string"
default = ""
priority = "low"
summary = "Deprecated. Use --broadcast instead."

[config."lighthouse-validator.conf".ivars."disable_slashing_protection_web3signer"]
type = "string"
default = ""
priority = "low"
summary = "Disables Lighthouse's slashing protection for all Web3Signer keys."

[config."lighthouse-validator.conf".ivars."distributed"]
type = "string"
default = ""
priority = "low"
summary = "Enables functionality for running the validator in a distributed validator cluster."

[config."lighthouse-validator.conf".ivars."enable_doppelganger_protection"]
type = "string"
default = ""
priority = "low"
summary = "If set, Lighthouse will delay startup for three epochs to check for messages by any validators on the network."

[config."lighthouse-validator.conf".ivars."enable_high_validator_count_metrics"]
type = "string"
default = ""
priority = "low"
summary = "Enable per-validator metrics for setups with more than 64 validators."

[config."lighthouse-validator.conf".ivars."http"]
type = "string"
default = ""
priority = "low"
summary = "Enables the RESTful HTTP API server."

[config."lighthouse-validator.conf".ivars."http_allow_keystore_export"]
type = "string"
default = ""
priority = "low"
summary = "Allows access to the DELETE /lighthouse/keystores API method for exporting keystores and passwords."

[config."lighthouse-validator.conf".ivars."http_store_passwords_in_secrets_dir"]
type = "string"
default = ""
priority = "low"
summary = "If set, keystore passwords created via HTTP will be stored in the secrets-dir."

# [config."lighthouse-validator.conf".ivars."init_slashing_protection"]
# type = "string"
# default = ""
# priority = "low"
# summary = "If set, the slashing protection database is not required before running."

[config."lighthouse-validator.conf".ivars."log_color"]
type = "string"
default = ""
priority = "low"
summary = "Forces Lighthouse to output colors when emitting logs to the terminal."

[config."lighthouse-validator.conf".ivars."logfile_compress"]
type = "string"
default = ""
priority = "low"
summary = "If set, old log files will be compressed to reduce storage space."

[config."lighthouse-validator.conf".ivars."logfile_no_restricted_perms"]
type = "string"
default = ""
priority = "low"
summary = "Generates world-readable log files that can be read by any user on the machine."

[config."lighthouse-validator.conf".ivars."metrics"]
type = "string"
default = ""
priority = "low"
summary = "Enables the Prometheus metrics HTTP server."

[config."lighthouse-validator.conf".ivars."prefer_builder_proposals"]
type = "string"
default = ""
priority = "low"
summary = "Always prefer blocks constructed by builders, regardless of payload value."

[config."lighthouse-validator.conf".ivars."produce_block_v3"]
type = "string"
default = ""
priority = "low"
summary = "Enables block production via the block v3 endpoint for the validator client."

[config."lighthouse-validator.conf".ivars."unencrypted_http_transport"]
type = "string"
default = ""
priority = "low"
summary = "Indicates that the HTTP transport is unencrypted and should be used cautiously."

[config."lighthouse-validator.conf".ivars."use_long_timeouts"]
type = "string"
default = ""
priority = "low"
summary = "If set, the validator client will use longer timeouts for requests to the beacon node."

# [config."lighthouse-validator.conf".ivars."beacon_nodes"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma-separated addresses of one or more beacon node HTTP APIs."

[config."lighthouse-validator.conf".ivars."beacon_nodes_tls_certs"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated paths to custom TLS certificates for beacon node connections."

[config."lighthouse-validator.conf".ivars."broadcast"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of beacon API topics to broadcast to all beacon nodes."

[config."lighthouse-validator.conf".ivars."builder_boost_factor"]
type = "string"
default = ""
priority = "low"
summary = "Defines the boost factor applied to the builder's payload value."

[config."lighthouse-validator.conf".ivars."builder_registration_timestamp_override"]
type = "string"
default = ""
priority = "low"
summary = "Overrides the timestamp used in the builder API registration."

[config."lighthouse-validator.conf".ivars."datadir"]
type = "string"
default = ""
priority = "low"
summary = "Custom root data directory for Lighthouse keys and databases."

[config."lighthouse-validator.conf".ivars."debug_level"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the verbosity level for terminal logs."

[config."lighthouse-validator.conf".ivars."gas_limit"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the gas limit to be used in builder proposals."

[config."lighthouse-validator.conf".ivars."genesis_state_url"]
type = "string"
default = ""
priority = "low"
summary = "URL from which to download the genesis state."

[config."lighthouse-validator.conf".ivars."genesis_state_url_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Timeout in seconds for the request to the genesis state URL."

[config."lighthouse-validator.conf".ivars."graffiti"]
type = "string"
default = ""
priority = "low"
summary = "Custom graffiti to be included in blocks."

[config."lighthouse-validator.conf".ivars."graffiti_file"]
type = "string"
default = ""
priority = "low"
summary = "File to load validator graffitis from."

[config."lighthouse-validator.conf".ivars."http_address"]
type = "string"
default = ""
priority = "low"
summary = "Address for the HTTP server."

[config."lighthouse-validator.conf".ivars."http_allow_origin"]
type = "string"
default = ""
priority = "low"
summary = "Sets the Access-Control-Allow-Origin HTTP header."

[config."lighthouse-validator.conf".ivars."http_port"]
type = "string"
default = ""
priority = "low"
summary = "TCP port for the RESTful HTTP API server."

[config."lighthouse-validator.conf".ivars."latency_measurement_service"]
type = "string"
default = ""
priority = "low"
summary = "Enables or disables the service to measure latency to beacon nodes."

[config."lighthouse-validator.conf".ivars."log_format"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the format used for terminal logs."

# [config."lighthouse-validator.conf".ivars."logfile"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path for storing log files."

[config."lighthouse-validator.conf".ivars."logfile_debug_level"]
type = "string"
default = ""
priority = "low"
summary = "Verbosity level for log files."

[config."lighthouse-validator.conf".ivars."logfile_format"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the format for log files."

[config."lighthouse-validator.conf".ivars."logfile_max_number"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of log files to store."

[config."lighthouse-validator.conf".ivars."logfile_max_size"]
type = "string"
default = ""
priority = "low"
summary = "Maximum size for each log file before rotation."

[config."lighthouse-validator.conf".ivars."metrics_address"]
type = "string"
default = ""
priority = "low"
summary = "Listen address for the Prometheus metrics HTTP server."

[config."lighthouse-validator.conf".ivars."metrics_allow_origin"]
type = "string"
default = ""
priority = "low"
summary = "Sets the Access-Control-Allow-Origin HTTP header for Prometheus metrics."

[config."lighthouse-validator.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = "TCP port for the Prometheus metrics HTTP server."

[config."lighthouse-validator.conf".ivars."monitoring_endpoint"]
type = "string"
default = ""
priority = "low"
summary = "Endpoint for sending system metrics to a remote service."

[config."lighthouse-validator.conf".ivars."monitoring_endpoint_period"]
type = "string"
default = ""
priority = "low"
summary = "Defines the interval between each monitoring message sent."

[config."lighthouse-validator.conf".ivars."network"]
type = "string"
default = ""
priority = "low"
summary = "The Eth2 chain Lighthouse will follow (e.g., mainnet, prater)."

[config."lighthouse-validator.conf".ivars."proposer_nodes"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated addresses of beacon nodes used for block proposals."

[config."lighthouse-validator.conf".ivars."safe_slots_to_import_optimistically"]
type = "string"
default = ""
priority = "low"
summary = "Overrides the SAFE_SLOTS_TO_IMPORT_OPTIMISTICALLY parameter."

# [config."lighthouse-validator.conf".ivars."secrets_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Directory containing passwords to unlock validator keypairs."

# [config."lighthouse-validator.conf".ivars."suggested_fee_recipient"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The address that will receive transaction fees post-merge."

[config."lighthouse-validator.conf".ivars."terminal_block_hash_epoch_override"]
type = "string"
default = ""
priority = "low"
summary = "Overrides the TERMINAL_BLOCK_HASH_ACTIVATION_EPOCH parameter."

[config."lighthouse-validator.conf".ivars."terminal_block_hash_override"]
type = "string"
default = ""
priority = "low"
summary = "Overrides the TERMINAL_BLOCK_HASH parameter."

[config."lighthouse-validator.conf".ivars."terminal_total_difficulty_override"]
type = "string"
default = ""
priority = "low"
summary = "Overrides the TERMINAL_TOTAL_DIFFICULTY parameter."

# [config."lighthouse-validator.conf".ivars."testnet_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to directory containing Eth2 testnet specs."

[config."lighthouse-validator.conf".ivars."validator_registration_batch_size"]
type = "string"
default = ""
priority = "low"
summary = "Number of validators per register_validator request."

# [config."lighthouse-validator.conf".ivars."validators_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Directory containing validator keystores, deposit data, and the slashing protection database."

[config."lighthouse-validator.conf".ivars."web3_signer_keep_alive_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Keep-alive timeout for Web3Signer connections."

[config."lighthouse-validator.conf".ivars."web3_signer_max_idle_connections"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of idle connections per Web3Signer host."
