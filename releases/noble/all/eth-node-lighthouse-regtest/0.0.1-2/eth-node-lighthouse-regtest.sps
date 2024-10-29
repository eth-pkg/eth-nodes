name = "eth-node-lighthouse-regtest"
bin_package = "eth-node-lighthouse"
binary = "/usr/lib/eth-node-lighthouse-regtest/run-lighthouse-service.sh"
user = { name = "eth-node-lighthouse-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-lighthouse-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/lighthouse
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/lighthouse
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lighthouse-service.sh /usr/lib/eth-node-lighthouse-regtest/", 
    "debian/scripts/run-lighthouse.sh /usr/lib/eth-node-lighthouse-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lighthouse-regtest",
    "debian/tmp/eth-node-lighthouse-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-lighthouse for network: regtest"

[config."lighthouse-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lighthouse-regtest/postprocess.sh"]

[config."lighthouse-regtest.conf"]
format = "plain"



[config."lighthouse-regtest.conf".ivars."network"]
type = "string"
default = ""  
priority = "low"
summary = "Specify the name of the Eth2 chain to sync and follow (e.g., mainnet, prater, goerli)."

[config."lighthouse-regtest.conf".ivars."datadir"]
type = "string"
default = "$DATA_DIR/lighthouse"
priority = "low"
summary = "Specify a custom root data directory for Lighthouse keys and databases."

[config."lighthouse-regtest.conf".ivars."disable_enr_auto_update"]
type = "string"
default = "true"
priority = "low"
summary = "Disable automatic ENR updates, fixing the ENR's IP/PORT to those specified on boot."

[config."lighthouse-regtest.conf".ivars."enr_address"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "The IP or DNS address to broadcast to other peers for connecting to the node."


[config."lighthouse-regtest.conf".ivars."enr_udp_port"]
type = "string"
default = "9000"
priority = "low"
summary = "The UDP4 port for the local ENR, used for incoming connections over IPv4."


[config."lighthouse-regtest.conf".ivars."enr_tcp_port"]
type = "string"
default = "9000"
priority = "low"
summary = "The TCP4 port for the local ENR, used for incoming connections over IPv4."


[config."lighthouse-regtest.conf".ivars."quic_port"]
type = "string"
default = "9100"
priority = "low"
summary = "Set the UDP port for QUIC. Defaults to `port` + 1."


[config."lighthouse-regtest.conf".ivars."listen_address"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Specify the address Lighthouse will listen on for UDP and TCP connections."

[config."lighthouse-regtest.conf".ivars."port"]
type = "string"
default = "$CL_P2P_PORT"
priority = "low"
summary = "Set the TCP/UDP port for listening. Defaults to 9000 for IPv4."

[config."lighthouse-regtest.conf".ivars."http"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the RESTful HTTP API server."

[config."lighthouse-regtest.conf".ivars."http_address"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Set the listen address for the RESTful HTTP API server."

[config."lighthouse-regtest.conf".ivars."http_port"]
type = "string"
default = "$CL_RPC_PORT"
priority = "low"
summary = "Set the listen TCP port for the RESTful HTTP API server."

[config."lighthouse-regtest.conf".ivars."slots_per_restore_point"]
type = "string"
default = "8192"
priority = "low"
summary = "Specify how often a freezer DB restore point should be stored."

[config."lighthouse-regtest.conf".ivars."disable_packet_filter"]
type = "string"
default = "true"
priority = "low"
summary = "Disable the discovery packet filter, useful for testing in smaller networks."

[config."lighthouse-regtest.conf".ivars."execution_endpoint"]
type = "string"
default = "$ENDPOINT_URL"
priority = "low"
summary = "Server endpoint for an execution layer JWT-authenticated HTTP JSON-RPC connection."


[config."lighthouse-regtest.conf".ivars."execution_jwt"]
type = "string"
default = "$JWT_FILE"
priority = "low"
summary = "File path containing the hex-encoded JWT secret for the execution endpoint."

[config."lighthouse-regtest.conf".ivars."suggested_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = "Specify an emergency fallback fee recipient for block production in case the validator client lacks one."


[config."lighthouse-regtest.conf".ivars."enable_private_discovery"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the discovery of private IP addresses to allow connection attempts to local addresses."


[config."lighthouse-regtest.conf".ivars."testnet_dir"]
type = "string"
default = "$TESTNET_DIR"
priority = "low"
summary = "Path to directory containing eth2_testnet specs. Defaults to a hard-coded Lighthouse testnet. Only effective if there is no existing database."

[config."lighthouse-regtest.conf".ivars."boot_nodes"]
type = "string"
default = "$BOOTNODES_ENR"
priority = "low"
summary = "Comma-delimited list of base64-encoded ENR's or Multiaddrs to bootstrap the p2p network."

[config."lighthouse-regtest.conf".ivars."logfile"]
type = "string"
default = "$LOG_DIR/lighthouse/lighthouse.log"
priority = "low"
summary = "File path where the log file will be stored."

#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################

[config."lighthouse-regtest.conf".ivars."allow_insecure_genesis_sync"]
type = "string"
default = ""
priority = "low"
summary = "Enable syncing from genesis, which is generally insecure and incompatible with data availability checks. Use checkpoint syncing instead. DO NOT use on mainnet."

[config."lighthouse-regtest.conf".ivars."always_prefer_builder_payload"]
type = "string"
default = ""
priority = "low"
summary = "This flag is deprecated and has no effect."

[config."lighthouse-regtest.conf".ivars."always_prepare_payload"]
type = "string"
default = ""
priority = "low"
summary = "Send payload attributes with every fork choice update, intended for block builders, relays, and developers."

[config."lighthouse-regtest.conf".ivars."builder_fallback_disable_checks"]
type = "string"
default = ""
priority = "low"
summary = "Disable all checks related to chain health, forcing builder API usage for payload construction."

[config."lighthouse-regtest.conf".ivars."compact_db"]
type = "string"
default = ""
priority = "low"
summary = "Apply compaction to the database on start-up, generally not recommended unless auto-compaction is disabled."

[config."lighthouse-regtest.conf".ivars."disable_backfill_rate_limiting"]
type = "string"
default = ""
priority = "low"
summary = "Disable backfill sync rate-limiting, allowing the entire chain to sync faster, which can degrade staking performance."

[config."lighthouse-regtest.conf".ivars."disable_deposit_contract_sync"]
type = "string"
default = ""
priority = "low"
summary = "Disable syncing of deposit logs from the execution node, useful for running a non-validating beacon node."

[config."lighthouse-regtest.conf".ivars."disable_duplicate_warn_logs"]
type = "string"
default = ""
priority = "low"
summary = "This flag is deprecated and has no effect."

# [config."lighthouse-regtest.conf".ivars."disable_enr_auto_update"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Disable automatic ENR updates, fixing the ENR's IP/PORT to those specified on boot."

[config."lighthouse-regtest.conf".ivars."disable_lock_timeouts"]
type = "string"
default = ""
priority = "low"
summary = "Disable internal lock timeouts to avoid spurious failures on slow hardware, considered experimental."

[config."lighthouse-regtest.conf".ivars."disable_log_timestamp"]
type = "string"
default = ""
priority = "low"
summary = "Do not include timestamps in logging output."

[config."lighthouse-regtest.conf".ivars."disable_malloc_tuning"]
type = "string"
default = ""
priority = "low"
summary = "Do not configure the system allocator, which generally increases memory usage, for debugging memory allocation issues."

[config."lighthouse-regtest.conf".ivars."disable_optimistic_finalized_sync"]
type = "string"
default = ""
priority = "low"
summary = "Force verification of every execution block hash with the execution client during finalized sync."

# [config."lighthouse-regtest.conf".ivars."disable_packet_filter"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Disable the discovery packet filter, useful for testing in smaller networks."

[config."lighthouse-regtest.conf".ivars."disable_proposer_reorgs"]
type = "string"
default = ""
priority = "low"
summary = "Do not attempt to reorg late blocks from other validators when proposing."

[config."lighthouse-regtest.conf".ivars."disable_quic"]
type = "string"
default = ""
priority = "low"
summary = "Disable the QUIC transport and rely solely on TCP for libp2p connections."

[config."lighthouse-regtest.conf".ivars."disable_upnp"]
type = "string"
default = ""
priority = "low"
summary = "Disable UPnP support, preventing automatic external port mappings."

[config."lighthouse-regtest.conf".ivars."dummy_eth1"]
type = "string"
default = ""
priority = "low"
summary = "Use a dummy eth1 backend that generates static data, identical to the method used at the 2019 Canada interop."

# [config."lighthouse-regtest.conf".ivars."enable_private_discovery"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Enable the discovery of private IP addresses to allow connection attempts to local addresses."

[config."lighthouse-regtest.conf".ivars."enr_match"]
type = "string"
default = ""
priority = "low"
summary = "Set the local ENR IP address and port to match the --listen-address and --discovery-port values."

[config."lighthouse-regtest.conf".ivars."eth1"]
type = "string"
default = ""
priority = "low"
summary = "Connect the beacon node to an eth1 node, required for block production and serving validators."

[config."lighthouse-regtest.conf".ivars."eth1_purge_cache"]
type = "string"
default = ""
priority = "low"
summary = "Purge the eth1 block and deposit caches."

[config."lighthouse-regtest.conf".ivars."genesis_backfill"]
type = "string"
default = ""
priority = "low"
summary = "Download blocks all the way back to genesis during checkpoint syncing."

[config."lighthouse-regtest.conf".ivars."gui"]
type = "string"
default = ""
priority = "low"
summary = "Enable the graphical user interface, along with HTTP API, SSE logging, and validator auto-monitoring."

# [config."lighthouse-regtest.conf".ivars."http"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Enable the RESTful HTTP API server, which is disabled by default."

[config."lighthouse-regtest.conf".ivars."http_allow_sync_stalled"]
type = "string"
default = ""
priority = "low"
summary = "Force the HTTP API to show the node as synced even if sync is stalled. For testnets only."

[config."lighthouse-regtest.conf".ivars."http_enable_tls"]
type = "string"
default = ""
priority = "low"
summary = "Serve the RESTful HTTP API over TLS (experimental feature)."

[config."lighthouse-regtest.conf".ivars."import_all_attestations"]
type = "string"
default = ""
priority = "low"
summary = "Import and aggregate all attestations, use with --subscribe-all-subnets to ensure full attestation import."

[config."lighthouse-regtest.conf".ivars."light_client_server"]
type = "string"
default = ""
priority = "low"
summary = "Act as a full node supporting light clients on the p2p network (experimental)."

[config."lighthouse-regtest.conf".ivars."log_color"]
type = "string"
default = ""
priority = "low"
summary = "Force colorized output for logs when emitting them to the terminal."

[config."lighthouse-regtest.conf".ivars."logfile_compress"]
type = "string"
default = ""
priority = "low"
summary = "Compress old log files to save disk space."

[config."lighthouse-regtest.conf".ivars."logfile_no_restricted_perms"]
type = "string"
default = ""
priority = "low"
summary = "Generate log files as world-readable, allowing any user on the machine to read them."

[config."lighthouse-regtest.conf".ivars."metrics"]
type = "string"
default = ""
priority = "low"
summary = "Enable the Prometheus metrics HTTP server, which is disabled by default."

[config."lighthouse-regtest.conf".ivars."private"]
type = "string"
default = ""
priority = "low"
summary = "Prevent sending various client identification information to peers."

[config."lighthouse-regtest.conf".ivars."proposer_only"]
type = "string"
default = ""
priority = "low"
summary = "Configure the beacon node to only perform block proposing in a minimal configuration."

[config."lighthouse-regtest.conf".ivars."purge_db"]
type = "string"
default = ""
priority = "low"
summary = "Delete the chain database on startup, use with caution."

[config."lighthouse-regtest.conf".ivars."reconstruct_historic_states"]
type = "string"
default = ""
priority = "low"
summary = "Reconstruct historic states in the database after checkpoint syncing, requires syncing back to genesis."

[config."lighthouse-regtest.conf".ivars."reset_payload_statuses"]
type = "string"
default = ""
priority = "low"
summary = "Forget the payload statuses of already-imported blocks to recover from consensus failures."

[config."lighthouse-regtest.conf".ivars."shutdown_after_sync"]
type = "string"
default = ""
priority = "low"
summary = "Shutdown the beacon node once sync is completed without performing backfill sync."

[config."lighthouse-regtest.conf".ivars."slasher"]
type = "string"
default = ""
priority = "low"
summary = "Run a slasher alongside the beacon node, recommended for expert users."

[config."lighthouse-regtest.conf".ivars."staking"]
type = "string"
default = ""
priority = "low"
summary = "Configure the beacon node for staking, enabling the HTTP server and deposit log import from the execution node."

[config."lighthouse-regtest.conf".ivars."subscribe_all_subnets"]
type = "string"
default = ""
priority = "low"
summary = "Subscribe to all subnets, advertising the node as long-lived and subscribed to all subnets."

[config."lighthouse-regtest.conf".ivars."validator_monitor_auto"]
type = "string"
default = ""
priority = "low"
summary = "Automatically detect and monitor validators connected to the HTTP API and subnet subscription endpoint."

[config."lighthouse-regtest.conf".ivars."zero_ports"]
type = "string"
default = ""
priority = "low"
summary = "Set all listening TCP/UDP ports to 0, allowing the OS to choose arbitrary free ports."


[config."lighthouse-regtest.conf".ivars."auto_compact_db"]
type = "string"
default = ""
priority = "low"
summary = "Enable or disable automatic compaction of the database on finalization."

[config."lighthouse-regtest.conf".ivars."blob_prune_margin_epochs"]
type = "string"
default = ""
priority = "low"
summary = "The margin for blob pruning in epochs. The oldest blobs are pruned up until data_availability_boundary - blob_prune_margin_epochs."

[config."lighthouse-regtest.conf".ivars."blobs_dir"]
type = "string"
default = ""
priority = "low"
summary = "The data directory for the blobs database."

[config."lighthouse-regtest.conf".ivars."block_cache_size"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the number of blocks the database should cache in memory."

# [config."lighthouse-regtest.conf".ivars."boot_nodes"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma-delimited list of base64-encoded ENR's or Multiaddrs to bootstrap the p2p network."

[config."lighthouse-regtest.conf".ivars."builder"]
type = "string"
default = ""
priority = "low"
summary = "The URL of a service compatible with the MEV-boost API."

[config."lighthouse-regtest.conf".ivars."builder_fallback_epochs_since_finalization"]
type = "string"
default = ""
priority = "low"
summary = "The number of epochs since the last finalization before the node will stop querying connected builders and use the local execution engine."

[config."lighthouse-regtest.conf".ivars."builder_fallback_skips"]
type = "string"
default = ""
priority = "low"
summary = "The number of consecutive skip slots on the canonical chain before the node will stop querying builders and use the local execution engine."

[config."lighthouse-regtest.conf".ivars."builder_fallback_skips_per_epoch"]
type = "string"
default = ""
priority = "low"
summary = "The number of skip slots in the past `SLOTS_PER_EPOCH` before the node stops querying builders and uses the local execution engine."

[config."lighthouse-regtest.conf".ivars."builder_profit_threshold"]
type = "string"
default = ""
priority = "low"
summary = "This flag is deprecated and has no effect."

[config."lighthouse-regtest.conf".ivars."builder_user_agent"]
type = "string"
default = ""
priority = "low"
summary = "The HTTP user agent string to send with requests to the builder URL."

[config."lighthouse-regtest.conf".ivars."checkpoint_blobs"]
type = "string"
default = ""
priority = "low"
summary = "Set the checkpoint blobs to start syncing from. Must match the --checkpoint-block."

[config."lighthouse-regtest.conf".ivars."checkpoint_block"]
type = "string"
default = ""
priority = "low"
summary = "Set a checkpoint block to start syncing from. Must align with --checkpoint-state."

[config."lighthouse-regtest.conf".ivars."checkpoint_state"]
type = "string"
default = ""
priority = "low"
summary = "Set a checkpoint state to start syncing from. Must align with --checkpoint-block."

[config."lighthouse-regtest.conf".ivars."checkpoint_sync_url"]
type = "string"
default = ""
priority = "low"
summary = "Set the remote beacon node HTTP endpoint for checkpoint syncing."

[config."lighthouse-regtest.conf".ivars."checkpoint_sync_url_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Set the timeout for checkpoint sync calls to a remote beacon node."

# [config."lighthouse-regtest.conf".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Specify a custom root data directory for Lighthouse keys and databases."

[config."lighthouse-regtest.conf".ivars."debug_level"]
type = "string"
default = ""
priority = "low"
summary = "Set the verbosity level for emitting logs to the terminal."

[config."lighthouse-regtest.conf".ivars."discovery_port"]
type = "string"
default = ""
priority = "low"
summary = "The UDP port for the discovery protocol to listen on."

[config."lighthouse-regtest.conf".ivars."discovery_port6"]
type = "string"
default = ""
priority = "low"
summary = "The UDP port for discovery over IPv6 when listening on both IPv4 and IPv6."

# [config."lighthouse-regtest.conf".ivars."enr_address"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The IP or DNS address to broadcast to other peers for connecting to the node."

[config."lighthouse-regtest.conf".ivars."enr_quic_port"]
type = "string"
default = ""
priority = "low"
summary = "The QUIC UDP4 port set in the local ENR for other nodes to connect to over IPv4."

[config."lighthouse-regtest.conf".ivars."enr_quic6_port"]
type = "string"
default = ""
priority = "low"
summary = "The QUIC UDP6 port set in the local ENR for other nodes to connect to over IPv6."

# [config."lighthouse-regtest.conf".ivars."enr_tcp_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The TCP4 port for the local ENR, used for incoming connections over IPv4."

[config."lighthouse-regtest.conf".ivars."enr_tcp6_port"]
type = "string"
default = ""
priority = "low"
summary = "The TCP6 port for the local ENR, used for incoming connections over IPv6."

# [config."lighthouse-regtest.conf".ivars."enr_udp_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The UDP4 port for the local ENR, used for incoming connections over IPv4."

[config."lighthouse-regtest.conf".ivars."enr_udp6_port"]
type = "string"
default = ""
priority = "low"
summary = "The UDP6 port for the local ENR, used for incoming connections over IPv6."

[config."lighthouse-regtest.conf".ivars."epochs_per_blob_prune"]
type = "string"
default = ""
priority = "low"
summary = "The interval in epochs for pruning blobs from the database when they are older than the data availability boundary."

[config."lighthouse-regtest.conf".ivars."epochs_per_migration"]
type = "string"
default = ""
priority = "low"
summary = "The number of epochs between migrations of data from the hot DB to the cold DB."

[config."lighthouse-regtest.conf".ivars."eth1_blocks_per_log_query"]
type = "string"
default = ""
priority = "low"
summary = "The number of blocks that a deposit log query should span to reduce the size of responses from the Eth1 endpoint."

[config."lighthouse-regtest.conf".ivars."eth1_cache_follow_distance"]
type = "string"
default = ""
priority = "low"
summary = "The distance between the Eth1 chain head and the last block to import into the cache."

# [config."lighthouse-regtest.conf".ivars."execution_endpoint"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Server endpoint for an execution layer JWT-authenticated HTTP JSON-RPC connection."

# [config."lighthouse-regtest.conf".ivars."execution_jwt"]
# type = "string"
# default = ""
# priority = "low"
# summary = "File path containing the hex-encoded JWT secret for the execution endpoint."

[config."lighthouse-regtest.conf".ivars."execution_jwt_id"]
type = "string"
default = ""
priority = "low"
summary = "Unique identifier used by the beacon node for JWT authentication with the execution layer."

[config."lighthouse-regtest.conf".ivars."execution_jwt_secret_key"]
type = "string"
default = ""
priority = "low"
summary = "Hex-encoded JWT secret key for the execution endpoint."

[config."lighthouse-regtest.conf".ivars."execution_jwt_version"]
type = "string"
default = ""
priority = "low"
summary = "Client version communicated during JWT authentication with execution nodes."

[config."lighthouse-regtest.conf".ivars."execution_timeout_multiplier"]
type = "string"
default = ""
priority = "low"
summary = "Unsigned integer to multiply the default execution timeouts by."

[config."lighthouse-regtest.conf".ivars."fork_choice_before_proposal_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Set the maximum number of milliseconds to wait for fork choice before proposing a block."

[config."lighthouse-regtest.conf".ivars."freezer_dir"]
type = "string"
default = ""
priority = "low"
summary = "Specify the data directory for the freezer database."

[config."lighthouse-regtest.conf".ivars."genesis_state_url"]
type = "string"
default = ""
priority = "low"
summary = "URL of a beacon-API compatible server from which to download the genesis state."

[config."lighthouse-regtest.conf".ivars."genesis_state_url_timeout"]
type = "string"
default = ""
priority = "low"
summary = "The timeout in seconds for the request to download the genesis state from the specified URL."

[config."lighthouse-regtest.conf".ivars."graffiti"]
type = "string"
default = ""
priority = "low"
summary = "Specify a custom graffiti to be included in blocks. Limited to 32 bytes."

[config."lighthouse-regtest.conf".ivars."historic_state_cache_size"]
type = "string"
default = ""
priority = "low"
summary = "Specifies how many states from the freezer database should be cached in memory."

# [config."lighthouse-regtest.conf".ivars."http_address"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Set the listen address for the RESTful HTTP API server."

[config."lighthouse-regtest.conf".ivars."http_allow_origin"]
type = "string"
default = ""
priority = "low"
summary = "Set the value of the Access-Control-Allow-Origin response HTTP header."

[config."lighthouse-regtest.conf".ivars."http_duplicate_block_status"]
type = "string"
default = ""
priority = "low"
summary = "Status code to return when a block that is already known is POSTed to the HTTP API."

[config."lighthouse-regtest.conf".ivars."http_enable_beacon_processor"]
type = "string"
default = ""
priority = "low"
summary = "Enable or disable the beacon processor scheduler for HTTP API requests."

# [config."lighthouse-regtest.conf".ivars."http_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Set the listen TCP port for the RESTful HTTP API server."

[config."lighthouse-regtest.conf".ivars."http_spec_fork"]
type = "string"
default = ""
priority = "low"
summary = "Serve the spec for a specific hard fork at /eth/v1/config/spec."

[config."lighthouse-regtest.conf".ivars."http_sse_capacity_multiplier"]
type = "string"
default = ""
priority = "low"
summary = "Multiplier for the length of HTTP SSE (Server-Sent Event) channels."

[config."lighthouse-regtest.conf".ivars."http_tls_cert"]
type = "string"
default = ""
priority = "low"
summary = "Path to the certificate to use when serving the HTTP API over TLS."

[config."lighthouse-regtest.conf".ivars."http_tls_key"]
type = "string"
default = ""
priority = "low"
summary = "Path to the private key to use when serving the HTTP API over TLS."

[config."lighthouse-regtest.conf".ivars."invalid_gossip_verified_blocks_path"]
type = "string"
default = ""
priority = "low"
summary = "Path to store SSZ files of blocks that pass gossip validation but fail full validation."

[config."lighthouse-regtest.conf".ivars."libp2p_addresses"]
type = "string"
default = ""
priority = "low"
summary = "Comma-delimited list of multiaddrs to manually connect to a libp2p peer."

# [config."lighthouse-regtest.conf".ivars."listen_address"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Specify the address Lighthouse will listen on for UDP and TCP connections."

[config."lighthouse-regtest.conf".ivars."log_format"]
type = "string"
default = ""
priority = "low"
summary = "Specify the log format when emitting logs to the terminal."

# [config."lighthouse-regtest.conf".ivars."logfile"]
# type = "string"
# default = ""
# priority = "low"
# summary = "File path where the log file will be stored."

[config."lighthouse-regtest.conf".ivars."logfile_debug_level"]
type = "string"
default = ""
priority = "low"
summary = "Set the verbosity level for emitting logs to the log file."

[config."lighthouse-regtest.conf".ivars."logfile_format"]
type = "string"
default = ""
priority = "low"
summary = "Specify the log format used when emitting logs to the logfile."

[config."lighthouse-regtest.conf".ivars."logfile_max_number"]
type = "string"
default = ""
priority = "low"
summary = "Set the maximum number of log files to store before overwriting the oldest one."

[config."lighthouse-regtest.conf".ivars."logfile_max_size"]
type = "string"
default = ""
priority = "low"
summary = "Set the maximum size in MB each log file can grow to before rotating."


[config."lighthouse-regtest.conf".ivars."max_skip_slots"]
type = "string"
default = ""
priority = "low"
summary = "Refuse to skip more than this number of slots when processing an attestation."

[config."lighthouse-regtest.conf".ivars."metrics_address"]
type = "string"
default = ""
priority = "low"
summary = "Set the listen address for the Prometheus metrics HTTP server."

[config."lighthouse-regtest.conf".ivars."metrics_allow_origin"]
type = "string"
default = ""
priority = "low"
summary = "Set the value of the Access-Control-Allow-Origin response HTTP header for Prometheus metrics."

[config."lighthouse-regtest.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = "Set the listen TCP port for the Prometheus metrics HTTP server."

[config."lighthouse-regtest.conf".ivars."monitoring_endpoint"]
type = "string"
default = ""
priority = "low"
summary = "Enable the monitoring service for sending system metrics to a remote endpoint."

[config."lighthouse-regtest.conf".ivars."monitoring_endpoint_period"]
type = "string"
default = ""
priority = "low"
summary = "Set the interval in seconds between sending messages to the monitoring endpoint."

# [config."lighthouse-regtest.conf".ivars."network"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Specify the name of the Eth2 chain to sync and follow (e.g., mainnet, prater, goerli)."

[config."lighthouse-regtest.conf".ivars."network_dir"]
type = "string"
default = ""
priority = "low"
summary = "Specify the data directory for network keys."

# [config."lighthouse-regtest.conf".ivars."port"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Set the TCP/UDP port for listening. Defaults to 9000 for IPv4."

[config."lighthouse-regtest.conf".ivars."port6"]
type = "string"
default = ""
priority = "low"
summary = "Set the TCP/UDP port for IPv6 listening. Defaults to 9090."

[config."lighthouse-regtest.conf".ivars."prepare_payload_lookahead"]
type = "string"
default = ""
priority = "low"
summary = "Set the time before a proposal slot to send payload attributes."

[config."lighthouse-regtest.conf".ivars."progressive_balances"]
type = "string"
default = ""
priority = "low"
summary = "Control the progressive balances cache mode (fast, checked, strict, or disabled)."

[config."lighthouse-regtest.conf".ivars."proposer_reorg_cutoff"]
type = "string"
default = ""
priority = "low"
summary = "Maximum delay after the start of the slot at which to propose a reorging block."

[config."lighthouse-regtest.conf".ivars."proposer_reorg_disallowed_offsets"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of integer offsets to avoid proposing reorgs at certain slots."

[config."lighthouse-regtest.conf".ivars."proposer_reorg_epochs_since_finalization"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of epochs since finalization at which proposer reorgs are allowed."

[config."lighthouse-regtest.conf".ivars."proposer_reorg_threshold"]
type = "string"
default = ""
priority = "low"
summary = "Set the percentage of vote weight below which to attempt a proposer reorg."

[config."lighthouse-regtest.conf".ivars."prune_blobs"]
type = "string"
default = ""
priority = "low"
summary = "Prune blobs from the database when they are older than the data availability boundary."

[config."lighthouse-regtest.conf".ivars."prune_payloads"]
type = "string"
default = ""
priority = "low"
summary = "Prune execution payloads from the database to save space."

# [config."lighthouse-regtest.conf".ivars."quic_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Set the UDP port for QUIC. Defaults to `port` + 1."

[config."lighthouse-regtest.conf".ivars."quic_port6"]
type = "string"
default = ""
priority = "low"
summary = "Set the UDP port for QUIC over IPv6. Defaults to `port6` + 1."


[config."lighthouse-regtest.conf".ivars."safe_slots_to_import_optimistically"]
type = "string"
default = ""
priority = "low"
summary = "Manual override of the SAFE_SLOTS_TO_IMPORT_OPTIMISTICALLY parameter. Use only if coordinated by the Ethereum community."

[config."lighthouse-regtest.conf".ivars."shuffling_cache_size"]
type = "string"
default = ""
priority = "low"
summary = "Set the shuffling cache size in epochs, useful for optimizing some HTTP API requests."

[config."lighthouse-regtest.conf".ivars."slasher_att_cache_size"]
type = "string"
default = ""
priority = "low"
summary = "Set the maximum number of attestation roots for the slasher to cache."

[config."lighthouse-regtest.conf".ivars."slasher_backend"]
type = "string"
default = ""
priority = "low"
summary = "Set the database backend to be used by the slasher (lmdb, disabled)."

[config."lighthouse-regtest.conf".ivars."slasher_broadcast"]
type = "string"
default = ""
priority = "low"
summary = "Broadcast slashings found by the slasher to the rest of the network (enabled by default)."

[config."lighthouse-regtest.conf".ivars."slasher_chunk_size"]
type = "string"
default = ""
priority = "low"
summary = "Set the number of epochs per validator per chunk stored on disk by the slasher."

[config."lighthouse-regtest.conf".ivars."slasher_dir"]
type = "string"
default = ""
priority = "low"
summary = "Set the slasher's database directory."

[config."lighthouse-regtest.conf".ivars."slasher_history_length"]
type = "string"
default = ""
priority = "low"
summary = "Set the number of epochs of history the slasher keeps. Immutable after initialization."

[config."lighthouse-regtest.conf".ivars."slasher_max_db_size"]
type = "string"
default = ""
priority = "low"
summary = "Set the maximum size of the slasher's MDBX database."

[config."lighthouse-regtest.conf".ivars."slasher_slot_offset"]
type = "string"
default = ""
priority = "low"
summary = "Set the delay from the start of the slot for the slasher to ingest attestations."

[config."lighthouse-regtest.conf".ivars."slasher_update_period"]
type = "string"
default = ""
priority = "low"
summary = "Set how often the slasher runs batch processing."

[config."lighthouse-regtest.conf".ivars."slasher_validator_chunk_size"]
type = "string"
default = ""
priority = "low"
summary = "Set the number of validators per chunk stored on disk by the slasher."

# [config."lighthouse-regtest.conf".ivars."slots_per_restore_point"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Specify how often a freezer DB restore point should be stored."

[config."lighthouse-regtest.conf".ivars."state_cache_size"]
type = "string"
default = ""
priority = "low"
summary = "Set the size of the snapshot cache."

# [config."lighthouse-regtest.conf".ivars."suggested_fee_recipient"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Specify an emergency fallback fee recipient for block production in case the validator client lacks one."

[config."lighthouse-regtest.conf".ivars."target_peers"]
type = "string"
default = ""
priority = "low"
summary = "Set the target number of peers."

[config."lighthouse-regtest.conf".ivars."terminal_block_hash_epoch_override"]
type = "string"
default = ""
priority = "low"
summary = "Manually override the TERMINAL_BLOCK_HASH_ACTIVATION_EPOCH parameter. Use only when coordinated by the Ethereum community."

[config."lighthouse-regtest.conf".ivars."terminal_block_hash_override"]
type = "string"
default = ""
priority = "low"
summary = "Manually override the TERMINAL_BLOCK_HASH parameter. Use only when coordinated by the Ethereum community."

[config."lighthouse-regtest.conf".ivars."terminal_total_difficulty_override"]
type = "string"
default = ""
priority = "low"
summary = "Manually override the TERMINAL_TOTAL_DIFFICULTY parameter. Use only when coordinated by the Ethereum community."

# [config."lighthouse-regtest.conf".ivars."testnet_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to directory containing eth2_testnet specs. Defaults to a hard-coded Lighthouse testnet. Only effective if there is no existing database."


[config."lighthouse-regtest.conf".ivars."trusted_peers"]
type = "string"
default = ""
priority = "low"
summary = "Comma-delimited list of trusted peer IDs which always have the highest score in the peer scoring system."

[config."lighthouse-regtest.conf".ivars."trusted_setup_file_override"]
type = "string"
default = ""
priority = "low"
summary = "Path to a JSON file containing the trusted setup parameters, overriding the mainnet kzg ceremony setup."

[config."lighthouse-regtest.conf".ivars."validator_monitor_file"]
type = "string"
default = ""
priority = "low"
summary = "Path to a file containing a comma-separated list of validator public keys for monitoring."

[config."lighthouse-regtest.conf".ivars."validator_monitor_individual_tracking_threshold"]
type = "string"
default = ""
priority = "low"
summary = "Set the number of local validators at which point per-validator metrics are replaced by aggregate metrics."

[config."lighthouse-regtest.conf".ivars."validator_monitor_pubkeys"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of 0x-prefixed validator public keys for special monitoring and logging."

[config."lighthouse-regtest.conf".ivars."wss_checkpoint"]
type = "string"
default = ""
priority = "low"
summary = "Specify a weak subjectivity checkpoint in `block_root:epoch` format to verify the node's sync."
