name = "eth-node-teku-validator-regtest"
bin_package = "eth-node-teku"
binary = "/usr/lib/eth-node-teku-validator-regtest/run-teku-validator-service.sh"
user = { name = "eth-node-teku-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-teku-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/teku-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/teku-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-teku-validator-service.sh /usr/lib/eth-node-teku-validator-regtest/", 
    "debian/scripts/run-teku-validator.sh /usr/lib/eth-node-teku-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-teku-validator-regtest",
    "debian/tmp/eth-node-teku-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/teku-validator",
    "debian/validator/passwords /var/lib/eth-node-regtest/teku-validator",
]
provides = ["eth-node-validator-service-regtest"]
conflicts = ["eth-node-validator-service-regtest"]
depends=["eth-node-regtest-cl-service"]
summary = "validator service file for eth-node-teku for network: regtest"

[config."teku-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-teku-validator-regtest/postprocess.sh"]

[config."teku-validator.conf"]
format = "plain"


[config."teku-validator.conf".ivars."beacon_node_api_endpoints"]
type = "string"
default = "http://127.0.0.1:5052"  
priority = "low"
summary = "Beacon Node REST API endpoint(s). If more than one endpoint is defined, the first node will be used as a primary and others as failovers."


[config."teku-validator.conf".ivars."data_base_path"]
type = "string"
default = "$DATA_DIR/teku-validator"  
priority = "low"
summary = "Path to the base directory for storage. Default: $HOME/.local/share/teku."

[config."teku-validator.conf".ivars."validator_keys"]
type = "string"
default = "$DATA_DIR/teku-validator/keys:$DATA_DIR/teku-validator/passwords"  
priority = "low"
summary = "<KEY_DIR>:<PASS_DIR> will find <KEY_DIR>/**.json and expect to find <PASS_DIR>/**.txt. <KEY_FILE>:<PASS_FILE> will expect that the file <KEY_FILE> exists, and the file containing the password for it is <PASS_FILE>. The path separator is operating system dependent, and should be ';' in Windows rather than ':'. Default: []"

[config."teku-validator.conf".ivars."log_destination"]
type = "string"
default = "FILE"
priority = "low"
summary = "Whether a logger is added for the console, the log file, or both (Valid values: BOTH, CONSOLE, DEFAULT_BOTH, FILE, CUSTOM). Default: DEFAULT_BOTH."


[config."teku-validator.conf".ivars."log_file"]
type = "string"
default = "$LOG_DIR/teku-validator/teku.log"  
priority = "low"
summary = "Path containing the location (relative or absolute) and the log filename. If not set will default to <data-path>/logs/teku.log."


[config."teku-validator.conf".ivars."validators_proposer_default_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS" 
priority = "low"
summary = "Default fee recipient sent to the execution engine, which could use it as a fee recipient when producing a new execution block."


[config."teku-validator.conf".ivars."exit_when_no_validator_keys_enabled"]
type = "string"
default = "true"
priority = "low"
summary = "Enable terminating the process if no validator keys are found during startup. Default: false."

#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################


# [config."teku-validator.conf".ivars."beacon_node_api_endpoints"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Beacon Node REST API endpoint(s). If more than one endpoint is defined, the first node will be used as a primary and others as failovers."

[config."teku-validator.conf".ivars."beacon_node_ssz_blocks_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Use SSZ encoding for API block requests. Default: true"

[config."teku-validator.conf".ivars."config_file"]
type = "string"
default = ""
priority = "low"
summary = "Path/filename of the YAML config file."

# [config."teku-validator.conf".ivars."data_base_path"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to the base directory for storage. Default: $HOME/.local/share/teku."

[config."teku-validator.conf".ivars."data_validator_path"]
type = "string"
default = ""
priority = "low"
summary = "Path to validator client data. Default: <data-base-path>/validator."

[config."teku-validator.conf".ivars."doppelganger_detection_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enable validators doppelganger detection. Default: false."

# [config."teku-validator.conf".ivars."exit_when_no_validator_keys_enabled"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Enable terminating the process if no validator keys are found during startup. Default: false."

[config."teku-validator.conf".ivars."logging"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity levels: OFF, FATAL, ERROR, WARN, INFO, DEBUG, TRACE, ALL (default: INFO)."

[config."teku-validator.conf".ivars."log_color_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Whether Status and Event log messages include a console color display code. Default: true."

# [config."teku-validator.conf".ivars."log_destination"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Whether a logger is added for the console, the log file, or both (Valid values: BOTH, CONSOLE, DEFAULT_BOTH, FILE, CUSTOM). Default: DEFAULT_BOTH."

# [config."teku-validator.conf".ivars."log_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path containing the location (relative or absolute) and the log filename. If not set will default to <data-path>/logs/teku.log."

[config."teku-validator.conf".ivars."log_file_name_pattern"]
type = "string"
default = ""
priority = "low"
summary = "Pattern for the filename to apply to rolled over log files. If not set will default to <data-path>/logs/teku_%dyyyy-MM-dd.log."

[config."teku-validator.conf".ivars."log_include_events_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Whether frequent update events are logged (e.g. every slot and epoch event). Default: true."

[config."teku-validator.conf".ivars."log_include_validator_duties_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Whether events are logged when validators perform duties. Default: true."

[config."teku-validator.conf".ivars."metrics_block_timing_tracking_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Whether block timing metrics are tracked and reported. Default: true."

[config."teku-validator.conf".ivars."metrics_categories"]
type = "string"
default = ""
priority = "low"
summary = "Metric categories to enable. Default: [JVM, PROCESS, EXECUTOR, VALIDATOR, STORAGE_FINALIZED_DB, STORAGE, NETWORK, EVENTBUS, VALIDATOR_PERFORMANCE, LIBP2P, REMOTE_VALIDATOR, STORAGE_HOT_DB, DISCOVERY, BEACON]."

[config."teku-validator.conf".ivars."metrics_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enables metrics collection via Prometheus. Default: false."

[config."teku-validator.conf".ivars."metrics_host_allowlist"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of hostnames to allow, or * to allow any host. Default: [127.0.0.1, localhost]."

[config."teku-validator.conf".ivars."metrics_interface"]
type = "string"
default = ""
priority = "low"
summary = "Metrics network interface to expose metrics for Prometheus. Default: 127.0.0.1."

[config."teku-validator.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = "Metrics port to expose metrics for Prometheus. Default: 8008."

[config."teku-validator.conf".ivars."metrics_publish_endpoint"]
type = "string"
default = ""
priority = "low"
summary = "Publish metrics for node monitoring to an external service."

[config."teku-validator.conf".ivars."metrics_publish_interval"]
type = "string"
default = ""
priority = "low"
summary = "Interval between metric publications to the external service (measured in seconds). Default: 60."

[config."teku-validator.conf".ivars."network"]
type = "string"
default = ""
priority = "low"
summary = "Represents which network to use. Use `auto` to fetch network configuration from the beacon node endpoint directly. Default: auto."

[config."teku-validator.conf".ivars."shut_down_when_validator_slashed_enabled"]
type = "string"
default = ""
priority = "low"
summary = "If enabled and an owned validator key is detected as slashed, the node will terminate. The service should not be restarted. Default: false."

[config."teku-validator.conf".ivars."validator_api_bearer_file"]
type = "string"
default = ""
priority = "low"
summary = "Use the specified file as the bearer token for the validator Rest API."

[config."teku-validator.conf".ivars."validator_api_cors_origins"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of origins to allow, or * to allow any origin. Default: []"

[config."teku-validator.conf".ivars."validator_api_docs_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enable swagger-docs and swagger-ui endpoints. Default: false."

[config."teku-validator.conf".ivars."validator_api_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enables Validator Rest API. Default: false."

[config."teku-validator.conf".ivars."validator_api_host_allowlist"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of hostnames to allow, or * to allow any host. Default: [127.0.0.1, localhost]."

[config."teku-validator.conf".ivars."validator_api_interface"]
type = "string"
default = ""
priority = "low"
summary = "Interface of Validator Rest API. Default: 127.0.0.1."

[config."teku-validator.conf".ivars."validator_api_keystore_file"]
type = "string"
default = ""
priority = "low"
summary = "Keystore used for SSL for the validator API."

[config."teku-validator.conf".ivars."validator_api_keystore_password_file"]
type = "string"
default = ""
priority = "low"
summary = "Password used to decrypt the keystore for the validator API."

[config."teku-validator.conf".ivars."validator_api_port"]
type = "string"
default = ""
priority = "low"
summary = "Port number of the Rest API. Default: 5052."

[config."teku-validator.conf".ivars."validator_is_local_slashing_protection_synchronized_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Restrict local signing to a single operation at a time. Default: true."

# [config."teku-validator.conf".ivars."validator_keys"]
# type = "string"
# default = ""
# priority = "low"
# summary = "<KEY_DIR>:<PASS_DIR> will find <KEY_DIR>/**.json and expect to find <PASS_DIR>/**.txt. <KEY_FILE>:<PASS_FILE> will expect that the file <KEY_FILE> exists, and the file containing the password for it is <PASS_FILE>. The path separator is operating system dependent, and should be ';' in Windows rather than ':'. Default: []"

[config."teku-validator.conf".ivars."validators_builder_registration_default_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enable validators registration to builder infrastructure. Default: false."

[config."teku-validator.conf".ivars."validators_early_attestations_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Generate attestations as soon as a block is known, rather than delaying until the attestation is due. Default: true."

[config."teku-validator.conf".ivars."validators_external_signer_keystore"]
type = "string"
default = ""
priority = "low"
summary = "Keystore (PKCS12/JKS) to use for TLS mutual authentication with external signer."

[config."teku-validator.conf".ivars."validators_external_signer_keystore_password_file"]
type = "string"
default = ""
priority = "low"
summary = "Password file to decrypt keystore (PKCS12/JKS) that will be used for TLS mutual authentication with external signer."

[config."teku-validator.conf".ivars."validators_external_signer_public_keys"]
type = "string"
default = ""
priority = "low"
summary = "The list of external signer public keys, or a URL to load the keys from. Default: []"

[config."teku-validator.conf".ivars."validators_external_signer_slashing_protection_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enable internal slashing protection for external signers. Default: true."

[config."teku-validator.conf".ivars."validators_external_signer_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Timeout (in milliseconds) for the external signing service. Default: 5000."

[config."teku-validator.conf".ivars."validators_external_signer_truststore"]
type = "string"
default = ""
priority = "low"
summary = "Keystore (PKCS12/JKS) to trust external signer's self-signed certificate."

[config."teku-validator.conf".ivars."validators_external_signer_truststore_password_file"]
type = "string"
default = ""
priority = "low"
summary = "Password file to decrypt keystore (PKCS12/JKS) that will be used to trust external signer's self-signed certificate."

[config."teku-validator.conf".ivars."validators_external_signer_url"]
type = "string"
default = ""
priority = "low"
summary = "URL for the external signing service."

[config."teku-validator.conf".ivars."validators_graffiti"]
type = "string"
default = ""
priority = "low"
summary = "Graffiti value to include during block creation. Value gets converted to bytes and padded to Bytes32."

[config."teku-validator.conf".ivars."validators_graffiti_client_append_format"]
type = "string"
default = ""
priority = "low"
summary = "Appends CL and EL clients information with a space to user's graffiti when producing a block on the Beacon Node. (Valid values: AUTO, CLIENT_CODES, DISABLED). Default: AUTO."

[config."teku-validator.conf".ivars."validators_graffiti_file"]
type = "string"
default = ""
priority = "low"
summary = "File to load graffiti value to include during block creation. Value gets converted to bytes and padded to Bytes32. Takes precedence over --validators-graffiti. If the file cannot be read, the --validators-graffiti value is used as a fallback."

[config."teku-validator.conf".ivars."validators_keystore_locking_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enable locking validator keystore files. Default: true."

[config."teku-validator.conf".ivars."validators_performance_tracking_mode"]
type = "string"
default = ""
priority = "low"
summary = "Set strategy for handling performance tracking. Valid values: LOGGING, METRICS, ALL, NONE. Default: ALL."

[config."teku-validator.conf".ivars."validators_proposer_blinded_blocks_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Use blinded blocks when in block production duties. Default: false."

[config."teku-validator.conf".ivars."validators_proposer_config"]
type = "string"
default = ""
priority = "low"
summary = "Remote URL or local file path to load proposer configuration from."

[config."teku-validator.conf".ivars."validators_proposer_config_refresh_enabled"]
type = "string"
default = ""
priority = "low"
summary = "Enable the proposer configuration reload on every proposer preparation (once per epoch). Default: false."

# [config."teku-validator.conf".ivars."validators_proposer_default_fee_recipient"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Default fee recipient sent to the execution engine, which could use it as a fee recipient when producing a new execution block."
