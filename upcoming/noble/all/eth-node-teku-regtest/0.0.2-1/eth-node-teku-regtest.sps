name = "eth-node-teku-regtest"
bin_package = "eth-node-teku"
binary = "/usr/lib/eth-node-teku-regtest/run-teku-service.sh"
user = { name = "eth-node-teku-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-teku-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/teku
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/teku
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-teku-service.sh /usr/lib/eth-node-teku-regtest/", 
    "debian/scripts/run-teku.sh /usr/lib/eth-node-teku-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-teku-regtest",
    "debian/tmp/eth-node-teku-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-teku for network: regtest"

[config."teku-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-teku-regtest/postprocess.sh"]

[config."teku-regtest.conf"]
format = "plain"

[config."teku-regtest.conf".ivars."ee_endpoint"]
type = "string"
default = "$ENDPOINT_URL"
priority = "low"
summary = "URL for Execution Engine node."

[config."teku-regtest.conf".ivars."ee_jwt_secret_file"]
type = "string"
default = "$JWT_FILE"
priority = "low"
summary = "Location of the file specifying the hex-encoded 256 bit secret key to be used for verifying/generating JWT tokens."

[config."teku-regtest.conf".ivars."data_path"]
type = "string"
default = "$DATA_DIR/teku"
priority = "low"
summary = "Path to the base directory for storage. Default: $HOME/.local/share/teku."

[config."teku-regtest.conf".ivars."network"]
type = "string"
default = "$TESTNET_DIR/config.yaml"
priority = "low"
summary = "Represents which network to use. Default: mainnet."

[config."teku-regtest.conf".ivars."p2p_discovery_bootnodes"]
type = "string"
default = "$BOOTNODES_ENR"
priority = "low"
summary = "List of ENRs of the bootnodes."

[config."teku-regtest.conf".ivars."genesis_state"]
type = "string"
default = "$TESTNET_DIR/genesis.ssz"
priority = "low"
summary = "The genesis state. This value should be a file or URL pointing to an SSZ-encoded finalized checkpoint state."

[config."teku-regtest.conf".ivars."ignore_weak_subjectivity_period_enabled"]
type = "string"
default = "true"
priority = "low"
summary = "Allows syncing outside of the weak subjectivity period. Default: false."

[config."teku-regtest.conf".ivars."rest_api_cors_origins"]
type = "string"
default = "[]"
priority = "low"
summary = "Comma-separated list of origins to allow, or * to allow any origin. Default: []."

[config."teku-regtest.conf".ivars."rest_api_docs_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable swagger-docs and swagger-ui endpoints. Default: false."

[config."teku-regtest.conf".ivars."rest_api_enabled"]
type = "string"
default = "true"
priority = "low"
summary = "Enables Beacon Rest API. Default: null."

# [config."teku-regtest.conf".ivars."rest_api_host_allowlist"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma-separated list of hostnames to allow, or * to allow any host. Default: [127.0.0.1, localhost]."

[config."teku-regtest.conf".ivars."rest_api_interface"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Interface of Beacon Rest API. Default: 127.0.0.1."

[config."teku-regtest.conf".ivars."rest_api_port"]
type = "string"
default = "$CL_RPC_PORT"
priority = "low"
summary = "Port number of Beacon Rest API."

# Needs to be set on BN as well 
[config."teku-regtest.conf".ivars."validators_proposer_default_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS" 
priority = "low"
summary = ""

[config."teku-regtest.conf".ivars."log_destination"]
type = "string"
default = "FILE" 
priority = "low"
summary = "Whether a logger is added for the console, the log file, or both (Valid values: BOTH, CONSOLE, DEFAULT_BOTH, FILE, CUSTOM)."

[config."teku-regtest.conf".ivars."log_file"]
type = "string"
default = "$LOG_DIR/teku/teku.log" 
priority = "low"
summary = "Path containing the location (relative or absolute) and the log filename. If not set will default to <data-path>/logs/teku.log."


#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################

[config."teku-regtest.conf".ivars."config_file"]
type = "string"
default = "" 
priority = "low"
summary = "Path/filename of the yaml config file (default: none)"


#### Network ##########

[config."teku-regtest.conf".ivars."checkpoint_sync_url"]
type = "string"
default = "" 
priority = "low"
summary = "The Checkpointz server that will be used to bootstrap this node."

[config."teku-regtest.conf".ivars."eth1_deposit_contract_address"]
type = "string"
default = "" 
priority = "low"
summary = "Contract address for the deposit contract. Only required when creating a custom network."

# [config."teku-regtest.conf".ivars."genesis_state"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "The genesis state. This value should be a file or URL pointing to an SSZ-encoded finalized checkpoint state."

# [config."teku-regtest.conf".ivars."ignore_weak_subjectivity_period_enabled"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Allows syncing outside of the weak subjectivity period."

[config."teku-regtest.conf".ivars."initial_state"]
type = "string"
default = "" 
priority = "low"
summary = "The initial state. This value should be a file or URL pointing to an SSZ-encoded finalized checkpoint state."

# [config."teku-regtest.conf".ivars."network"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Represents which network to use."


##### P2P

[config."teku-regtest.conf".ivars."p2p_advertised_ip"]
type = "string"
default = "" 
priority = "low"
summary = "P2P advertised IP address(es). You can define up to 2 addresses, with one being IPv4 and the other IPv6."

[config."teku-regtest.conf".ivars."p2p_advertised_port"]
type = "string"
default = "" 
priority = "low"
summary = "P2P advertised port. The default is the port specified in --p2p-port."

[config."teku-regtest.conf".ivars."p2p_advertised_port_ipv6"]
type = "string"
default = "" 
priority = "low"
summary = "P2P advertised IPv6 port. This port is only used when advertising both IPv4 and IPv6 addresses."

[config."teku-regtest.conf".ivars."p2p_advertised_udp_port"]
type = "string"
default = "" 
priority = "low"
summary = "Advertised UDP port to external peers. The default is the port specified in --p2p-advertised-port."

[config."teku-regtest.conf".ivars."p2p_advertised_udp_port_ipv6"]
type = "string"
default = "" 
priority = "low"
summary = "Advertised IPv6 UDP port to external peers. This port is only used when advertising both IPv4 and IPv6 addresses."

[config."teku-regtest.conf".ivars."p2p_direct_peers"]
type = "string"
default = "" 
priority = "low"
summary = "Specifies a list of 'direct' peers with which to establish and maintain connections."

# [config."teku-regtest.conf".ivars."p2p_discovery_bootnodes"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "List of ENRs of the bootnodes."

[config."teku-regtest.conf".ivars."p2p_discovery_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enables discv5 discovery."

[config."teku-regtest.conf".ivars."p2p_discovery_site_local_addresses_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Whether discovery accepts messages and peer records with site local (RFC1918) addresses."

[config."teku-regtest.conf".ivars."p2p_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enables P2P."

[config."teku-regtest.conf".ivars."p2p_interface"]
type = "string"
default = "" 
priority = "low"
summary = "The network interface(s) on which the node listens for P2P communication."

[config."teku-regtest.conf".ivars."p2p_nat_method"]
type = "string"
default = "" 
priority = "low"
summary = "Specify the NAT circumvention method to be used, possible values are UPNP, NONE."

[config."teku-regtest.conf".ivars."p2p_peer_lower_bound"]
type = "string"
default = "" 
priority = "low"
summary = "Lower bound on the target number of peers."

[config."teku-regtest.conf".ivars."p2p_peer_upper_bound"]
type = "string"
default = "" 
priority = "low"
summary = "Upper bound on the target number of peers."

[config."teku-regtest.conf".ivars."p2p_port"]
type = "string"
default = "" 
priority = "low"
summary = "P2P port."

[config."teku-regtest.conf".ivars."p2p_port_ipv6"]
type = "string"
default = "" 
priority = "low"
summary = "P2P IPv6 port. This port is only used when listening over both IPv4 and IPv6."

[config."teku-regtest.conf".ivars."p2p_private_key_file"]
type = "string"
default = "" 
priority = "low"
summary = "This node's private key file. If not specified, uses or generates a key which is stored within the <beacon-data-dir>."

[config."teku-regtest.conf".ivars."p2p_static_peers"]
type = "string"
default = "" 
priority = "low"
summary = "Specifies a list of 'static' peers with which to establish and maintain connections."

[config."teku-regtest.conf".ivars."p2p_subscribe_all_subnets_enabled"]
type = "string"
default = "false" 
priority = "low"
summary = ""

[config."teku-regtest.conf".ivars."p2p_udp_port"]
type = "string"
default = "" 
priority = "low"
summary = "UDP port used for discovery. The default is the port specified in --p2p-port."

[config."teku-regtest.conf".ivars."p2p_udp_port_ipv6"]
type = "string"
default = "" 
priority = "low"
summary = "IPv6 UDP port used for discovery. This port is only used when listening over both IPv4 and IPv6."


# Validator 

[config."teku-regtest.conf".ivars."doppelganger_detection_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enable validators doppelganger detection."

[config."teku-regtest.conf".ivars."exit_when_no_validator_keys_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enable terminating the process if no validator keys are found during startup."

[config."teku-regtest.conf".ivars."shut_down_when_validator_slashed_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "If enabled and an owned validator key is detected as slashed, the node will terminate."

[config."teku-regtest.conf".ivars."validator_is_local_slashing_protection_synchronized_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Restrict local signing to a single operation at a time."

[config."teku-regtest.conf".ivars."validator_keys"]
type = "string"
default = "" 
priority = "low"
summary = "<KEY_DIR>:<PASS_DIR> will find <KEY_DIR>/**.json, and expect to find <PASS_DIR>/**.txt."

[config."teku-regtest.conf".ivars."validators_builder_registration_default_enabled"]
type = "string"
default = "false" 
priority = "low"
summary = "Enable validators registration to builder infrastructure."

[config."teku-regtest.conf".ivars."validators_early_attestations_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Generate attestations as soon as a block is known, rather than delaying until the attestation is due."

[config."teku-regtest.conf".ivars."validators_external_signer_keystore"]
type = "string"
default = "" 
priority = "low"
summary = "Keystore (PKCS12/JKS) to use for TLS mutual authentication with external signer."

[config."teku-regtest.conf".ivars."validators_external_signer_keystore_password_file"]
type = "string"
default = "" 
priority = "low"
summary = "Password file to decrypt keystore (PKCS12/JKS) for TLS mutual authentication with external signer."

[config."teku-regtest.conf".ivars."validators_external_signer_public_keys"]
type = "string"
default = "" 
priority = "low"
summary = "The list of external signer public keys, or a URL to load the keys from."

[config."teku-regtest.conf".ivars."validators_external_signer_slashing_protection_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enable internal slashing protection for external signers."

[config."teku-regtest.conf".ivars."validators_external_signer_timeout"]
type = "string"
default = "" 
priority = "low"
summary = "Timeout (in milliseconds) for the external signing service."

[config."teku-regtest.conf".ivars."validators_external_signer_truststore"]
type = "string"
default = "" 
priority = "low"
summary = "Keystore (PKCS12/JKS) to trust external signer's self-signed certificate."

[config."teku-regtest.conf".ivars."validators_external_signer_truststore_password_file"]
type = "string"
default = "" 
priority = "low"
summary = "Password file to decrypt truststore for external signer's self-signed certificate."

[config."teku-regtest.conf".ivars."validators_external_signer_url"]
type = "string"
default = "" 
priority = "low"
summary = "URL for the external signing service."

[config."teku-regtest.conf".ivars."validators_graffiti"]
type = "string"
default = "" 
priority = "low"
summary = "Graffiti value to include during block creation."

[config."teku-regtest.conf".ivars."validators_graffiti_client_append_format"]
type = "string"
default = "" 
priority = "low"
summary = "Appends CL and EL clients information with a space to user's graffiti when producing a block on the Beacon Node."

[config."teku-regtest.conf".ivars."validators_graffiti_file"]
type = "string"
default = "" 
priority = "low"
summary = "File to load graffiti value to include during block creation."

[config."teku-regtest.conf".ivars."validators_keystore_locking_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enable locking validator keystore files."

[config."teku-regtest.conf".ivars."validators_performance_tracking_mode"]
type = "string"
default = "" 
priority = "low"
summary = "Set strategy for handling performance tracking (Valid values: LOGGING, METRICS, ALL, NONE)."

[config."teku-regtest.conf".ivars."validators_proposer_blinded_blocks_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Use blinded blocks when in block production duties."

[config."teku-regtest.conf".ivars."validators_proposer_config"]
type = "string"
default = "" 
priority = "low"
summary = "Remote URL or local file path to load proposer configuration from."

[config."teku-regtest.conf".ivars."validators_proposer_config_refresh_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enable the proposer configuration reload on every proposer preparation (once per epoch)."

# [config."teku-regtest.conf".ivars."validators_proposer_default_fee_recipient"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Default fee recipient sent to the execution engine when producing a new execution block."


# Execution layer 

[config."teku-regtest.conf".ivars."builder_bid_compare_factor"]
type = "string"
default = "" 
priority = "low"
summary = "Set the compare factor applied to the builder bid value when comparing it with locally produced payload."

[config."teku-regtest.conf".ivars."builder_endpoint"]
type = "string"
default = "" 
priority = "low"
summary = "URL for an external Builder node (optional)."

[config."teku-regtest.conf".ivars."builder_set_user_agent_header"]
type = "string"
default = "" 
priority = "low"
summary = "Set User-Agent header to teku/v<version> when making a builder bid request to help builders identify clients and versions."

[config."teku-regtest.conf".ivars."deposit_snapshot_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Use bundled snapshot for most networks and persist deposit tree snapshot."

# [config."teku-regtest.conf".ivars."ee_endpoint"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "URL for Execution Engine node."

[config."teku-regtest.conf".ivars."ee_jwt_claim_id"]
type = "string"
default = "" 
priority = "low"
summary = "A unique identifier for the consensus layer client, added to the JWT claims as an 'id' claim."

# [config."teku-regtest.conf".ivars."ee_jwt_secret_file"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Location of the file specifying the hex-encoded 256 bit secret key to be used for verifying/generating JWT tokens."

[config."teku-regtest.conf".ivars."eth1_deposit_contract_max_request_size"]
type = "string"
default = "" 
priority = "low"
summary = "Maximum number of blocks to request deposit contract event logs for in a single request."

[config."teku-regtest.conf".ivars."eth1_endpoint"]
type = "string"
default = "" 
priority = "low"
summary = "URLs for Eth1 nodes."

[config."teku-regtest.conf".ivars."exchange_capabilities_monitoring_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enables querying EL periodically for the Engine API methods it supports. If incompatibility is detected, a warning will be raised."

# Data storage 


[config."teku-regtest.conf".ivars."data_beacon_path"]
type = "string"
default = "" 
priority = "low"
summary = "Path to beacon node data."

# [config."teku-regtest.conf".ivars."data_path"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Path to the base directory for storage."

[config."teku-regtest.conf".ivars."data_storage_archive_frequency"]
type = "string"
default = "" 
priority = "low"
summary = "Sets the frequency, in slots, at which to store finalized states to disk. Ignored if --data-storage-mode is set to PRUNE."

[config."teku-regtest.conf".ivars."data_storage_mode"]
type = "string"
default = "" 
priority = "low"
summary = "Sets the strategy for handling historical chain data (Valid values: ARCHIVE, PRUNE, MINIMAL, NOT_SET)."

[config."teku-regtest.conf".ivars."data_storage_non_canonical_blocks_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Store non-canonical blocks and associated blobs if they exist."

[config."teku-regtest.conf".ivars."data_validator_path"]
type = "string"
default = "" 
priority = "low"
summary = "Path to validator client data."

[config."teku-regtest.conf".ivars."reconstruct_historic_states"]
type = "string"
default = "" 
priority = "low"
summary = ""


# Beacon REST API 
[config."teku-regtest.conf".ivars."beacon_liveness_tracking_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Track validator liveness and enable requests to the liveness rest API."

# [config."teku-regtest.conf".ivars."rest_api_cors_origins"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Comma-separated list of origins to allow, or * to allow any origin."

# [config."teku-regtest.conf".ivars."rest_api_docs_enabled"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Enable swagger-docs and swagger-ui endpoints."

# [config."teku-regtest.conf".ivars."rest_api_enabled"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Enables Beacon Rest API."

[config."teku-regtest.conf".ivars."rest_api_host_allowlist"]
type = "string"
default = "" 
priority = "low"
summary = "Comma-separated list of hostnames to allow, or * to allow any host."

# [config."teku-regtest.conf".ivars."rest_api_interface"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Interface of Beacon Rest API."

# [config."teku-regtest.conf".ivars."rest_api_port"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Port number of Beacon Rest API."


# validator REST API 
[config."teku-regtest.conf".ivars."validator_api_bearer_file"]
type = "string"
default = "" 
priority = "low"
summary = "Use the specified file as the bearer token for the validator Rest API."

[config."teku-regtest.conf".ivars."validator_api_cors_origins"]
type = "string"
default = "" 
priority = "low"
summary = "Comma-separated list of origins to allow, or * to allow any origin."

[config."teku-regtest.conf".ivars."validator_api_docs_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enable swagger-docs and swagger-ui endpoints."

[config."teku-regtest.conf".ivars."validator_api_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enables Validator Rest API."

[config."teku-regtest.conf".ivars."validator_api_host_allowlist"]
type = "string"
default = "" 
priority = "low"
summary = "Comma-separated list of hostnames to allow, or * to allow any host."

[config."teku-regtest.conf".ivars."validator_api_interface"]
type = "string"
default = "" 
priority = "low"
summary = "Interface of Validator Rest API."

[config."teku-regtest.conf".ivars."validator_api_keystore_file"]
type = "string"
default = "" 
priority = "low"
summary = "Keystore used for SSL for the validator API."

[config."teku-regtest.conf".ivars."validator_api_keystore_password_file"]
type = "string"
default = "" 
priority = "low"
summary = "Password used to decrypt the keystore for the validator API."

[config."teku-regtest.conf".ivars."validator_api_port"]
type = "string"
default = "" 
priority = "low"
summary = "Port number of Rest API."

# weak subjectivity 


[config."teku-regtest.conf".ivars."ws_checkpoint"]
type = "string"
default = "" 
priority = "low"
summary = "A recent checkpoint within the weak subjectivity period. Should be a string containing <BLOCK_ROOT>:<EPOCH_NUMBER> or a URL containing the field ws_checkpoint with the same information."


# Logging 

[config."teku-regtest.conf".ivars."logging"]
type = "string"
default = "" 
priority = "low"
summary = "Logging verbosity levels: OFF, FATAL, ERROR, WARN, INFO, DEBUG, TRACE, ALL (default: INFO)."

[config."teku-regtest.conf".ivars."log_color_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Whether Status and Event log messages include a console color display code."

# [config."teku-regtest.conf".ivars."log_destination"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Whether a logger is added for the console, the log file, or both (Valid values: BOTH, CONSOLE, DEFAULT_BOTH, FILE, CUSTOM)."

# [config."teku-regtest.conf".ivars."log_file"]
# type = "string"
# default = "" 
# priority = "low"
# summary = "Path containing the location (relative or absolute) and the log filename. If not set will default to <data-path>/logs/teku.log."

[config."teku-regtest.conf".ivars."log_file_name_pattern"]
type = "string"
default = "" 
priority = "low"
summary = "Pattern for the filename to apply to rolled over log files. If not set will default to <data-path>/logs/teku_%dyyyy-MM-dd.log."

[config."teku-regtest.conf".ivars."log_include_events_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Whether frequent update events are logged (e.g. every slot and epoch event)."

[config."teku-regtest.conf".ivars."log_include_validator_duties_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Whether events are logged when validators perform duties."


# metrics 
[config."teku-regtest.conf".ivars."metrics_block_timing_tracking_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Whether block timing metrics are tracked and reported."

[config."teku-regtest.conf".ivars."metrics_categories"]
type = "string"
default = "" 
priority = "low"
summary = "Metric categories to enable."

[config."teku-regtest.conf".ivars."metrics_enabled"]
type = "string"
default = "" 
priority = "low"
summary = "Enables metrics collection via Prometheus."

[config."teku-regtest.conf".ivars."metrics_host_allowlist"]
type = "string"
default = "" 
priority = "low"
summary = "Comma-separated list of hostnames to allow, or * to allow any host."

[config."teku-regtest.conf".ivars."metrics_interface"]
type = "string"
default = "" 
priority = "low"
summary = "Metrics network interface to expose metrics for Prometheus."

[config."teku-regtest.conf".ivars."metrics_port"]
type = "string"
default = "" 
priority = "low"
summary = "Metrics port to expose metrics for Prometheus."

[config."teku-regtest.conf".ivars."metrics_publish_endpoint"]
type = "string"
default = "" 
priority = "low"
summary = "Publish metrics for node monitoring to an external service."

[config."teku-regtest.conf".ivars."metrics_publish_interval"]
type = "string"
default = "" 
priority = "low"
summary = "Interval between metric publications to the external service (measured in seconds)."
