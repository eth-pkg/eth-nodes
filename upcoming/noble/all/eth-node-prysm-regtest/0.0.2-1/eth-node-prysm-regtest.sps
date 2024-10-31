name = "eth-node-prysm-regtest"
bin_package = "eth-node-prysm"
binary = "/usr/lib/eth-node-prysm-regtest/run-prysm-service.sh"
user = { name = "eth-node-prysm-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-prysm-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/prysm
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/prysm
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-prysm-service.sh /usr/lib/eth-node-prysm-regtest/", 
    "debian/scripts/run-prysm.sh /usr/lib/eth-node-prysm-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-prysm-regtest",
    "debian/tmp/eth-node-prysm-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-prysm for network: regtest"

[config."prysm-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-prysm-regtest/postprocess.sh"]

[config."prysm-regtest.conf"]
format = "plain"

[config."prysm-regtest.conf".ivars."execution_endpoint"]
type = "string"
default = "$ENDPOINT_URL"
priority = "low"
summary = "An execution client HTTP endpoint. Can contain auth header as well in the format (default: 'http://localhost:8551')."

[config."prysm-regtest.conf".ivars."mainnet"]
type = "string"
default = "false"
priority = "low"
summary = "Runs on Ethereum main network. This is the default and can be omitted."

[config."prysm-regtest.conf".ivars."sepolia"]
type = "string"
default = "false"
priority = "low"
summary = "Runs Prysm configured for the Sepolia test network."

[config."prysm-regtest.conf".ivars."chain_id"]
type = "string"
default = "$NETWORK_ID"
priority = "low"
summary = "Sets the chain id of the beacon chain. (default: 0)"

[config."prysm-regtest.conf".ivars."jwt_secret"]
type = "string"
default = "$JWT_FILE"
priority = "low"
summary = "Path to a file containing a hex-encoded string representing a 32-byte secret for authentication with an execution node via HTTP. REQUIRED if connecting to an execution node via HTTP."

[config."prysm-regtest.conf".ivars."checkpoint_sync_url"]
type = "string"
default = "$CL_CHECKPPOINT_SYNC_URL"
priority = "low"
summary = "URL of a synced beacon node to trust in obtaining checkpoint sync data."

[config."prysm-regtest.conf".ivars."genesis_beacon_api_url"]
type = "string"
default = "$CL_BEACON_API_URL"
priority = "low"
summary = "URL of a synced beacon node to trust for obtaining the genesis state."

[config."prysm-regtest.conf".ivars."accept_terms_of_use"]
type = "string"
default = "true"
priority = "low"
summary = "Accepts Terms and Conditions (for non-interactive environments). (default: false)"

[config."prysm-regtest.conf".ivars."datadir"]
type = "string"
default = "$DATA_DIR/prysm"
priority = "low"
summary = "Data directory for the databases."

[config."prysm-regtest.conf".ivars."genesis_state"]
type = "string"
default = "$TESTNET_DIR/genesis.ssz"
priority = "low"
summary = "Load a genesis state from ssz file."

[config."prysm-regtest.conf".ivars."bootstrap_node"]
type = "string"
default = "$BOOTNODES_ENR"
priority = "low"
summary = "The address of bootstrap node. Beacon node will connect for peer discovery via DHT. Multiple nodes can be passed by using the flag multiple times but not comma-separated."

[config."prysm-regtest.conf".ivars."minimum_peers_per_subnet"]
type = "string"
default = "0"
priority = "low"
summary = "Sets the minimum number of peers that a node will attempt to peer with that are subscribed to a subnet. (default: 6)"

[config."prysm-regtest.conf".ivars."interop_eth1data_votes"]
type = "string"
default = "true"
priority = "low"
summary = "Enable mocking of eth1 data votes for proposers to package into blocks. (default: false)"

[config."prysm-regtest.conf".ivars."contract_deployment_block"]
type = "string"
default = "0"
priority = "low"
summary = "The eth1 block in which the deposit contract was deployed. (default: 11184524)"

[config."prysm-regtest.conf".ivars."min_sync_peers"]
type = "string"
default = "0"
priority = "low"
summary = "The required number of valid peers to connect with before syncing. (default: 3)"

[config."prysm-regtest.conf".ivars."chain_config_file"]
type = "string"
default = "$TESTNET_DIR/config.yaml"
priority = "low"
summary = "Path to a YAML file with chain config values."

[config."prysm-regtest.conf".ivars."disable_grpc_gateway"]
type = "string"
default = "false"
priority = "low"
summary = "Disable the gRPC gateway for JSON-HTTP requests."

[config."prysm-regtest.conf".ivars."grpc_gateway_corsdomain"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of domains from which to accept cross-origin requests (browser enforced)"

[config."prysm-regtest.conf".ivars."grpc_gateway_host"]
type = "string"
default = ""
priority = "low"
summary = "The host on which the gRPC gateway server runs on."

[config."prysm-regtest.conf".ivars."grpc_gateway_port"]
type = "string"
default = "$CL_RPC_PORT"
priority = "low"
summary = "The port on which the gRPC gateway server runs."

[config."prysm-regtest.conf".ivars."http_modules"]
type = "string"
default = "eth"
priority = "low"
summary = "Comma-separated list of API module names."

[config."prysm-regtest.conf".ivars."suggested_fee_recipient"]
type = "string"
default = "$VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = "Post bellatrix, this address will receive the transaction fees produced by any blocks from this node. (default: \"0x0000000000000000000000000000000000000000\")"

[config."prysm-regtest.conf".ivars."log_file"]
type = "string"
default = "$LOG_DIR/prysm/prysm.log"
priority = "low"
summary = "Specifies log file name, relative or absolute."

#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################


# Global options

# [config."prysm-regtest.conf".ivars."accept_terms_of_use"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Accepts Terms and Conditions (for non-interactive environments). (default: false)"

[config."prysm-regtest.conf".ivars."api_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the timeout value for API requests in seconds. (default: 120)"

# [config."prysm-regtest.conf".ivars."bootstrap_node"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The address of bootstrap node. Beacon node will connect for peer discovery via DHT. Multiple nodes can be passed by using the flag multiple times but not comma-separated."

# [config."prysm-regtest.conf".ivars."chain_config_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to a YAML file with chain config values."

[config."prysm-regtest.conf".ivars."clear_db"]
type = "string"
default = ""
priority = "low"
summary = "Prompt for clearing any previously stored data at the data directory. (default: false)"

[config."prysm-regtest.conf".ivars."config_file"]
type = "string"
default = ""
priority = "low"
summary = "Filepath to a yaml file with flag values."

# [config."prysm-regtest.conf".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Data directory for the databases. (default: \"$HOME/.eth2\")"

[config."prysm-regtest.conf".ivars."disable_monitoring"]
type = "string"
default = ""
priority = "low"
summary = "Disables monitoring service. (default: false)"

[config."prysm-regtest.conf".ivars."e2e_config"]
type = "string"
default = ""
priority = "low"
summary = "Enables the E2E testing config, only for use within end-to-end testing. (default: false)"

[config."prysm-regtest.conf".ivars."enable_tracing"]
type = "string"
default = ""
priority = "low"
summary = "Enables request tracing. (default: false)"

[config."prysm-regtest.conf".ivars."force_clear_db"]
type = "string"
default = ""
priority = "low"
summary = "Clears any previously stored data at the data directory. (default: false)"

[config."prysm-regtest.conf".ivars."grpc_max_msg_size"]
type = "string"
default = ""
priority = "low"
summary = "Integer to define max receive message call size (in bytes). (default: 2147483647)"

[config."prysm-regtest.conf".ivars."max_goroutines"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the upper limit of goroutines running before a status check fails. (default: 5000)"

[config."prysm-regtest.conf".ivars."minimal_config"]
type = "string"
default = ""
priority = "low"
summary = "Uses minimal config with parameters as defined in the spec. (default: false)"

[config."prysm-regtest.conf".ivars."monitor_indices"]
type = "string"
default = ""
priority = "low"
summary = "List of validator indices to track performance."

[config."prysm-regtest.conf".ivars."monitoring_host"]
type = "string"
default = ""
priority = "low"
summary = "Host used for listening and responding metrics for Prometheus. (default: \"127.0.0.1\")"

[config."prysm-regtest.conf".ivars."monitoring_port"]
type = "string"
default = ""
priority = "low"
summary = "Port used to listen and respond to metrics for Prometheus. (default: 8080)"

[config."prysm-regtest.conf".ivars."no_discovery"]
type = "string"
default = ""
priority = "low"
summary = "Enable only local network p2p and do not connect to cloud bootstrap nodes. (default: false)"

[config."prysm-regtest.conf".ivars."p2p_quic_port"]
type = "string"
default = ""
priority = "low"
summary = "The QUIC port used by libp2p. (default: 13000)"

[config."prysm-regtest.conf".ivars."p2p_tcp_port"]
type = "string"
default = ""
priority = "low"
summary = "The TCP port used by libp2p. (default: 13000)"

[config."prysm-regtest.conf".ivars."p2p_udp_port"]
type = "string"
default = ""
priority = "low"
summary = "The UDP port used by the discovery service discv5. (default: 12000)"

[config."prysm-regtest.conf".ivars."relay_node"]
type = "string"
default = ""
priority = "low"
summary = "The address of relay node. The beacon node will connect to the relay node and advertise their address via the relay node to other peers."

[config."prysm-regtest.conf".ivars."restore_source_file"]
type = "string"
default = ""
priority = "low"
summary = "Filepath to the backed-up database file which will be used to restore the database."

[config."prysm-regtest.conf".ivars."restore_target_dir"]
type = "string"
default = ""
priority = "low"
summary = "Target directory of the restored database. (default: \"$HOME/.eth2\")"

[config."prysm-regtest.conf".ivars."rpc_max_page_size"]
type = "string"
default = ""
priority = "low"
summary = "Max number of items returned per page in RPC responses for paginated endpoints. (default: 0)"

[config."prysm-regtest.conf".ivars."trace_sample_fraction"]
type = "string"
default = ""
priority = "low"
summary = "Indicates what fraction of p2p messages are sampled for tracing. (default: 0.2)"

[config."prysm-regtest.conf".ivars."tracing_endpoint"]
type = "string"
default = ""
priority = "low"
summary = "Tracing endpoint defines where beacon chain traces are exposed to Jaeger. (default: \"http://127.0.0.1:14268/api/traces\")"

[config."prysm-regtest.conf".ivars."tracing_process_name"]
type = "string"
default = ""
priority = "low"
summary = "Name to apply to tracing tag process_name."

[config."prysm-regtest.conf".ivars."verbosity"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity. (trace, debug, info, warn, error, fatal, panic) (default: \"info\")"

# debug options 

[config."prysm-regtest.conf".ivars."blockprofilerate"]
type = "string"
default = ""
priority = "low"
summary = "Turns on block profiling with the given rate. (default: 0)"

[config."prysm-regtest.conf".ivars."cpuprofile"]
type = "string"
default = ""
priority = "low"
summary = "Writes CPU profile to the given file."

[config."prysm-regtest.conf".ivars."memprofilerate"]
type = "string"
default = ""
priority = "low"
summary = "Turns on memory profiling with the given rate. (default: 524288)"

[config."prysm-regtest.conf".ivars."mutexprofilefraction"]
type = "string"
default = ""
priority = "low"
summary = "Turns on mutex profiling with the given rate. (default: 0)"

[config."prysm-regtest.conf".ivars."pprof"]
type = "string"
default = ""
priority = "low"
summary = "Enables the pprof HTTP server. (default: false)"

[config."prysm-regtest.conf".ivars."pprofaddr"]
type = "string"
default = ""
priority = "low"
summary = "pprof HTTP server listening interface. (default: \"127.0.0.1\")"

[config."prysm-regtest.conf".ivars."pprofport"]
type = "string"
default = ""
priority = "low"
summary = "pprof HTTP server listening port. (default: 6060)"

[config."prysm-regtest.conf".ivars."trace"]
type = "string"
default = ""
priority = "low"
summary = "Writes execution trace to the given file."

# beacon chain options 

[config."prysm-regtest.conf".ivars."backfill_batch_size"]
type = "string"
default = ""
priority = "low"
summary = "Number of blocks per backfill batch. A larger number will request more blocks at once from peers, but also consume more system memory to hold batches in memory during processing. (default: 32)"

[config."prysm-regtest.conf".ivars."backfill_oldest_slot"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the oldest slot that backfill should download. If this value is greater than current_slot - MIN_EPOCHS_FOR_BLOCK_REQUESTS, it will be ignored. (default: 0)"

[config."prysm-regtest.conf".ivars."backfill_worker_count"]
type = "string"
default = ""
priority = "low"
summary = "Number of concurrent backfill batch requests. A larger number will better utilize network resources, but will consume more system memory. (default: 2)"

[config."prysm-regtest.conf".ivars."blob_batch_limit"]
type = "string"
default = ""
priority = "low"
summary = "The amount of blobs the local peer is bounded to request and respond to in a batch. (default: 64)"

[config."prysm-regtest.conf".ivars."blob_batch_limit_burst_factor"]
type = "string"
default = ""
priority = "low"
summary = "The factor by which blob batch limit may increase on burst. (default: 2)"

[config."prysm-regtest.conf".ivars."blob_path"]
type = "string"
default = ""
priority = "low"
summary = "Location for blob storage. Default location will be a 'blobs' directory next to the beacon db."

[config."prysm-regtest.conf".ivars."blob_retention_epochs"]
type = "string"
default = ""
priority = "low"
summary = "Override the default blob retention period (measured in epochs). (default: 4096)"

[config."prysm-regtest.conf".ivars."block_batch_limit"]
type = "string"
default = ""
priority = "low"
summary = "The amount of blocks the local peer is bounded to request and respond to in a batch. Maximum 128. (default: 64)"

[config."prysm-regtest.conf".ivars."block_batch_limit_burst_factor"]
type = "string"
default = ""
priority = "low"
summary = "The factor by which block batch limit may increase on burst. (default: 2)"

# [config."prysm-regtest.conf".ivars."chain_id"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Sets the chain id of the beacon chain. (default: 0)"

[config."prysm-regtest.conf".ivars."checkpoint_block"]
type = "string"
default = ""
priority = "low"
summary = "Rather than syncing from genesis, specify a local file containing the checkpoint Block to load."

[config."prysm-regtest.conf".ivars."checkpoint_state"]
type = "string"
default = ""
priority = "low"
summary = "Rather than syncing from genesis, specify a local file containing the checkpoint BeaconState to load."

# [config."prysm-regtest.conf".ivars."checkpoint_sync_url"]
# type = "string"
# default = ""
# priority = "low"
# summary = "URL of a synced beacon node to trust in obtaining checkpoint sync data."

# [config."prysm-regtest.conf".ivars."contract_deployment_block"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The eth1 block in which the deposit contract was deployed. (default: 11184524)"

[config."prysm-regtest.conf".ivars."deposit_contract"]
type = "string"
default = ""
priority = "low"
summary = "Deposit contract address. Beacon chain node will listen to logs from the deposit contract to determine when a validator is eligible to participate. (default: \"0x00000000219ab540356cBB839Cbe05303d7705Fa\")"

[config."prysm-regtest.conf".ivars."disable_debug_rpc_endpoints"]
type = "string"
default = ""
priority = "low"
summary = "Disables the debug Beacon API namespace. (default: false)"

# [config."prysm-regtest.conf".ivars."disable_grpc_gateway"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Disable the gRPC gateway for JSON-HTTP requests. (default: false)"

[config."prysm-regtest.conf".ivars."enable_experimental_backfill"]
type = "string"
default = ""
priority = "low"
summary = "Backfill is still experimental. It will only be enabled if specified and the node was started using checkpoint sync. (default: false)"

[config."prysm-regtest.conf".ivars."engine_endpoint_timeout_seconds"]
type = "string"
default = ""
priority = "low"
summary = "Sets the execution engine timeout (in seconds) for execution payload semantics (forkchoiceUpdated, newPayload). (default: 0)"

[config."prysm-regtest.conf".ivars."eth1_header_req_limit"]
type = "string"
default = ""
priority = "low"
summary = "Sets the maximum number of headers that a deposit log query can fetch. (default: 1000)"

# [config."prysm-regtest.conf".ivars."execution_endpoint"]
# type = "string"
# default = ""
# priority = "low"
# summary = "An execution client HTTP endpoint. Can contain an auth header in the format. (default: \"http://localhost:8551\")"

[config."prysm-regtest.conf".ivars."execution_headers"]
type = "string"
default = ""
priority = "low"
summary = "A comma-separated list of key-value pairs to pass as HTTP headers for all execution client calls. Example: --execution-headers=key1=value1,key2=value2"

[config."prysm-regtest.conf".ivars."gc_percent"]
type = "string"
default = ""
priority = "low"
summary = "The percentage of freshly allocated data to live data on which the garbage collector (gc) will run again. (default: 100)"

# [config."prysm-regtest.conf".ivars."genesis_beacon_api_url"]
# type = "string"
# default = ""
# priority = "low"
# summary = "URL of a synced beacon node to trust for obtaining the genesis state."

# [config."prysm-regtest.conf".ivars."genesis_state"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Load a genesis state from an SSZ file. Testnet genesis files can be found in the eth2-clients/eth2-testnets repository on GitHub."

# [config."prysm-regtest.conf".ivars."grpc_gateway_corsdomain"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma-separated list of domains from which to accept cross-origin requests (browser enforced)"

# [config."prysm-regtest.conf".ivars."grpc_gateway_host"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The host on which the gRPC gateway server runs. (default: \"127.0.0.1\")"

# [config."prysm-regtest.conf".ivars."grpc_gateway_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The port on which the gRPC gateway server runs. (default: 3500)"

[config."prysm-regtest.conf".ivars."historical_slasher_node"]
type = "string"
default = ""
priority = "low"
summary = "Enables required flags for serving historical data to a slasher client. Results in additional storage usage. (default: false)"

[config."prysm-regtest.conf".ivars."http_mev_relay"]
type = "string"
default = ""
priority = "low"
summary = "A MEV builder relay string HTTP endpoint to interact with the MEV builder network. API defined in: https://ethereum.github.io/builder-specs/#/Builder"

# [config."prysm-regtest.conf".ivars."http_modules"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma-separated list of API module names. Possible values: prysm,eth. (default: \"prysm,eth\")"

# [config."prysm-regtest.conf".ivars."interop_eth1data_votes"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Enable mocking of eth1 data votes for proposers to package into blocks. (default: false)"

[config."prysm-regtest.conf".ivars."jwt_id"]
type = "string"
default = ""
priority = "low"
summary = "JWT claims ID. Could be used to identify the client."

# [config."prysm-regtest.conf".ivars."jwt_secret"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to a file containing a hex-encoded string representing a 32-byte secret for authentication with an execution node via HTTP. REQUIRED if connecting to an execution node via HTTP."

[config."prysm-regtest.conf".ivars."local_block_value_boost"]
type = "string"
default = ""
priority = "low"
summary = "A percentage boost for local block construction as a Uint64. Used to prioritize local block construction over relay/builder block construction. (default: 10)"

[config."prysm-regtest.conf".ivars."max_builder_consecutive_missed_slots"]
type = "string"
default = ""
priority = "low"
summary = "Number of consecutive skipped slots to fallback from using relay/builder to local execution engine for block construction. (default: 3)"

[config."prysm-regtest.conf".ivars."max_builder_epoch_missed_slots"]
type = "string"
default = ""
priority = "low"
summary = "Number of total skipped slots in the last epoch rolling window to fallback from using relay/builder to local execution engine for block construction. (default: 0)"

[config."prysm-regtest.conf".ivars."max_concurrent_dials"]
type = "string"
default = ""
priority = "low"
summary = "Sets the maximum number of peers that a node will attempt to dial from discovery. (default: 0)"

[config."prysm-regtest.conf".ivars."min_builder_bid"]
type = "string"
default = ""
priority = "low"
summary = "Minimum builder bid in Gwei for the beacon node to use the builder's block. Less than this and the beacon will revert to local building. (default: 0)"

[config."prysm-regtest.conf".ivars."min_builder_to_local_difference"]
type = "string"
default = ""
priority = "low"
summary = "Minimum difference in Gwei between the builder's bid and local block for the beacon node to use the builder's block. Less than this and the beacon will revert to local building. (default: 0)"

# [config."prysm-regtest.conf".ivars."minimum_peers_per_subnet"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Sets the minimum number of peers that a node will attempt to peer with that are subscribed to a subnet. (default: 6)"

[config."prysm-regtest.conf".ivars."network_id"]
type = "string"
default = ""
priority = "low"
summary = "Sets the network ID of the beacon chain. (default: 0)"

[config."prysm-regtest.conf".ivars."rpc_host"]
type = "string"
default = ""
priority = "low"
summary = "Host on which the RPC server should listen. (default: \"127.0.0.1\")"

[config."prysm-regtest.conf".ivars."rpc_port"]
type = "string"
default = ""
priority = "low"
summary = "RPC port exposed by a beacon node. (default: 4000)"

[config."prysm-regtest.conf".ivars."slasher_datadir"]
type = "string"
default = ""
priority = "low"
summary = "Directory for the slasher database. (default: \"$HOME/.eth2\")"

[config."prysm-regtest.conf".ivars."slots_per_archive_point"]
type = "string"
default = ""
priority = "low"
summary = "The slot durations of when an archived state gets saved in the beaconDB. (default: 2048)"

[config."prysm-regtest.conf".ivars."subscribe_all_subnets"]
type = "string"
default = ""
priority = "low"
summary = "Subscribe to all possible attestation and sync subnets. (default: false)"

[config."prysm-regtest.conf".ivars."tls_cert"]
type = "string"
default = ""
priority = "low"
summary = "Certificate for secure gRPC. Pass this and the tls-key flag to use gRPC securely."

[config."prysm-regtest.conf".ivars."tls_key"]
type = "string"
default = ""
priority = "low"
summary = "Key for secure gRPC. Pass this and the tls-cert flag to use gRPC securely."

[config."prysm-regtest.conf".ivars."weak_subjectivity_checkpoint"]
type = "string"
default = ""
priority = "low"
summary = "Input in block_root:epoch_number format. Guarantees that syncing leads to the given Weak Subjectivity Checkpoint along the canonical chain."

# merge options

# [config."prysm-regtest.conf".ivars."suggested_fee_recipient"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Post bellatrix, this address will receive the transaction fees produced by any blocks from this node. (default: \"0x0000000000000000000000000000000000000000\")"

[config."prysm-regtest.conf".ivars."terminal_block_hash_epoch_override"]
type = "string"
default = ""
priority = "low"
summary = "Sets the block hash epoch to manual overrides the default TERMINAL_BLOCK_HASH_ACTIVATION_EPOCH value. (default: 0)"

[config."prysm-regtest.conf".ivars."terminal_block_hash_override"]
type = "string"
default = ""
priority = "low"
summary = "Sets the block hash to manual overrides the default TERMINAL_BLOCK_HASH value."

[config."prysm-regtest.conf".ivars."terminal_total_difficulty_override"]
type = "string"
default = ""
priority = "low"
summary = "Sets the total difficulty to manual overrides the default TERMINAL_TOTAL_DIFFICULTY value."

# p2p Options

[config."prysm-regtest.conf".ivars."enable_upnp"]
type = "string"
default = ""
priority = "low"
summary = "Enable the service (Beacon chain or Validator) to use UPnP when possible. (default: false)"

# [config."prysm-regtest.conf".ivars."min_sync_peers"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The required number of valid peers to connect with before syncing. (default: 3)"

[config."prysm-regtest.conf".ivars."p2p_allowlist"]
type = "string"
default = ""
priority = "low"
summary = "The CIDR subnet for allowing only certain peer connections. Example: 192.168.0.0/16 would permit connections to peers on your local network only."

[config."prysm-regtest.conf".ivars."p2p_denylist"]
type = "string"
default = ""
priority = "low"
summary = "The CIDR subnets for denying certain peer connections. Example: 192.168.0.0/16 would deny connections from peers on your local network only."

[config."prysm-regtest.conf".ivars."p2p_host_dns"]
type = "string"
default = ""
priority = "low"
summary = "The DNS address advertised by libp2p. This may be used to advertise an external DNS."

[config."prysm-regtest.conf".ivars."p2p_host_ip"]
type = "string"
default = ""
priority = "low"
summary = "The IP address advertised by libp2p. This may be used to advertise an external IP."

[config."prysm-regtest.conf".ivars."p2p_local_ip"]
type = "string"
default = ""
priority = "low"
summary = "The local IP address to listen for incoming data."

[config."prysm-regtest.conf".ivars."p2p_max_peers"]
type = "string"
default = ""
priority = "low"
summary = "The max number of p2p peers to maintain. (default: 70)"

[config."prysm-regtest.conf".ivars."p2p_metadata"]
type = "string"
default = ""
priority = "low"
summary = "The file containing the metadata to communicate with other peers."

[config."prysm-regtest.conf".ivars."p2p_priv_key"]
type = "string"
default = ""
priority = "low"
summary = "The file containing the private key to use in communications with other peers."

[config."prysm-regtest.conf".ivars."p2p_static_id"]
type = "string"
default = ""
priority = "low"
summary = "Enables the peer id of the node to be fixed by saving the generated network key to the default key path. (default: false)"

[config."prysm-regtest.conf".ivars."peer"]
type = "string"
default = ""
priority = "low"
summary = "Connect with this peer. This flag may be used multiple times. This peer is recognized as a trusted peer."

[config."prysm-regtest.conf".ivars."pubsub_queue_size"]
type = "string"
default = ""
priority = "low"
summary = "The size of the pubsub validation and outbound queue for the node. (default: 1000)"

# log options
# [config."prysm-regtest.conf".ivars."log_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Specifies log file name, relative or absolute."

[config."prysm-regtest.conf".ivars."log_format"]
type = "string"
default = ""
priority = "low"
summary = "Specifies log formatting. Supports: text, json, fluentd, journald. (default: \"text\")"

# features options
[config."prysm-regtest.conf".ivars."blob_save_fsync"]
type = "string"
default = ""
priority = "low"
summary = "Forces new blob files to be fsync'd before continuing, ensuring durable blob writes. (default: false)"

[config."prysm-regtest.conf".ivars."dev"]
type = "string"
default = ""
priority = "low"
summary = "Enables experimental features still in development. These features may not be stable. (default: false)"

[config."prysm-regtest.conf".ivars."disable_broadcast_slashings"]
type = "string"
default = ""
priority = "low"
summary = "Disables broadcasting slashings submitted to the beacon node. (default: false)"

[config."prysm-regtest.conf".ivars."disable_grpc_connection_logging"]
type = "string"
default = ""
priority = "low"
summary = "Disables displaying logs for newly connected grpc clients. (default: false)"

[config."prysm-regtest.conf".ivars."disable_peer_scorer"]
type = "string"
default = ""
priority = "low"
summary = "(Danger): Disables P2P peer scorer. Do NOT use this in production! (default: false)"

[config."prysm-regtest.conf".ivars."disable_registration_cache"]
type = "string"
default = ""
priority = "low"
summary = "Temporary flag for disabling the validator registration cache instead of using the DB. (default: false)"

[config."prysm-regtest.conf".ivars."disable_resource_manager"]
type = "string"
default = ""
priority = "low"
summary = "Disables running the libp2p resource manager. (default: false)"

[config."prysm-regtest.conf".ivars."disable_staking_contract_check"]
type = "string"
default = ""
priority = "low"
summary = "Disables checking of staking contract deposits when proposing blocks, useful for devnets. (default: false)"

[config."prysm-regtest.conf".ivars."disable_verbose_sig_verification"]
type = "string"
default = ""
priority = "low"
summary = "Disables identifying invalid signatures if batch verification fails when processing block. (default: false)"

[config."prysm-regtest.conf".ivars."enable_committee_aware_packing"]
type = "string"
default = ""
priority = "low"
summary = "Changes the attestation packing algorithm to one that is aware of attesting committees. (default: false)"

[config."prysm-regtest.conf".ivars."enable_experimental_state"]
type = "string"
default = ""
priority = "low"
summary = "Turns on the latest (but potentially unstable) changes to the beacon state. (default: false)"

[config."prysm-regtest.conf".ivars."enable_full_ssz_data_logging"]
type = "string"
default = ""
priority = "low"
summary = "Enables displaying logs for full SSZ data on rejected gossip messages. (default: false)"

[config."prysm-regtest.conf".ivars."enable_historical_state_representation"]
type = "string"
default = ""
priority = "low"
summary = "Enables the beacon chain to save historical states in a space-efficient manner. Warning: Once enabled, this feature migrates your database to a new schema. (default: false)"

[config."prysm-regtest.conf".ivars."enable_lightclient"]
type = "string"
default = ""
priority = "low"
summary = "Enables the light client support in the beacon node. (default: false)"

[config."prysm-regtest.conf".ivars."enable_quic"]
type = "string"
default = ""
priority = "low"
summary = "Enables connection using the QUIC protocol for peers that support it. (default: false)"

[config."prysm-regtest.conf".ivars."holesky"]
type = "string"
default = ""
priority = "low"
summary = "Runs Prysm configured for the Holesky test network. (default: false)"

[config."prysm-regtest.conf".ivars."interop_write_ssz_state_transitions"]
type = "string"
default = ""
priority = "low"
summary = "Writes SSZ states to disk after attempted state transitions. (default: false)"

# [config."prysm-regtest.conf".ivars."mainnet"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Runs on the Ethereum main network. (default: true)"

[config."prysm-regtest.conf".ivars."prepare_all_payloads"]
type = "string"
default = ""
priority = "low"
summary = "Informs the engine to prepare all local payloads. Useful for relayers and builders. (default: false)"

[config."prysm-regtest.conf".ivars."save_full_execution_payloads"]
type = "string"
default = ""
priority = "low"
summary = "Saves beacon blocks with full execution payloads instead of execution payload headers in the database. (default: false)"

[config."prysm-regtest.conf".ivars."save_invalid_blob_temp"]
type = "string"
default = ""
priority = "low"
summary = "Writes invalid blobs to temp directory. (default: false)"

[config."prysm-regtest.conf".ivars."save_invalid_block_temp"]
type = "string"
default = ""
priority = "low"
summary = "Writes invalid blocks to temp directory. (default: false)"

# [config."prysm-regtest.conf".ivars."sepolia"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Runs Prysm configured for the Sepolia test network. (default: false)"

[config."prysm-regtest.conf".ivars."slasher"]
type = "string"
default = ""
priority = "low"
summary = "Enables a slasher in the beacon node for detecting slashable offenses. (default: false)"

# interop options
# [config."prysm-regtest.conf".ivars."genesis_state"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Load a genesis state from an SSZ file. Testnet genesis files can be found in the eth2-clients/eth2-testnets repository on GitHub."

[config."prysm-regtest.conf".ivars."interop_genesis_time"]
type = "string"
default = ""
priority = "low"
summary = "Specify the genesis time for interop genesis state generation. Must be used with --interop-num-validators. (default: 0)"

[config."prysm-regtest.conf".ivars."interop_num_validators"]
type = "string"
default = ""
priority = "low"
summary = "Specify the number of genesis validators to generate for interop. Must be used with --interop-genesis-time. (default: 0)"

# deprecated options
[config."prysm-regtest.conf".ivars."db_backup_output_dir"]
type = "string"
default = ""
priority = "low"
summary = "Output directory for database backups."
