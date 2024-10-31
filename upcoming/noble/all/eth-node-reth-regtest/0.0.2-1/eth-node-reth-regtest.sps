name = "eth-node-reth-regtest"
bin_package = "eth-node-reth"
binary = "/usr/lib/eth-node-reth-regtest/run-reth-service.sh"
user = { name = "eth-node-reth-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-reth-regtest
# NoNewPrivileges=true
# ProtectHome=true
# PrivateTmp=true
# PrivateDevices=true

# additional flags not specified by debcrafter
CapabilityBoundingSet=
IPAddressDeny=
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
ReadWritePaths=/var/lib/eth-node-regtest/reth
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
# SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/reth
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-reth-service.sh /usr/lib/eth-node-reth-regtest/", 
    "debian/scripts/run-reth.sh /usr/lib/eth-node-reth-regtest/bin/",
    "debian/tmp/eth-node-reth-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-reth-regtest",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-reth for network: regtest"

[config."reth-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-reth-regtest/postprocess.sh"]

[config."reth-regtest.conf"]
format = "plain"

[config."reth-regtest.conf".ivars."chain"]
type = "string"
default = "$TESTNET_DIR/genesis.json"
priority = "low"
summary = "The chain this node is running."


[config."reth-regtest.conf".ivars."datadir"]
type = "string"
default = "$DATA_DIR/reth"
priority = "low"
summary = '''
The path to the data dir for all reth files and subdirectories.
'''

[config."reth-regtest.conf".ivars."authrpc_jwtsecret"]
type = "string"
default = "$JWT_FILE"
priority = "low"
summary = '''
Path to a JWT secret to use for the authenticated engine-API RPC server.
'''

[config."reth-regtest.conf".ivars."authrpc_addr"]
type = "string"
default = "$ENGINE_IP"
priority = "low"
summary = '''
Auth server address to listen on.
'''

[config."reth-regtest.conf".ivars."authrpc_port"]
type = "string"
default = "$ENGINE_API_PORT"
priority = "low"
summary = '''
Auth server port to listen on.
'''
[config."reth-regtest.conf".ivars."http"]
type = "string"
default = "true"
priority = "low"
summary = '''
Enable the HTTP-RPC server.
'''

[config."reth-regtest.conf".ivars."http_addr"]
type = "string"
default = ""
priority = "low"
summary = '''
HTTP server address to listen on.
'''

[config."reth-regtest.conf".ivars."http_port"]
type = "string"
default = "$EL_RPC_PORT"
priority = "low"
summary = '''
HTTP server port to listen on.
'''


[config."reth-regtest.conf".ivars."http_api"]
type = "string"
default = "eth"
priority = "low"
summary = '''
RPC modules to be configured for the HTTP server.
'''

[config."reth-regtest.conf".ivars."http_corsdomain"]
type = "string"
default = "localhost"
priority = "low"
summary = '''
HTTP CORS domain to allow requests from.
'''


[config."reth-regtest.conf".ivars."log_file_directory"]
type = "string"
default = "$LOG_DIR/reth"
priority = "low"
summary = '''
The path to put log files in.
'''

[config."reth-regtest.conf".ivars."bootnodes"]
type = "string"
default = "$BOOTNODES_ENR"
priority = "low"
summary = '''
Comma-separated enode URLs for P2P discovery bootstrap.
'''

[config."reth-regtest.conf".ivars."log_file_format"]
type = "string"
default = "log-fmt"
priority = "low"
summary = '''
The format to use for logs written to the log file.
'''

# All Default options, commented out the used one
### OPTIONS below are all set to default and provided to be used with debconf

[config."reth-regtest.conf".ivars."config"]
type = "string"
default = ""
priority = "low"
summary = '''
The path to the configuration file to use.
'''

# [config."reth-regtest.conf".ivars."chain"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# The chain this node is running.
# Possible values are either a built-in chain or the path to a chain specification file.
# '''

[config."reth-regtest.conf".ivars."instance"]
type = "string"
default = ""
priority = "low"
summary = '''
Add a new instance of a node.
'''

# Config
[config."reth-regtest.conf".ivars."with_unused_ports"]
type = "string"
default = "false"
priority = "low"
summary = '''
Sets all ports to unused, allowing the OS to choose random unused ports when sockets are bound.
'''

# Metrics
[config."reth-regtest.conf".ivars."metrics"]
type = "string"
default = ""
priority = "low"
summary = '''
Enable Prometheus metrics.
'''

# Datadir
# [config."reth-regtest.conf".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# The path to the data dir for all reth files and subdirectories.
# '''

[config."reth-regtest.conf".ivars."datadir_static_files"]
type = "string"
default = ""
priority = "low"
summary = '''
The absolute path to store static files in.
'''

# Networking
[config."reth-regtest.conf".ivars."disable_discovery"]
type = "string"
default = "false"
priority = "low"
summary = '''
Disable the discovery service.
'''

[config."reth-regtest.conf".ivars."disable_dns_discovery"]
type = "string"
default = "false"
priority = "low"
summary = '''
Disable the DNS discovery.
'''

[config."reth-regtest.conf".ivars."disable_discv4_discovery"]
type = "string"
default = "false"
priority = "low"
summary = '''
Disable Discv4 discovery.
'''

[config."reth-regtest.conf".ivars."enable_discv5_discovery"]
type = "string"
default = "false"
priority = "low"
summary = '''
Enable Discv5 discovery.
'''

[config."reth-regtest.conf".ivars."disable_nat"]
type = "string"
default = "false"
priority = "low"
summary = '''
Disable NAT discovery.
'''

[config."reth-regtest.conf".ivars."trusted_only"]
type = "string"
default = "false"
priority = "low"
summary = '''
Connect to or accept from trusted peers only.
'''

[config."reth-regtest.conf".ivars."no_persist_peers"]
type = "string"
default = "false"
priority = "low"
summary = '''
Do not persist peers.
'''

[config."reth-regtest.conf".ivars."discovery_addr"]
type = "string"
default = ""
priority = "low"
summary = '''
The UDP address to use for devp2p peer discovery version 4.
'''

[config."reth-regtest.conf".ivars."discovery_port"]
type = "string"
default = ""
priority = "low"
summary = '''
The UDP port to use for devp2p peer discovery version 4.
'''

[config."reth-regtest.conf".ivars."discovery_v5_addr"]
type = "string"
default = ""
priority = "low"
summary = '''
The UDP IPv4 address to use for devp2p peer discovery version 5. Overwritten by `RLPx` address, if it's also IPv4.
'''

[config."reth-regtest.conf".ivars."discovery_v5_addr_ipv6"]
type = "string"
default = ""
priority = "low"
summary = '''
The UDP IPv6 address to use for devp2p peer discovery version 5. Overwritten by `RLPx` address, if it's also IPv6.
'''

[config."reth-regtest.conf".ivars."discovery_v5_port"]
type = "string"
default = ""
priority = "low"
summary = '''
The UDP IPv4 port to use for devp2p peer discovery version 5. Not used unless `--addr` is IPv4, or `--discovery.v5.addr` is set.
'''

[config."reth-regtest.conf".ivars."discovery_v5_port_ipv6"]
type = "string"
default = ""
priority = "low"
summary = '''
The UDP IPv6 port to use for devp2p peer discovery version 5. Not used unless `--addr` is IPv6, or `--discovery.addr.ipv6` is set.
'''

[config."reth-regtest.conf".ivars."discovery_v5_lookup_interval"]
type = "string"
default = ""
priority = "low"
summary = '''
The interval in seconds at which to carry out periodic lookup queries, for the whole run of the program.
'''

[config."reth-regtest.conf".ivars."discovery_v5_bootstrap_lookup_interval"]
type = "string"
default = ""
priority = "low"
summary = '''
The interval in seconds at which to carry out bootstrap lookup queries, for a fixed number of times, at startup.
'''

[config."reth-regtest.conf".ivars."discovery_v5_bootstrap_lookup_countdown"]
type = "string"
default = ""
priority = "low"
summary = '''
The number of times to carry out bootstrap lookup queries at startup.
'''

[config."reth-regtest.conf".ivars."trusted_peers"]
type = "string"
default = ""
priority = "low"
summary = '''
Comma-separated enode URLs of trusted peers for P2P connections.
'''

# [config."reth-regtest.conf".ivars."bootnodes"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# Comma-separated enode URLs for P2P discovery bootstrap.
# '''

[config."reth-regtest.conf".ivars."dns_retries"]
type = "string"
default = ""
priority = "low"
summary = '''
Amount of DNS resolution retries to perform when peering.
'''

[config."reth-regtest.conf".ivars."peers_file"]
type = "string"
default = ""
priority = "low"
summary = '''
The path to the known peers file. Connected peers are dumped to this file on nodes shutdown, and read on startup. Cannot be used with `--no-persist-peers`.
'''

[config."reth-regtest.conf".ivars."identity"]
type = "string"
default = ""
priority = "low"
summary = '''
Custom node identity.
'''

[config."reth-regtest.conf".ivars."p2p_secret_key"]
type = "string"
default = ""
priority = "low"
summary = '''
Secret key to use for this node. This will also deterministically set the peer ID. If not specified, it will be set in the data dir for the chain being used.
'''

[config."reth-regtest.conf".ivars."nat"]
type = "string"
default = ""
priority = "low"
summary = '''
NAT resolution method (any|none|upnp|publicip|extip:<IP>).
'''

[config."reth-regtest.conf".ivars."addr"]
type = "string"
default = ""
priority = "low"
summary = '''
Network listening address.
'''

[config."reth-regtest.conf".ivars."port"]
type = "string"
default = ""
priority = "low"
summary = '''
Network listening port.
'''

[config."reth-regtest.conf".ivars."max_outbound_peers"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of outbound peer requests.
'''

[config."reth-regtest.conf".ivars."max_inbound_peers"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of inbound peer requests.
'''

[config."reth-regtest.conf".ivars."max_tx_reqs"]
type = "string"
default = ""
priority = "low"
summary = '''
Max concurrent `GetPooledTransactions` requests.
'''

[config."reth-regtest.conf".ivars."max_tx_reqs_peer"]
type = "string"
default = ""
priority = "low"
summary = '''
Max concurrent `GetPooledTransactions` requests per peer.
'''

[config."reth-regtest.conf".ivars."max_seen_tx_history"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of seen transactions to remember per peer.
'''

[config."reth-regtest.conf".ivars."max_pending_imports"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of transactions to import concurrently.
'''

[config."reth-regtest.conf".ivars."pooled_tx_response_soft_limit"]
type = "string"
default = ""
priority = "low"
summary = '''
Experimental, for usage in research. Sets the max accumulated byte size of transactions to pack in one response.
'''

[config."reth-regtest.conf".ivars."pooled_tx_pack_soft_limit"]
type = "string"
default = ""
priority = "low"
summary = '''
Experimental, for usage in research. Sets the max accumulated byte size of transactions to request in one request.
'''

[config."reth-regtest.conf".ivars."max_tx_pending_fetch"]
type = "string"
default = ""
priority = "low"
summary = '''
Max capacity of cache of hashes for transactions pending fetch.
'''

[config."reth-regtest.conf".ivars."net_if_experimental"]
type = "string"
default = ""
priority = "low"
summary = '''
Name of network interface used to communicate with peers. If flag is set, but no value is passed, the default interface for Docker `eth0` is tried.
'''

# RPC 

# [config."reth-regtest.conf".ivars."http"]
# type = "string"
# default = "false"
# priority = "low"
# summary = '''
# Enable the HTTP-RPC server.
# '''

# [config."reth-regtest.conf".ivars."http_addr"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# HTTP server address to listen on.
# '''

# [config."reth-regtest.conf".ivars."http_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# HTTP server port to listen on.
# '''

# [config."reth-regtest.conf".ivars."http_api"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# RPC modules to be configured for the HTTP server.
# '''

# [config."reth-regtest.conf".ivars."http_corsdomain"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# HTTP CORS domain to allow requests from.
# '''

[config."reth-regtest.conf".ivars."ws"]
type = "string"
default = "false"
priority = "low"
summary = '''
Enable the WS-RPC server.
'''

[config."reth-regtest.conf".ivars."ws_addr"]
type = "string"
default = ""
priority = "low"
summary = '''
WebSocket server address to listen on.
'''

[config."reth-regtest.conf".ivars."ws_port"]
type = "string"
default = ""
priority = "low"
summary = '''
WebSocket server port to listen on.
'''

[config."reth-regtest.conf".ivars."ws_origins"]
type = "string"
default = ""
priority = "low"
summary = '''
Origins from which to accept WebSocket requests.
'''

[config."reth-regtest.conf".ivars."ws_api"]
type = "string"
default = ""
priority = "low"
summary = '''
RPC modules to be configured for the WebSocket server.
'''

[config."reth-regtest.conf".ivars."ipcdisable"]
type = "string"
default = "false"
priority = "low"
summary = '''
Disable the IPC-RPC server.
'''

[config."reth-regtest.conf".ivars."ipcpath"]
type = "string"
default = ""
priority = "low"
summary = '''
Filename for IPC socket/pipe within the datadir.
'''

# [config."reth-regtest.conf".ivars."authrpc_addr"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# Auth server address to listen on.
# '''

# [config."reth-regtest.conf".ivars."authrpc_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# Auth server port to listen on.
# '''

# [config."reth-regtest.conf".ivars."authrpc_jwtsecret"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# Path to a JWT secret to use for the authenticated engine-API RPC server.
# '''

[config."reth-regtest.conf".ivars."auth_ipc"]
type = "string"
default = "false"
priority = "low"
summary = '''
Enable auth engine API over IPC.
'''

[config."reth-regtest.conf".ivars."auth_ipc_path"]
type = "string"
default = ""
priority = "low"
summary = '''
Filename for auth IPC socket/pipe within the datadir.
'''

[config."reth-regtest.conf".ivars."rpc_jwtsecret"]
type = "string"
default = ""
priority = "low"
summary = '''
Hex encoded JWT secret to authenticate the regular RPC server(s), see `--http.api` and `--ws.api`.
'''

[config."reth-regtest.conf".ivars."rpc_max_request_size"]
type = "string"
default = ""
priority = "low"
summary = '''
Set the maximum RPC request payload size for both HTTP and WS in megabytes.
'''

[config."reth-regtest.conf".ivars."rpc_max_response_size"]
type = "string"
default = ""
priority = "low"
summary = '''
Set the maximum RPC response payload size for both HTTP and WS in megabytes.
'''

[config."reth-regtest.conf".ivars."rpc_max_subscriptions_per_connection"]
type = "string"
default = ""
priority = "low"
summary = '''
Set the maximum concurrent subscriptions per connection.
'''

[config."reth-regtest.conf".ivars."rpc_max_connections"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of RPC server connections.
'''

[config."reth-regtest.conf".ivars."rpc_max_tracing_requests"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of concurrent tracing requests.
'''

[config."reth-regtest.conf".ivars."rpc_max_blocks_per_filter"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of blocks that could be scanned per filter request. (0 = entire chain)
'''

[config."reth-regtest.conf".ivars."rpc_max_logs_per_response"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of logs that can be returned in a single response. (0 = no limit)
'''

[config."reth-regtest.conf".ivars."rpc_gascap"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum gas limit for `eth_call` and call tracing RPC methods.
'''

[config."reth-regtest.conf".ivars."rpc_max_simulate_blocks"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of blocks for `eth_simulateV1` call.
'''

[config."reth-regtest.conf".ivars."rpc_eth_proof_window"]
type = "string"
default = ""
priority = "low"
summary = '''
The maximum proof window for historical proof generation. This value allows for generating historical proofs up to configured number of blocks from current tip (up to `tip - window`).
'''

[config."reth-regtest.conf".ivars."rpc_proof_permits"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of concurrent getproof requests.
'''

# RPC State Cache

[config."reth-regtest.conf".ivars."rpc_cache_max_blocks"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of blocks in cache.
'''

[config."reth-regtest.conf".ivars."rpc_cache_max_receipts"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of receipts in cache.
'''

[config."reth-regtest.conf".ivars."rpc_cache_max_envs"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of bytes for cached environment data.
'''

[config."reth-regtest.conf".ivars."rpc_cache_max_concurrent_db_requests"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of concurrent database requests.
'''

# Gas Price Oracle

[config."reth-regtest.conf".ivars."gpo_blocks"]
type = "string"
default = ""
priority = "low"
summary = '''
Number of recent blocks to check for gas price.
'''

[config."reth-regtest.conf".ivars."gpo_ignoreprice"]
type = "string"
default = ""
priority = "low"
summary = '''
Gas price below which GPO will ignore transactions.
'''

[config."reth-regtest.conf".ivars."gpo_maxprice"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum transaction priority fee (or gas price before London Fork) to be recommended by GPO.
'''

[config."reth-regtest.conf".ivars."gpo_percentile"]
type = "string"
default = ""
priority = "low"
summary = '''
The percentile of gas prices to use for the estimate.
'''

# TxPool

[config."reth-regtest.conf".ivars."txpool_pending_max_count"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of transactions in the pending sub-pool.
'''

[config."reth-regtest.conf".ivars."txpool_pending_max_size"]
type = "string"
default = ""
priority = "low"
summary = '''
Max size of the pending sub-pool in megabytes.
'''

[config."reth-regtest.conf".ivars."txpool_basefee_max_count"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of transactions in the basefee sub-pool.
'''

[config."reth-regtest.conf".ivars."txpool_basefee_max_size"]
type = "string"
default = ""
priority = "low"
summary = '''
Max size of the basefee sub-pool in megabytes.
'''

[config."reth-regtest.conf".ivars."txpool_queued_max_count"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of transactions in the queued sub-pool.
'''

[config."reth-regtest.conf".ivars."txpool_queued_max_size"]
type = "string"
default = ""
priority = "low"
summary = '''
Max size of the queued sub-pool in megabytes.
'''

[config."reth-regtest.conf".ivars."txpool_max_account_slots"]
type = "string"
default = ""
priority = "low"
summary = '''
Max number of executable transaction slots guaranteed per account.
'''

[config."reth-regtest.conf".ivars."txpool_pricebump"]
type = "string"
default = ""
priority = "low"
summary = '''
Price bump (in %) for the transaction pool underpriced check.
'''

[config."reth-regtest.conf".ivars."txpool_minimal_protocol_fee"]
type = "string"
default = ""
priority = "low"
summary = '''
Minimum base fee required by the protocol.
'''

[config."reth-regtest.conf".ivars."txpool_gas_limit"]
type = "string"
default = ""
priority = "low"
summary = '''
The default enforced gas limit for transactions entering the pool.
'''

[config."reth-regtest.conf".ivars."blobpool_pricebump"]
type = "string"
default = ""
priority = "low"
summary = '''
Price bump percentage to replace an already existing blob transaction.
'''

[config."reth-regtest.conf".ivars."txpool_max_tx_input_bytes"]
type = "string"
default = ""
priority = "low"
summary = '''
Max size in bytes of a single transaction allowed to enter the pool.
'''

[config."reth-regtest.conf".ivars."txpool_max_cached_entries"]
type = "string"
default = ""
priority = "low"
summary = '''
The maximum number of blobs to keep in the in-memory blob cache.
'''

[config."reth-regtest.conf".ivars."txpool_nolocals"]
type = "string"
default = "false"
priority = "low"
summary = '''
Flag to disable local transaction exemptions.
'''

[config."reth-regtest.conf".ivars."txpool_no_local_transactions_propagation"]
type = "string"
default = "false"
priority = "low"
summary = '''
Flag to toggle local transaction propagation.
'''

[config."reth-regtest.conf".ivars."txpool_locals"]
type = "string"
default = ""
priority = "low"
summary = '''
Flag to allow certain addresses as local.
'''

[config."reth-regtest.conf".ivars."txpool_additional_validation_tasks"]
type = "string"
default = ""
priority = "low"
summary = '''
Number of additional transaction validation tasks to spawn.
'''

[config."reth-regtest.conf".ivars."txpool_max_pending_txns"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of pending transactions from the network to buffer.
'''

[config."reth-regtest.conf".ivars."txpool_max_new_txns"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of new transactions to buffer.
'''


# Builder

[config."reth-regtest.conf".ivars."builder_extradata"]
type = "string"
default = ""
priority = "low"
summary = '''
Block extra data set by the payload builder.
'''

[config."reth-regtest.conf".ivars."builder_gaslimit"]
type = "string"
default = ""
priority = "low"
summary = '''
Target gas ceiling for built blocks.
'''

[config."reth-regtest.conf".ivars."builder_interval"]
type = "string"
default = ""
priority = "low"
summary = '''
The interval at which the job should build a new payload after the last.
'''

[config."reth-regtest.conf".ivars."builder_deadline"]
type = "string"
default = ""
priority = "low"
summary = '''
The deadline for when the payload builder job should resolve.
'''

[config."reth-regtest.conf".ivars."builder_max_tasks"]
type = "string"
default = ""
priority = "low"
summary = '''
Maximum number of tasks to spawn for building a payload.
'''

# Debug

[config."reth-regtest.conf".ivars."debug_terminate"]
type = "string"
default = "false"
priority = "low"
summary = '''
Flag indicating whether the node should be terminated after the pipeline sync.
'''

[config."reth-regtest.conf".ivars."debug_tip"]
type = "string"
default = ""
priority = "low"
summary = '''
Set the chain tip manually for testing purposes.
'''

[config."reth-regtest.conf".ivars."debug_max_block"]
type = "string"
default = ""
priority = "low"
summary = '''
Runs the sync only up to the specified block.
'''

[config."reth-regtest.conf".ivars."debug_etherscan"]
type = "string"
default = ""
priority = "low"
summary = '''
Runs a fake consensus client that advances the chain using recent block hashes on Etherscan. If specified, requires an `ETHERSCAN_API_KEY` environment variable.
'''

[config."reth-regtest.conf".ivars."debug_rpc_consensus_ws"]
type = "string"
default = ""
priority = "low"
summary = '''
Runs a fake consensus client using blocks fetched from an RPC `WebSocket` endpoint.
'''

[config."reth-regtest.conf".ivars."debug_skip_fcu"]
type = "string"
default = ""
priority = "low"
summary = '''
If provided, the engine will skip `n` consecutive FCUs.
'''

[config."reth-regtest.conf".ivars."debug_skip_new_payload"]
type = "string"
default = ""
priority = "low"
summary = '''
If provided, the engine will skip `n` consecutive new payloads.
'''

[config."reth-regtest.conf".ivars."debug_reorg_frequency"]
type = "string"
default = ""
priority = "low"
summary = '''
If provided, the chain will be reorged at the specified frequency.
'''

[config."reth-regtest.conf".ivars."debug_reorg_depth"]
type = "string"
default = ""
priority = "low"
summary = '''
The reorg depth for chain reorgs.
'''

[config."reth-regtest.conf".ivars."debug_engine_api_store"]
type = "string"
default = ""
priority = "low"
summary = '''
The path to store engine API messages at. If specified, all of the intercepted engine API messages will be written to the specified location.
'''

[config."reth-regtest.conf".ivars."debug_invalid_block_hook"]
type = "string"
default = ""
priority = "low"
summary = '''
Determines which type of invalid block hook to install.
'''

[config."reth-regtest.conf".ivars."debug_healthy_node_rpc_url"]
type = "string"
default = ""
priority = "low"
summary = '''
The RPC URL of a healthy node to use for comparing invalid block hook results against.
'''


# Database

[config."reth-regtest.conf".ivars."db_log_level"]
type = "string"
default = ""
priority = "low"
summary = '''
Database logging level. Levels higher than "notice" require a debug build.
'''

[config."reth-regtest.conf".ivars."db_exclusive"]
type = "string"
default = ""
priority = "low"
summary = '''
Open environment in exclusive/monopolistic mode. Makes it possible to open a database on an NFS volume.
'''

# Dev testnet

[config."reth-regtest.conf".ivars."dev"]
type = "string"
default = "false"
priority = "low"
summary = '''
Start the node in dev mode.
'''

[config."reth-regtest.conf".ivars."dev_block_max_transactions"]
type = "string"
default = ""
priority = "low"
summary = '''
How many transactions to mine per block.
'''

[config."reth-regtest.conf".ivars."dev_block_time"]
type = "string"
default = ""
priority = "low"
summary = '''
Interval between blocks.
'''

# Pruning

[config."reth-regtest.conf".ivars."full"]
type = "string"
default = "false"
priority = "low"
summary = '''
Run full node. Only the most recent [`MINIMUM_PRUNING_DISTANCE`] block states are stored.
'''

[config."reth-regtest.conf".ivars."block_interval"]
type = "string"
default = ""
priority = "low"
summary = '''
Minimum pruning interval measured in blocks.
'''

[config."reth-regtest.conf".ivars."prune_senderrecovery_full"]
type = "string"
default = "false"
priority = "low"
summary = '''
Prunes all sender recovery data.
'''

[config."reth-regtest.conf".ivars."prune_senderrecovery_distance"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune sender recovery data before the `head-N` block number. In other words, keep last N + 1 blocks.
'''

[config."reth-regtest.conf".ivars."prune_senderrecovery_before"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune sender recovery data before the specified block number. The specified block number is not pruned.
'''

[config."reth-regtest.conf".ivars."prune_transactionlookup_full"]
type = "string"
default = "false"
priority = "low"
summary = '''
Prunes all transaction lookup data.
'''

[config."reth-regtest.conf".ivars."prune_transactionlookup_distance"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune transaction lookup data before the `head-N` block number. In other words, keep last N + 1 blocks.
'''

[config."reth-regtest.conf".ivars."prune_transactionlookup_before"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune transaction lookup data before the specified block number. The specified block number is not pruned.
'''

[config."reth-regtest.conf".ivars."prune_receipts_full"]
type = "string"
default = "false"
priority = "low"
summary = '''
Prunes all receipt data.
'''

[config."reth-regtest.conf".ivars."prune_receipts_distance"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune receipts before the `head-N` block number. In other words, keep last N + 1 blocks.
'''

[config."reth-regtest.conf".ivars."prune_receipts_before"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune receipts before the specified block number. The specified block number is not pruned.
'''

[config."reth-regtest.conf".ivars."prune_accounthistory_full"]
type = "string"
default = "false"
priority = "low"
summary = '''
Prunes all account history.
'''

[config."reth-regtest.conf".ivars."prune_accounthistory_distance"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune account history before the `head-N` block number. In other words, keep last N + 1 blocks.
'''

[config."reth-regtest.conf".ivars."prune_accounthistory_before"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune account history before the specified block number. The specified block number is not pruned.
'''

[config."reth-regtest.conf".ivars."prune_storagehistory_full"]
type = "string"
default = "false"
priority = "low"
summary = '''
Prunes all storage history data.
'''

[config."reth-regtest.conf".ivars."prune_storagehistory_distance"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune storage history before the `head-N` block number. In other words, keep last N + 1 blocks.
'''

[config."reth-regtest.conf".ivars."prune_storagehistory_before"]
type = "string"
default = ""
priority = "low"
summary = '''
Prune storage history before the specified block number. The specified block number is not pruned.
'''

[config."reth-regtest.conf".ivars."prune_receiptslogfilter"]
type = "string"
default = ""
priority = "low"
summary = '''
Configure receipts log filter. Format: <`address`>:<`prune_mode`>[,<`address`>:<`prune_mode`>...] Where <`prune_mode`> can be 'full', 'distance:<`blocks`>', or 'before:<`block_number`>'.
'''


# Engine

[config."reth-regtest.conf".ivars."engine_experimental"]
type = "string"
default = "false"
priority = "low"
summary = '''
Enable the experimental engine features on the reth binary.
'''

[config."reth-regtest.conf".ivars."engine_legacy"]
type = "string"
default = "false"
priority = "low"
summary = '''
Enable the legacy engine on the reth binary.
'''

[config."reth-regtest.conf".ivars."engine_persistence_threshold"]
type = "string"
default = ""
priority = "low"
summary = '''
Configure persistence threshold for engine experimental.
'''

[config."reth-regtest.conf".ivars."engine_memory_block_buffer_target"]
type = "string"
default = ""
priority = "low"
summary = '''
Configure the target number of blocks to keep in memory.
'''

# Logging

[config."reth-regtest.conf".ivars."log_stdout_format"]
type = "string"
default = ""
priority = "low"
summary = '''
The format to use for logs written to stdout.
'''

[config."reth-regtest.conf".ivars."log_stdout_filter"]
type = "string"
default = ""
priority = "low"
summary = '''
The filter to use for logs written to stdout.
'''

# [config."reth-regtest.conf".ivars."log_file_format"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# The format to use for logs written to the log file.
# '''

[config."reth-regtest.conf".ivars."log_file_filter"]
type = "string"
default = ""
priority = "low"
summary = '''
The filter to use for logs written to the log file.
'''

# [config."reth-regtest.conf".ivars."log_file_directory"]
# type = "string"
# default = ""
# priority = "low"
# summary = '''
# The path to put log files in.
# '''

[config."reth-regtest.conf".ivars."log_file_max_size"]
type = "string"
default = ""
priority = "low"
summary = '''
The maximum size (in MB) of one log file.
'''

[config."reth-regtest.conf".ivars."log_file_max_files"]
type = "string"
default = ""
priority = "low"
summary = '''
The maximum amount of log files that will be stored. If set to 0, background file logging is disabled.
'''

[config."reth-regtest.conf".ivars."log_journald"]
type = "string"
default = "false"
priority = "low"
summary = '''
Write logs to journald.
'''

[config."reth-regtest.conf".ivars."log_journald_filter"]
type = "string"
default = ""
priority = "low"
summary = '''
The filter to use for logs written to journald.
'''

[config."reth-regtest.conf".ivars."color"]
type = "string"
default = ""
priority = "low"
summary = '''
Sets whether or not the formatter emits ANSI terminal escape codes for colors and other text formatting.
'''

# Display

[config."reth-regtest.conf".ivars."verbosity"]
type = "string"
default = "false"
priority = "low"
summary = '''
Set the minimum log level.
'''

[config."reth-regtest.conf".ivars."quiet"]
type = "string"
default = "false"
priority = "low"
summary = '''
Silence all log output.
'''
