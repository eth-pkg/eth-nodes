name = "eth-node-lodestar-regtest"
bin_package = "eth-node-lodestar"
binary = "/usr/lib/eth-node-lodestar-regtest/run-lodestar-service.sh"
user = { name = "eth-node-lodestar-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-lodestar-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/lodestar
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
# TODO: this specially not working with only lodestar
# SystemCallFilter=@system-service
# does not work with lodestar as well
#SystemCallFilter=~@privileged @resources @obsolete
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/lodestar
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lodestar-service.sh /usr/lib/eth-node-lodestar-regtest/", 
    "debian/scripts/run-lodestar.sh /usr/lib/eth-node-lodestar-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lodestar-regtest",
    "debian/tmp/eth-node-lodestar-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-lodestar for network: regtest"

[config."lodestar-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lodestar-regtest/postprocess.sh"]

[config."lodestar-regtest.conf"]
format = "plain"

[config."lodestar-regtest.conf".ivars."data_dir"]
type = "string"
default = "$DATA_DIR/lodestar"
priority = "low"
summary = "Lodestar root data directory"


[config."lodestar-regtest.conf".ivars."eth1_deposit_contract_deploy_block"]
type = "string"
default = "0"
priority = "low"
summary = "Eth1 deposit contract deploy block number"

[config."lodestar-regtest.conf".ivars."network_connect_to_discv5_bootnodes"]
type = "string"
default = "false"
priority = "low"
summary = "Whether to connect to discv5 bootnodes"

[config."lodestar-regtest.conf".ivars."discv5"]
type = "string"
default = "true"
priority = "low"
summary = "Enable discv5 discovery"

[config."lodestar-regtest.conf".ivars."eth1"]
type = "string"
default = "true"
priority = "low"
summary = "Follow the Eth1 chain"

[config."lodestar-regtest.conf".ivars."eth1_provider_urls"]
type = "string"
default = ""
priority = "low"
summary = "URLs to Eth1 node with enabled RPC"

[config."lodestar-regtest.conf".ivars."rest"]
type = "string"
default = "true"
priority = "low"
summary = "Enable or disable HTTP API"

[config."lodestar-regtest.conf".ivars."rest_address"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Set host for HTTP API"

[config."lodestar-regtest.conf".ivars."nat"]
type = "string"
default = "true"
priority = "low"
summary = "Allow non-local addresses configuration"

[config."lodestar-regtest.conf".ivars."subscribe_all_subnets"]
type = "string"
default = "true"
priority = "low"
summary = "Subscribe to all subnets regardless of validator count"

[config."lodestar-regtest.conf".ivars."jwt_secret"]
type = "string"
default = "$JWT_FILE"
priority = "low"
summary = "Path to shared JWT secret for authentication with EL client's RPC server"

[config."lodestar-regtest.conf".ivars."params_file"]
type = "string"
default = "$TESTNET_DIR/config.yaml"
priority = "low"
summary = "Network configuration file"

[config."lodestar-regtest.conf".ivars."genesis_state_file"]
type = "string"
default = "$TESTNET_DIR/genesis.ssz"
priority = "low"
summary = "Genesis state file for custom network"

[config."lodestar-regtest.conf".ivars."bootnodes"]
type = "string"
default = ""
priority = "low"
summary = "Bootnodes for discv5 discovery"


[config."lodestar-regtest.conf".ivars."rest_port"]
type = "string"
default = "$CL_RPC_PORT"
priority = "low"
summary = "Set port for HTTP API (custom config)"

[config."lodestar-regtest.conf".ivars."suggested_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = ""

[config."lodestar-regtest.conf".ivars."log_file"]
type = "string"
default = "$LOG_DIR/lodestar/lodestar.log"
priority = "low"
summary = "Path to output all logs to a persistent log file"

#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################

# weak subjectivity
[config."lodestar-regtest.conf".ivars."checkpoint_sync_url"]
type = "string"
default = ""
priority = "low"
summary = "Server URL hosting Beacon Node APIs to fetch weak subjectivity state"

[config."lodestar-regtest.conf".ivars."checkpoint_state"]
type = "string"
default = ""
priority = "low"
summary = "Set a checkpoint state to start syncing from"

[config."lodestar-regtest.conf".ivars."wss_checkpoint"]
type = "string"
default = ""
priority = "low"
summary = "Start beacon node from weak subjectivity checkpoint in <blockRoot>:<epoch> format"

[config."lodestar-regtest.conf".ivars."force_checkpoint_sync"]
type = "string"
default = ""
priority = "low"
summary = "Force syncing from checkpoint state even if the database is within the weak subjectivity period"

# api
# [config."lodestar-regtest.conf".ivars."rest"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Enable or disable HTTP API"

[config."lodestar-regtest.conf".ivars."rest_namespace"]
type = "string"
default = ""
priority = "low"
summary = "Pick namespaces to expose for HTTP API"

[config."lodestar-regtest.conf".ivars."rest_cors"]
type = "string"
default = ""
priority = "low"
summary = "Configures Access-Control-Allow-Origin CORS header for HTTP API"

# [config."lodestar-regtest.conf".ivars."rest_address"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Set host for HTTP API"

# [config."lodestar-regtest.conf".ivars."rest_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Set port for HTTP API"

[config."lodestar-regtest.conf".ivars."rest_swagger_ui"]
type = "string"
default = ""
priority = "low"
summary = "Enable Swagger UI for API exploration"

# chain
# [config."lodestar-regtest.conf".ivars."suggested_fee_recipient"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Specify fee recipient for collecting EL block fees and rewards"

[config."lodestar-regtest.conf".ivars."emit_payload_attributes"]
type = "string"
default = ""
priority = "low"
summary = "Flag to SSE emit execution payload attributes before every slot"

[config."lodestar-regtest.conf".ivars."chain_archive_blob_epochs"]
type = "string"
default = ""
priority = "low"
summary = "Number of epochs to retain finalized blobs"

# eth1
# [config."lodestar-regtest.conf".ivars."eth1"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Follow the eth1 chain"

# [config."lodestar-regtest.conf".ivars."eth1_provider_urls"]
# type = "string"
# default = ""
# priority = "low"
# summary = "URLs to Eth1 node with enabled RPC"

# execution
[config."lodestar-regtest.conf".ivars."execution_urls"]
type = "string"
default = ""
priority = "low"
summary = "URLs to execution client engine API"

[config."lodestar-regtest.conf".ivars."execution_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Timeout for execution engine API HTTP client in milliseconds"

[config."lodestar-regtest.conf".ivars."execution_retries"]
type = "string"
default = ""
priority = "low"
summary = "Number of retries when calling execution engine API"

[config."lodestar-regtest.conf".ivars."execution_retry_delay"]
type = "string"
default = ""
priority = "low"
summary = "Delay time in milliseconds between retries for execution engine API calls"

[config."lodestar-regtest.conf".ivars."execution_engine_mock"]
type = "string"
default = ""
priority = "low"
summary = "Set the execution engine to mock mode (development only)"

# [config."lodestar-regtest.conf".ivars."jwt_secret"]
# type = "string"
# default = ""
# priority = "low"
# summary = "File path to hex-encoded JWT secret for authentication with EL client’s engine API"

[config."lodestar-regtest.conf".ivars."jwt_id"]
type = "string"
default = ""
priority = "low"
summary = "Optional identifier for JWT tokens used for authentication with EL client’s engine API"

# builder
[config."lodestar-regtest.conf".ivars."builder"]
type = "string"
default = ""
priority = "low"
summary = "Enable builder interface"

[config."lodestar-regtest.conf".ivars."builder_url"]
type = "string"
default = ""
priority = "low"
summary = "URL hosting the builder API"

[config."lodestar-regtest.conf".ivars."builder_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Timeout for builder API HTTP client in milliseconds"

[config."lodestar-regtest.conf".ivars."builder_fault_inspection_window"]
type = "string"
default = ""
priority = "low"
summary = "Window to inspect missed slots for enabling/disabling builder circuit breaker"

[config."lodestar-regtest.conf".ivars."builder_allowed_faults"]
type = "string"
default = ""
priority = "low"
summary = "Number of missed slots allowed in the fault inspection window for builder circuit"

# metrics
[config."lodestar-regtest.conf".ivars."metrics"]
type = "string"
default = ""
priority = "low"
summary = "Enable the Prometheus metrics HTTP server"

[config."lodestar-regtest.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = "TCP port for the Prometheus metrics HTTP server"

[config."lodestar-regtest.conf".ivars."metrics_address"]
type = "string"
default = ""
priority = "low"
summary = "Address for the Prometheus metrics HTTP server"

# monitoring
[config."lodestar-regtest.conf".ivars."monitoring_endpoint"]
type = "string"
default = ""
priority = "low"
summary = "Monitoring service endpoint for sending client stats"

[config."lodestar-regtest.conf".ivars."monitoring_interval"]
type = "string"
default = ""
priority = "low"
summary = "Interval in milliseconds between sending client stats to the remote service"

# network
# [config."lodestar-regtest.conf".ivars."discv5"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Enable discv5"

[config."lodestar-regtest.conf".ivars."listen_address"]
type = "string"
default = ""
priority = "low"
summary = "IPv4 address to listen for p2p UDP and TCP connections"

[config."lodestar-regtest.conf".ivars."port"]
type = "string"
default = ""
priority = "low"
summary = "TCP/UDP port to listen on"

[config."lodestar-regtest.conf".ivars."discovery_port"]
type = "string"
default = ""
priority = "low"
summary = "UDP port that discovery will listen on"

[config."lodestar-regtest.conf".ivars."listen_address6"]
type = "string"
default = ""
priority = "low"
summary = "IPv6 address to listen for p2p UDP and TCP connections"

[config."lodestar-regtest.conf".ivars."port6"]
type = "string"
default = ""
priority = "low"
summary = "TCP/UDP port to listen on (IPv6-specific)"

[config."lodestar-regtest.conf".ivars."discovery_port6"]
type = "string"
default = ""
priority = "low"
summary = "UDP port that discovery will listen on (IPv6-specific)"

# [config."lodestar-regtest.conf".ivars."bootnodes"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Bootnodes for discv5 discovery"

[config."lodestar-regtest.conf".ivars."target_peers"]
type = "string"
default = ""
priority = "low"
summary = "Target number of connected peers"

# [config."lodestar-regtest.conf".ivars."subscribe_all_subnets"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Subscribe to all subnets regardless of validator count"

[config."lodestar-regtest.conf".ivars."disable_peer_scoring"]
type = "string"
default = ""
priority = "low"
summary = "Disable peer scoring, used for testing on devnets"

[config."lodestar-regtest.conf".ivars."mdns"]
type = "string"
default = ""
priority = "low"
summary = "Enable mdns local peer discovery"

# enr
[config."lodestar-regtest.conf".ivars."enr_ip"]
type = "string"
default = ""
priority = "low"
summary = "Override ENR IP entry"

[config."lodestar-regtest.conf".ivars."enr_tcp"]
type = "string"
default = ""
priority = "low"
summary = "Override ENR TCP entry"

[config."lodestar-regtest.conf".ivars."enr_udp"]
type = "string"
default = ""
priority = "low"
summary = "Override ENR UDP entry"

[config."lodestar-regtest.conf".ivars."enr_ip6"]
type = "string"
default = ""
priority = "low"
summary = "Override ENR IPv6 entry"

[config."lodestar-regtest.conf".ivars."enr_tcp6"]
type = "string"
default = ""
priority = "low"
summary = "Override ENR (IPv6-specific) TCP entry"

[config."lodestar-regtest.conf".ivars."enr_udp6"]
type = "string"
default = ""
priority = "low"
summary = "Override ENR (IPv6-specific) UDP entry"

# [config."lodestar-regtest.conf".ivars."nat"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Allow configuration of non-local addresses"

# options
# [config."lodestar-regtest.conf".ivars."data_dir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Lodestar root data directory"

[config."lodestar-regtest.conf".ivars."network"]
type = "string"
default = ""
priority = "low"
summary = "Name of the Ethereum Consensus chain network to join"

# [config."lodestar-regtest.conf".ivars."params_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Network configuration file"

[config."lodestar-regtest.conf".ivars."terminal_total_difficulty_override"]
type = "string"
default = ""
priority = "low"
summary = "Terminal PoW block TTD override"

[config."lodestar-regtest.conf".ivars."terminal_block_hash_override"]
type = "string"
default = ""
priority = "low"
summary = "Terminal PoW block hash override"

[config."lodestar-regtest.conf".ivars."terminal_block_hash_epoch_override"]
type = "string"
default = ""
priority = "low"
summary = "Terminal PoW block hash override activation epoch"

[config."lodestar-regtest.conf".ivars."rc_config"]
type = "string"
default = ""
priority = "low"
summary = "RC file to supplement command line arguments, accepted formats: .yml, .yaml, .json"

[config."lodestar-regtest.conf".ivars."private"]
type = "string"
default = ""
priority = "low"
summary = "Do not send implementation details over p2p identify protocol"

[config."lodestar-regtest.conf".ivars."validator_monitor_logs"]
type = "string"
default = ""
priority = "low"
summary = "Log validator monitor events, requires metrics to be enabled"

[config."lodestar-regtest.conf".ivars."disable_light_client_server"]
type = "string"
default = ""
priority = "low"
summary = "Disable light client server"

[config."lodestar-regtest.conf".ivars."log_level"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity level for emitting logs to terminal"

# [config."lodestar-regtest.conf".ivars."log_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to output all logs to a persistent log file"

[config."lodestar-regtest.conf".ivars."log_file_level"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity level for emitting logs to file"

[config."lodestar-regtest.conf".ivars."log_file_daily_rotate"]
type = "string"
default = ""
priority = "low"
summary = "Daily rotate log files, set to an integer to limit the file count, set to 0 to disable rotation"



######################### Undocumented Options ##############################################

# [config."lodestar-regtest.conf".ivars."eth1_deposit_contract_deploy_block"]
# type = "string"
# default = ""
# priority = "low"
# summary = "ETH1 deposit contract deployment block"

# [config."lodestar-regtest.conf".ivars."network_connect_to_discv5_bootnodes"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Network connection to discv5 bootnodes"

# [config."lodestar-regtest.conf".ivars."genesis_state_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Genesis state file for the Beacon node"

######################### END of Undocumented Options ##############################################
