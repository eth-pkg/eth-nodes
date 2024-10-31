name = "eth-node-erigon-regtest"
bin_package = "eth-node-erigon"
binary = "/usr/bin/erigon"
## TODO remove http.api from here
conf_param = "--http.api='eth,erigon,engine,web3,net,debug,trace,txpool,admin,ots' --config="
user = { name = "eth-node-erigon-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-erigon-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/erigon
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/erigon
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/tmp/eth-node-erigon-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-erigon-regtest",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-erigon for network: regtest"

[config."erigon-regtest.yaml".postprocess]
command = ["bash", "/usr/lib/eth-node-erigon-regtest/postprocess.sh"]

[config."erigon-regtest.yaml"]
format = "yaml"


#### THIS IS A HACK, DO NOT MERGE

[config."erigon-regtest.yaml".hvars."DATA_DIR"]
type = "string"
constant = "/var/lib/eth-node-regtest"
store = false

[config."erigon-regtest.yaml".hvars."JWT_FILE"]
type = "path"
file_type = "regular"
constant = "/etc/eth-node-regtest/jwt.hex"
store = false

[config."erigon-regtest.yaml".hvars."NETWORK_ID"]
type = "string"
constant = "1337"
store = false

[config."erigon-regtest.yaml".hvars."TESTNET_DIR"]
type = "string"
constant = "/var/lib/eth-node-regtest/regtest/genesis"
store = false

[config."erigon-regtest.yaml".hvars."EL_RPC_PORT"]
type = "string"
constant = "8545"
store = false

[config."erigon-regtest.yaml".hvars."ENGINE_IP"]
type = "string"
constant = "127.0.0.1"
store = false

[config."erigon-regtest.yaml".hvars."LOG_DIR"]
type = "string"
constant = "/var/logs/eth-node-regtest"
# priority = "low"
ignore_empty = true
# summary = "Base dir for logging"
store = false

# TODO logs dir 
# TESTNET options

[config."erigon-regtest.yaml".hvars."networkid"]
type = "string"
template = "{/NETWORK_ID}"
# priority = "low"
ignore_empty = true
# summary = "Explicitly set network ID (integer)"

[config."erigon-regtest.yaml".hvars."datadir"]
type = "string"
template = "{/DATA_DIR}/erigon"
# priority = "low"
ignore_empty = true
# summary = "Data directory for the databases"

# [config."erigon-regtest.yaml".ivars."http.api"]
# type = "string"
# default = "eth,erigon,engine,web3,net,debug,trace,txpool,admin,ots"
# priority = "low"
# ignore_empty = true
# summary = "APIs offered over the HTTP-RPC interface"

[config."erigon-regtest.yaml".ivars."http.vhosts"]
type = "string"
default = "localhost"
priority = "low"
ignore_empty = true
summary = "Comma separated list of virtual hostnames from which to accept requests"


[config."erigon-regtest.yaml".hvars."authrpc.addr"]
type = "string"
template = "{/ENGINE_IP}"
# priority = "low"
ignore_empty = true
# summary = "HTTP-RPC server listening interface for the Engine API"

[config."erigon-regtest.yaml".ivars."authrpc.vhosts"]
type = "string"
default = "localhost"
priority = "low"
ignore_empty = true
summary = "Comma separated list of virtual hostnames from which to accept Engine API requests"

[config."erigon-regtest.yaml".hvars."authrpc.jwtsecret"]
type = "string"
template = "{/JWT_FILE}"
# priority = "low"
ignore_empty = true
# summary = "Path to the token that ensures safe connection between CL and EL"

[config."erigon-regtest.yaml".ivars."http"]
type = "bool"
default = "true"
priority = "low"
ignore_empty = true
summary = "JSON-RPC server (enabled by default)"

# [config."erigon-regtest.yaml".ivars."bootnodes"]
# type = "string"
# default = "$BOOTNODES_ENR"
# priority = "low"
# ignore_empty = true
# summary = "Comma separated enode URLs for P2P discovery bootstrap"

[config."erigon-regtest.yaml".hvars."http.addr"]
type = "string"
template = "{/ENGINE_IP}"
# priority = "low"
ignore_empty = true
# summary = "HTTP-RPC server listening interface"

[config."erigon-regtest.yaml".ivars."http.corsdomain"]
type = "string"
default = "*"
priority = "low"
ignore_empty = true
summary = "Comma separated list of domains from which to accept cross-origin requests"


[config."erigon-regtest.yaml".hvars."log.dir.path"]
type = "string"
template = "{/LOG_DIR}/erigon"
# priority = "low"
ignore_empty = true
# summary = "Path to store user and error logs to disk"


# # All Default options, commented out the used one
### OPTIONS below are all set to default and provided to be used with debconf

# [config."erigon-regtest.yaml".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Data directory for the databases"

[config."erigon-regtest.yaml".ivars."ethash_dagdir"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Directory to store the ethash mining DAGs"

[config."erigon-regtest.yaml".ivars."snapshots"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use snapshots. Default 'true' for Mainnet, Goerli, Gnosis Chain, and Chiado."

[config."erigon-regtest.yaml".ivars."internalcl"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enables internal consensus"

[config."erigon-regtest.yaml".ivars."txpool_disable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disables internal txpool and block producer"

[config."erigon-regtest.yaml".ivars."txpool_locals"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated accounts to treat as locals (no flush, priority inclusion)"

[config."erigon-regtest.yaml".ivars."txpool_nolocals"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disables price exemptions for locally submitted transactions"

[config."erigon-regtest.yaml".ivars."txpool_pricelimit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Minimum gas price (fee cap) limit for acceptance into the pool"

[config."erigon-regtest.yaml".ivars."txpool_pricebump"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Price bump percentage to replace an already existing transaction"

[config."erigon-regtest.yaml".ivars."txpool_blobpricebump"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Price bump percentage to replace existing (type-3) blob transaction"

[config."erigon-regtest.yaml".ivars."txpool_accountslots"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Minimum number of executable transaction slots guaranteed per account"

[config."erigon-regtest.yaml".ivars."txpool_blobslots"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max allowed total number of blobs (within type-3 txs) per account"

[config."erigon-regtest.yaml".ivars."txpool_totalblobpoollimit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Total limit of number of all blobs in txs within the txpool"

[config."erigon-regtest.yaml".ivars."txpool_globalslots"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of executable transaction slots for all accounts"

[config."erigon-regtest.yaml".ivars."txpool_globalbasefeeslots"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of non-executable transactions where only not enough baseFee"

[config."erigon-regtest.yaml".ivars."txpool_accountqueue"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of non-executable transaction slots permitted per account"

[config."erigon-regtest.yaml".ivars."txpool_globalqueue"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of non-executable transaction slots for all accounts"

[config."erigon-regtest.yaml".ivars."txpool_lifetime"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum amount of time non-executable transactions are queued"

[config."erigon-regtest.yaml".ivars."txpool_trace_senders"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated list of addresses, whose transactions will be traced in the transaction pool with debug printing"

[config."erigon-regtest.yaml".ivars."txpool_commit_every"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "How often transactions should be committed to the storage"

[config."erigon-regtest.yaml".ivars."prune"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Choose which ancient data to delete from DB (h, r, t, c)"

[config."erigon-regtest.yaml".ivars."prune_h_older"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prune data older than this number of blocks from the tip of the chain"

[config."erigon-regtest.yaml".ivars."prune_r_older"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prune receipts data older than this number of blocks from the tip of the chain"

[config."erigon-regtest.yaml".ivars."prune_t_older"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prune transaction data older than this number of blocks from the tip of the chain"

[config."erigon-regtest.yaml".ivars."prune_c_older"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prune call trace data older than this number of blocks from the tip of the chain"

[config."erigon-regtest.yaml".ivars."prune_h_before"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prune history before this block"

[config."erigon-regtest.yaml".ivars."prune_r_before"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prune receipts before this block"

[config."erigon-regtest.yaml".ivars."prune_t_before"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prune transactions before this block"

[config."erigon-regtest.yaml".ivars."prune_c_before"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prune call traces before this block"

[config."erigon-regtest.yaml".ivars."batchsize"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Batch size for the execution stage"

[config."erigon-regtest.yaml".ivars."bodies_cache"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Limit on the cache for block bodies"

[config."erigon-regtest.yaml".ivars."database_verbosity"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enabling internal db logs. Very high verbosity levels may require recompile db."

[config."erigon-regtest.yaml".ivars."private_api_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Erigon's components (txpool, rpcdaemon, sentry, downloader, etc.) can be deployed as independent processes."

[config."erigon-regtest.yaml".ivars."private_api_ratelimit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Amount of requests server handles simultaneously - requests over this limit will wait."

[config."erigon-regtest.yaml".ivars."etl_buffersize"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Buffer size for ETL operations"

[config."erigon-regtest.yaml".ivars."tls"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable TLS handshake"

[config."erigon-regtest.yaml".ivars."tls_cert"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Specify certificate for TLS"

[config."erigon-regtest.yaml".ivars."tls_key"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Specify key file for TLS"

[config."erigon-regtest.yaml".ivars."tls_cacert"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Specify certificate authority for TLS"

[config."erigon-regtest.yaml".ivars."state_stream_disable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable streaming of state changes from core to RPC daemon"

[config."erigon-regtest.yaml".ivars."sync_loop_throttle"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the minimum time between sync loop starts (e.g. 1h30m)"

[config."erigon-regtest.yaml".ivars."bad_block"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Marks block with given hex string as bad and forces initial reorg before normal staged sync"

# [config."erigon-regtest.yaml".ivars."http"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "JSON-RPC server (enabled by default). Use --http=false to disable it."

[config."erigon-regtest.yaml".ivars."http_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "JSON-RPC HTTP server (enabled by default). Use --http.enabled=false to disable it."

[config."erigon-regtest.yaml".ivars."graphql"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable the GraphQL endpoint"

# [config."erigon-regtest.yaml".ivars."http_addr"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "HTTP-RPC server listening interface"

[config."erigon-regtest.yaml".ivars."http_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "HTTP-RPC server listening port"

# [config."erigon-regtest.yaml".ivars."authrpc_addr"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "HTTP-RPC server listening interface for the Engine API"

[config."erigon-regtest.yaml".ivars."authrpc_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "HTTP-RPC server listening port for the Engine API"

# [config."erigon-regtest.yaml".ivars."authrpc_jwtsecret"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Path to the token that ensures safe connection between CL and EL"

[config."erigon-regtest.yaml".ivars."http_compression"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable compression over HTTP-RPC"

# [config."erigon-regtest.yaml".ivars."http_corsdomain"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Comma-separated list of domains from which to accept cross-origin requests"

# [config."erigon-regtest.yaml".ivars."http_vhosts"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Comma-separated list of virtual hostnames from which to accept requests"

# [config."erigon-regtest.yaml".ivars."authrpc_vhosts"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Comma-separated list of virtual hostnames from which to accept Engine API requests"

# [config."erigon-regtest.yaml".ivars."http_api"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "APIs offered over the HTTP-RPC interface"

[config."erigon-regtest.yaml".ivars."ws_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "WS-RPC server listening port"

[config."erigon-regtest.yaml".ivars."ws"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable the WS-RPC server"

[config."erigon-regtest.yaml".ivars."ws_compression"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable compression over WebSocket"

[config."erigon-regtest.yaml".ivars."http_trace"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Print all HTTP requests to logs with INFO level"

[config."erigon-regtest.yaml".ivars."http_dbg_single"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Allow pass HTTP header 'dbg: true' to print more detailed logs"

[config."erigon-regtest.yaml".ivars."state_cache"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Amount of data to store in StateCache (enabled if no --datadir set)"

[config."erigon-regtest.yaml".ivars."rpc_batch_concurrency"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Does limit amount of goroutines to process 1 batch request"

[config."erigon-regtest.yaml".ivars."rpc_streaming_disable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable JSON streaming for some heavy endpoints"

[config."erigon-regtest.yaml".ivars."db_read_concurrency"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Does limit amount of parallel db reads"

[config."erigon-regtest.yaml".ivars."rpc_accesslist"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Specify granular (method-by-method) API allowlist"

[config."erigon-regtest.yaml".ivars."trace_compat"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Bug for bug compatibility with OE for trace routines"

[config."erigon-regtest.yaml".ivars."rpc_gascap"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets a cap on gas that can be used in eth_call/estimateGas"

[config."erigon-regtest.yaml".ivars."rpc_batch_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of requests in a batch"

[config."erigon-regtest.yaml".ivars."rpc_returndata_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of bytes returned from eth_call or similar invocations"

[config."erigon-regtest.yaml".ivars."rpc_allow_unprotected_txs"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Allow for unprotected (non-EIP155 signed) transactions to be submitted via RPC"

[config."erigon-regtest.yaml".ivars."rpc_maxgetproofrewindblockcount_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max GetProof rewind block count"

[config."erigon-regtest.yaml".ivars."rpc_txfeecap"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets a cap on transaction fee (in ether) that can be sent via the RPC APIs"

[config."erigon-regtest.yaml".ivars."txpool_api_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "TxPool API network address"

[config."erigon-regtest.yaml".ivars."trace_maxtraces"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets a limit on traces that can be returned in trace_filter"

[config."erigon-regtest.yaml".ivars."http_timeouts_read"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum duration for reading the entire request, including the body"

[config."erigon-regtest.yaml".ivars."http_timeouts_write"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum duration before timing out writes of the response"

[config."erigon-regtest.yaml".ivars."http_timeouts_idle"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum amount of time to wait for the next request when keep-alives are enabled"

[config."erigon-regtest.yaml".ivars."authrpc_timeouts_read"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum duration for reading the entire request, including the body for Engine API"

[config."erigon-regtest.yaml".ivars."authrpc_timeouts_write"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum duration before timing out writes of the response for Engine API"

[config."erigon-regtest.yaml".ivars."authrpc_timeouts_idle"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum amount of time to wait for the next request when keep-alives are enabled for Engine API"

[config."erigon-regtest.yaml".ivars."rpc_evmtimeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum amount of time to wait for the answer from EVM call"

[config."erigon-regtest.yaml".ivars."rpc_overlay_getlogstimeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum amount of time to wait for the answer from the overlay_getLogs call"

[config."erigon-regtest.yaml".ivars."rpc_overlay_replayblocktimeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum amount of time to wait to replay a single block when called from an overlay_getLogs call"

[config."erigon-regtest.yaml".ivars."snap_keepblocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Keep ancient blocks in DB (useful for debug)"

[config."erigon-regtest.yaml".ivars."snap_stop"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Workaround to stop producing new snapshots, if you meet some snapshots-related critical bug"

[config."erigon-regtest.yaml".ivars."db_pagesize"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "DB is split into pages of fixed size. Must be power of 2 and '256b <= pagesize <= 64kb'"

[config."erigon-regtest.yaml".ivars."db_size_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Runtime limit of chaindata db size"

[config."erigon-regtest.yaml".ivars."force_partial_commit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Force data commit after each stage. Don't use if node is synced."

[config."erigon-regtest.yaml".ivars."torrent_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Port to listen and serve BitTorrent protocol"

[config."erigon-regtest.yaml".ivars."torrent_conns_perfile"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of connections per file"

[config."erigon-regtest.yaml".ivars."torrent_download_slots"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Amount of files to download in parallel"

[config."erigon-regtest.yaml".ivars."torrent_staticpeers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated enode URLs to connect to"

[config."erigon-regtest.yaml".ivars."torrent_upload_rate"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Bytes per second, example: 32mb"

[config."erigon-regtest.yaml".ivars."torrent_download_rate"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Bytes per second, example: 32mb"

[config."erigon-regtest.yaml".ivars."torrent_verbosity"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Verbosity level: 0=silent, 1=error, 2=warn, 3=info, 4=debug, 5=detail"

[config."erigon-regtest.yaml".ivars."port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Network listening port"

[config."erigon-regtest.yaml".ivars."p2p_protocol"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Version of eth p2p protocol"

[config."erigon-regtest.yaml".ivars."p2p_allowed_ports"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Allowed ports to pick for different eth p2p protocol versions"

[config."erigon-regtest.yaml".ivars."nat"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "NAT port mapping mechanism (any|none|upnp|pmp|stun|extip:<IP>)"

[config."erigon-regtest.yaml".ivars."nodiscover"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disables the peer discovery mechanism"

[config."erigon-regtest.yaml".ivars."v5disc"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enables the experimental RLPx V5 (Topic Discovery) mechanism"

[config."erigon-regtest.yaml".ivars."netrestrict"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Restricts network communication to the given IP networks (CIDR masks)"

[config."erigon-regtest.yaml".ivars."nodekey"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "P2P node key file"

[config."erigon-regtest.yaml".ivars."nodekeyhex"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "P2P node key as hex (for testing)"

[config."erigon-regtest.yaml".ivars."discovery_dns"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets DNS discovery entry points"

# [config."erigon-regtest.yaml".ivars."bootnodes"]
# type = "string"
# default = ""
# priority = "low"
ignore_empty = true
# summary = "Comma-separated enode URLs for P2P discovery bootstrap"

[config."erigon-regtest.yaml".ivars."staticpeers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated enode URLs to connect to"

[config."erigon-regtest.yaml".ivars."trustedpeers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated enode URLs which are always allowed to connect, even above the peer limit"

[config."erigon-regtest.yaml".ivars."maxpeers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of network peers"

[config."erigon-regtest.yaml".ivars."chain"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Name of the network to join"

[config."erigon-regtest.yaml".ivars."dev_period"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block period to use in developer mode"

[config."erigon-regtest.yaml".ivars."vmdebug"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Record information useful for VM and contract debugging"

# [config."erigon-regtest.yaml".ivars."networkid"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Explicitly set network id"

[config."erigon-regtest.yaml".ivars."fakepow"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disables proof-of-work verification"

[config."erigon-regtest.yaml".ivars."gpo_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of recent blocks to check for gas prices"

[config."erigon-regtest.yaml".ivars."gpo_percentile"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Suggested gas price is the given percentile of a set of recent transaction gas prices"

[config."erigon-regtest.yaml".ivars."allow_insecure_unlock"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Allow insecure account unlocking when account-related RPCs are exposed by http"

[config."erigon-regtest.yaml".ivars."identity"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Custom node name"

[config."erigon-regtest.yaml".ivars."clique_checkpoint"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of blocks after which to save the vote snapshot to the database"

[config."erigon-regtest.yaml".ivars."clique_snapshots"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of recent vote snapshots to keep in memory"

[config."erigon-regtest.yaml".ivars."clique_signatures"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of recent block signatures to keep in memory"

[config."erigon-regtest.yaml".ivars."clique_datadir"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to clique db folder"

[config."erigon-regtest.yaml".ivars."mine"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable mining"

[config."erigon-regtest.yaml".ivars."proposer_disable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disables PoS proposer"

[config."erigon-regtest.yaml".ivars."miner_notify"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated HTTP URL list to notify of new work packages"

[config."erigon-regtest.yaml".ivars."miner_gaslimit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Target gas limit for mined blocks"

[config."erigon-regtest.yaml".ivars."miner_etherbase"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Public address for block mining rewards"

[config."erigon-regtest.yaml".ivars."miner_extradata"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block extra data set by the miner"

[config."erigon-regtest.yaml".ivars."miner_noverify"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable remote sealing verification"

[config."erigon-regtest.yaml".ivars."miner_sigfile"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Private key to sign blocks with"

[config."erigon-regtest.yaml".ivars."miner_recommit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Time interval to recreate the block being mined"

[config."erigon-regtest.yaml".ivars."sentry_api_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated sentry addresses '<host>:<port>'"

[config."erigon-regtest.yaml".ivars."sentry_log_peer_info"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Log detailed peer info when a peer connects or disconnects"

[config."erigon-regtest.yaml".ivars."downloader_api_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Downloader address '<host>:<port>'"

[config."erigon-regtest.yaml".ivars."downloader_disable_ipv4"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Turns off IPv4 for the downloader"

[config."erigon-regtest.yaml".ivars."downloader_disable_ipv6"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Turns off IPv6 for the downloader"

[config."erigon-regtest.yaml".ivars."no_downloader"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disables downloader component"

[config."erigon-regtest.yaml".ivars."downloader_verify"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Verify snapshots on startup, it will not report problems found, but re-download broken pieces"

[config."erigon-regtest.yaml".ivars."healthcheck"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable gRPC health check"

[config."erigon-regtest.yaml".ivars."bor_heimdall"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "URL of Heimdall service"

[config."erigon-regtest.yaml".ivars."webseed"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated URLs holding metadata about network-support infrastructure"

[config."erigon-regtest.yaml".ivars."bor_withoutheimdall"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Run without Heimdall service (for testing purposes)"

[config."erigon-regtest.yaml".ivars."bor_period"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Override the bor block period (for testing purposes)"

[config."erigon-regtest.yaml".ivars."bor_minblocksize"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Ignore the bor block period and wait for 'blocksize' transactions"

[config."erigon-regtest.yaml".ivars."bor_milestone"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enabling bor milestone processing"

[config."erigon-regtest.yaml".ivars."bor_waypoints"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enabling bor waypoints recording"

[config."erigon-regtest.yaml".ivars."polygon_sync"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enabling syncing using the new polygon sync component"

[config."erigon-regtest.yaml".ivars."ethstats"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Reporting URL of an ethstats service"

[config."erigon-regtest.yaml".ivars."override_prague"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Manually specify the Prague fork time, overriding the bundled setting"

[config."erigon-regtest.yaml".ivars."lightclient_discovery_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Address for lightclient DISCV5 protocol"

[config."erigon-regtest.yaml".ivars."lightclient_discovery_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Port for lightclient DISCV5 protocol"

[config."erigon-regtest.yaml".ivars."lightclient_discovery_tcpport"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "TCP Port for lightclient DISCV5 protocol"

[config."erigon-regtest.yaml".ivars."sentinel_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Address for sentinel"

[config."erigon-regtest.yaml".ivars."sentinel_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Port for sentinel"

[config."erigon-regtest.yaml".ivars."ots_search_max_pagesize"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max allowed page size for search methods"

[config."erigon-regtest.yaml".ivars."silkworm_exec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable Silkworm block execution"

[config."erigon-regtest.yaml".ivars."silkworm_rpc"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable embedded Silkworm RPC service"

[config."erigon-regtest.yaml".ivars."silkworm_sentry"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable embedded Silkworm Sentry service"

[config."erigon-regtest.yaml".ivars."silkworm_verbosity"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Set the log level for Silkworm console logs"

[config."erigon-regtest.yaml".ivars."silkworm_contexts"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of I/O contexts used in embedded Silkworm RPC and Sentry services"

[config."erigon-regtest.yaml".ivars."silkworm_rpc_log"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable interface log for embedded Silkworm RPC service"

[config."erigon-regtest.yaml".ivars."silkworm_rpc_log_maxsize"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max interface log file size in MB for embedded Silkworm RPC service"

[config."erigon-regtest.yaml".ivars."silkworm_rpc_log_maxfiles"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max interface log files for embedded Silkworm RPC service"

[config."erigon-regtest.yaml".ivars."silkworm_rpc_log_response"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Dump responses in interface logs for embedded Silkworm RPC service"

[config."erigon-regtest.yaml".ivars."silkworm_rpc_workers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of worker threads used in embedded Silkworm RPC service"

[config."erigon-regtest.yaml".ivars."silkworm_rpc_compatibility"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Preserve JSON-RPC compatibility using embedded Silkworm RPC service"

[config."erigon-regtest.yaml".ivars."beacon_api"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable beacon API"

[config."erigon-regtest.yaml".ivars."beacon_api_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the host to listen for beacon API requests"

[config."erigon-regtest.yaml".ivars."beacon_api_cors_allow_methods"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Set the CORS allow methods"

[config."erigon-regtest.yaml".ivars."beacon_api_cors_allow_origins"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Set the CORS allow origins"

[config."erigon-regtest.yaml".ivars."beacon_api_cors_allow_credentials"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Set the CORS allow credentials"

[config."erigon-regtest.yaml".ivars."beacon_api_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the port to listen for beacon API requests"

[config."erigon-regtest.yaml".ivars."beacon_api_read_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the seconds for a read timeout in the beacon API"

[config."erigon-regtest.yaml".ivars."beacon_api_write_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the seconds for a write timeout in the beacon API"

[config."erigon-regtest.yaml".ivars."beacon_api_protocol"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Protocol for beacon API"

[config."erigon-regtest.yaml".ivars."beacon_api_ide_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the seconds for an IDE timeout in the beacon API"

[config."erigon-regtest.yaml".ivars."caplin_backfilling"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets whether backfilling is enabled for caplin"

[config."erigon-regtest.yaml".ivars."caplin_backfilling_blob"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets whether backfilling of blobs is enabled for caplin"

[config."erigon-regtest.yaml".ivars."caplin_backfilling_blob_no_pruning"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable blob pruning in caplin"

[config."erigon-regtest.yaml".ivars."caplin_archive"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enables archival node in caplin"

[config."erigon-regtest.yaml".ivars."trusted_setup_file"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Absolute path to trusted_setup.json file"

[config."erigon-regtest.yaml".ivars."rpc_slow"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Print in logs RPC requests slower than given threshold"

[config."erigon-regtest.yaml".ivars."txpool_gossip_disable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disabling p2p gossip of txs"

[config."erigon-regtest.yaml".ivars."sync_loop_block_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the maximum number of blocks to process per loop iteration"

[config."erigon-regtest.yaml".ivars."sync_loop_break_after"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the last stage of the sync loop to run"

[config."erigon-regtest.yaml".ivars."sync_loop_prune_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the maximum number of blocks to prune per loop iteration"

[config."erigon-regtest.yaml".ivars."pprof"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable the pprof HTTP server"

[config."erigon-regtest.yaml".ivars."pprof_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "pprof HTTP server listening interface"

[config."erigon-regtest.yaml".ivars."pprof_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "pprof HTTP server listening port"

[config."erigon-regtest.yaml".ivars."pprof_cpuprofile"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write CPU profile to the given file"

[config."erigon-regtest.yaml".ivars."trace"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write execution trace to the given file"

[config."erigon-regtest.yaml".ivars."metrics"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable metrics collection and reporting"

[config."erigon-regtest.yaml".ivars."metrics_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable stand-alone metrics HTTP server listening interface"

[config."erigon-regtest.yaml".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Metrics HTTP server listening port"

[config."erigon-regtest.yaml".ivars."diagnostics_disabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable diagnostics"

[config."erigon-regtest.yaml".ivars."diagnostics_endpoint_addr"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Diagnostics HTTP server listening interface"

[config."erigon-regtest.yaml".ivars."diagnostics_endpoint_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Diagnostics HTTP server listening port"

[config."erigon-regtest.yaml".ivars."log_json"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Format console logs with JSON"

[config."erigon-regtest.yaml".ivars."log_console_json"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Format console logs with JSON"

[config."erigon-regtest.yaml".ivars."log_dir_json"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Format file logs with JSON"

[config."erigon-regtest.yaml".ivars."verbosity"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Set the log level for console logs"

[config."erigon-regtest.yaml".ivars."log_console_verbosity"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Set the log level for console logs"

[config."erigon-regtest.yaml".ivars."log_dir_disable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable disk logging"

# [config."erigon-regtest.yaml".ivars."log_dir_path"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Path to store user and error logs to disk"

[config."erigon-regtest.yaml".ivars."log_dir_prefix"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The file name prefix for logs stored to disk"

[config."erigon-regtest.yaml".ivars."log_dir_verbosity"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Set the log verbosity for logs stored to disk"

[config."erigon-regtest.yaml".ivars."log_delays"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable block delay logging"

[config."erigon-regtest.yaml".ivars."config"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets erigon flags from YAML/TOML file"
