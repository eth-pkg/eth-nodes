name = "eth-node-geth-regtest"
bin_package = "eth-node-geth"
binary = "/usr/lib/eth-node-geth-regtest/run-geth-service.sh"
user = { name = "eth-node-geth-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-geth-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/geth
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/geth
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-geth-service.sh /usr/lib/eth-node-geth-regtest/", 
    "debian/scripts/run-geth.sh /usr/lib/eth-node-geth-regtest/bin/",
    "debian/tmp/eth-node-geth-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-geth-regtest",
    "debian/keystore /var/lib/eth-node-regtest/geth/",
    "debian/geth_password.txt /var/lib/eth-node-regtest/geth/",
    "debian/sk.json /var/lib/eth-node-regtest/geth/",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-geth for network: regtest"

[config."geth-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-geth-regtest/postprocess.sh"]

[config."geth-regtest.conf"]
format = "plain"

[config."geth-regtest.conf".ivars."datadir"]
type = "string"
default = "$DATA_DIR/geth"
priority = "low"
summary = "Data directory for the databases and keystore"

[config."geth-regtest.conf".ivars."authrpc_jwtsecret"]
type = "string"
default = "$JWT_FILE"
priority = "low"
summary = "Path to a JWT secret to use for authenticated RPC endpoints"

[config."geth-regtest.conf".ivars."http"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the HTTP-RPC server"

[config."geth-regtest.conf".ivars."http_api"]
type = "string"
default = "eth,net,web3"
priority = "low"
summary = "APIs offered over the HTTP-RPC interface"

[config."geth-regtest.conf".ivars."syncmode"]
type = "string"
default = "full"
priority = "low"
summary = "Blockchain sync mode (\"snap\" or \"full\")"

[config."geth-regtest.conf".ivars."authrpc_addr"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Listening address for authenticated APIs"

[config."geth-regtest.conf".ivars."http_addr"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "HTTP-RPC server listening interface"


[config."geth-regtest.conf".ivars."authrpc_vhosts"]
type = "string"
default = "localhost"
priority = "low"
summary = "Comma separated list of virtual hostnames from which to accept requests (server enforced). Accepts '*' wildcard."

[config."geth-regtest.conf".ivars."allow_insecure_unlock"]
type = "string"
default = "true"
priority = "low"
summary = "Allow insecure account unlocking when account-related RPCs are exposed by HTTP"

[config."geth-regtest.conf".ivars."password"]
type = "string"
default = "$DATA_DIR/geth/geth_password.txt"
priority = "low"
summary = "Password file to use for non-interactive password input"


[config."geth-regtest.conf".ivars."nodiscover"]
type = "string"
default = "true"
priority = "low"
summary = "Disables the peer discovery mechanism (manual peer addition)"


[config."geth-regtest.conf".ivars."networkid"]
type = "string"
default = "$NETWORK_ID"
priority = "low"
summary = "Explicitly set network ID (integer)"


[config."geth-regtest.conf".ivars."bootnodes"]
type = "string"
default = "$BOOTNODES_ENR"
priority = "low"
summary = "Comma separated enode URLs for P2P discovery bootstrap"


[config."geth-regtest.conf".ivars."log_file"]
type = "string"
default = "$LOG_DIR/geth/geth.log"
priority = "low"
summary = "Write logs to a file."

[config."geth-regtest.conf".ivars."log_format"]
type = "string"
default = "logfmt"
priority = "low"
summary = "Log format to use (json|logfmt|terminal)."


# All Default options, commented out the used one
### OPTIONS below are all set to default and provided to be used with debconf

# ACCOUNT

# [config."geth-regtest.conf".ivars."allow_insecure_unlock"]
# type = "string"
# default = "false"
# priority = "low"
# summary = "Allow insecure account unlocking when account-related RPCs are exposed by http."

[config."geth-regtest.conf".ivars."keystore"]
type = "string"
default = ""
priority = "low"
summary = "Directory for the keystore (default = inside the datadir)."

[config."geth-regtest.conf".ivars."lightkdf"]
type = "string"
default = "false"
priority = "low"
summary = "Reduce key-derivation RAM & CPU usage at some expense of KDF strength."

# [config."geth-regtest.conf".ivars."password"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Password file to use for non-interactive password input."

[config."geth-regtest.conf".ivars."pcscdpath"]
type = "string"
default = ""
priority = "low"
summary = "Path to the smartcard daemon (pcscd) socket file."

[config."geth-regtest.conf".ivars."signer"]
type = "string"
default = ""
priority = "low"
summary = "External signer (url or path to ipc file)."

[config."geth-regtest.conf".ivars."unlock"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of accounts to unlock."

[config."geth-regtest.conf".ivars."usb"]
type = "string"
default = "false"
priority = "low"
summary = "Enable monitoring and management of USB hardware wallets."

# ALIASED (deprecated)

[config."geth-regtest.conf".ivars."cache_trie_journal"]
type = "string"
default = ""
priority = "low"
summary = "Disk journal directory for trie cache to survive node restarts."

[config."geth-regtest.conf".ivars."cache_trie_rejournal"]
type = "string"
default = ""
priority = "low"
summary = "Time interval to regenerate the trie cache journal."

[config."geth-regtest.conf".ivars."light_egress"]
type = "string"
default = ""
priority = "low"
summary = "Outgoing bandwidth limit for serving light clients (deprecated)."

[config."geth-regtest.conf".ivars."light_ingress"]
type = "string"
default = ""
priority = "low"
summary = "Incoming bandwidth limit for serving light clients (deprecated)."

[config."geth-regtest.conf".ivars."light_maxpeers"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of light clients to serve or light servers to attach to (deprecated)."

[config."geth-regtest.conf".ivars."light_nopruning"]
type = "string"
default = "false"
priority = "low"
summary = "Disable ancient light chain data pruning (deprecated)."

[config."geth-regtest.conf".ivars."light_nosyncserve"]
type = "string"
default = "false"
priority = "low"
summary = "Enables serving light clients before syncing (deprecated)."

[config."geth-regtest.conf".ivars."light_serve"]
type = "string"
default = ""
priority = "low"
summary = "Maximum percentage of time allowed for serving LES requests (deprecated)."

[config."geth-regtest.conf".ivars."log_backtrace"]
type = "string"
default = ""
priority = "low"
summary = "Request a stack trace at a specific logging statement (deprecated)."

[config."geth-regtest.conf".ivars."log_debug"]
type = "string"
default = "false"
priority = "low"
summary = "Prepends log messages with call-site location (deprecated)."

[config."geth-regtest.conf".ivars."metrics_expensive"]
type = "string"
default = "false"
priority = "low"
summary = "Enable expensive metrics collection and reporting (deprecated)."

[config."geth-regtest.conf".ivars."mine"]
type = "string"
default = "false"
priority = "low"
summary = "Enable mining (deprecated)."

[config."geth-regtest.conf".ivars."miner_etherbase"]
type = "string"
default = ""
priority = "low"
summary = "0x-prefixed public address for block mining rewards (deprecated)."

[config."geth-regtest.conf".ivars."miner_newpayload_timeout"]
type = "string"
default = ""
priority = "low"
summary = "Maximum time allowance for creating a new payload (deprecated)."

[config."geth-regtest.conf".ivars."nousb"]
type = "string"
default = "false"
priority = "low"
summary = "Disables monitoring for and managing USB hardware wallets (deprecated)."

[config."geth-regtest.conf".ivars."txlookuplimit"]
type = "string"
default = ""
priority = "low"
summary = "Number of recent blocks to maintain transactions index for (deprecated)."

[config."geth-regtest.conf".ivars."v5disc"]
type = "string"
default = "false"
priority = "low"
summary = "Enables the experimental RLPx V5 (Topic Discovery) mechanism (deprecated)."

[config."geth-regtest.conf".ivars."whitelist"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated block number-to-hash mappings to enforce (deprecated)."

# API AND CONSOLE

# [config."geth-regtest.conf".ivars."authrpc_addr"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Listening address for authenticated APIs."

# [config."geth-regtest.conf".ivars."authrpc_jwtsecret"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Path to a JWT secret to use for authenticated RPC endpoints."

[config."geth-regtest.conf".ivars."authrpc_port"]
type = "string"
default = ""
priority = "low"
summary = "Listening port for authenticated APIs."

# [config."geth-regtest.conf".ivars."authrpc_vhosts"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma-separated list of virtual hostnames from which to accept requests."

[config."geth-regtest.conf".ivars."exec"]
type = "string"
default = ""
priority = "low"
summary = "Execute JavaScript statement."

[config."geth-regtest.conf".ivars."graphql"]
type = "string"
default = "false"
priority = "low"
summary = "Enable GraphQL on the HTTP-RPC server."

[config."geth-regtest.conf".ivars."graphql_corsdomain"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of domains from which to accept cross-origin requests."

[config."geth-regtest.conf".ivars."graphql_vhosts"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of virtual hostnames from which to accept requests."

[config."geth-regtest.conf".ivars."header"]
type = "string"
default = ""
priority = "low"
summary = "Pass custom headers to the RPC server."

# [config."geth-regtest.conf".ivars."http"]
# type = "string"
# default = "false"
# priority = "low"
# summary = "Enable the HTTP-RPC server."

# [config."geth-regtest.conf".ivars."http_addr"]
# type = "string"
# default = ""
# priority = "low"
# summary = "HTTP-RPC server listening interface."

# [config."geth-regtest.conf".ivars."http_api"]
# type = "string"
# default = ""
# priority = "low"
# summary = "APIs offered over the HTTP-RPC interface."

[config."geth-regtest.conf".ivars."http_corsdomain"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of domains from which to accept cross-origin requests."

[config."geth-regtest.conf".ivars."http_port"]
type = "string"
default = ""
priority = "low"
summary = "HTTP-RPC server listening port."

[config."geth-regtest.conf".ivars."http_rpcprefix"]
type = "string"
default = ""
priority = "low"
summary = "HTTP path prefix on which JSON-RPC is served."

[config."geth-regtest.conf".ivars."http_vhosts"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of virtual hostnames from which to accept requests."

[config."geth-regtest.conf".ivars."ipcdisable"]
type = "string"
default = "false"
priority = "low"
summary = "Disable the IPC-RPC server."

[config."geth-regtest.conf".ivars."ipcpath"]
type = "string"
default = ""
priority = "low"
summary = "Filename for IPC socket/pipe within the datadir."

[config."geth-regtest.conf".ivars."jspath"]
type = "string"
default = ""
priority = "low"
summary = "JavaScript root path for `loadScript`."

[config."geth-regtest.conf".ivars."preload"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of JavaScript files to preload into the console."

[config."geth-regtest.conf".ivars."rpc_allow_unprotected_txs"]
type = "string"
default = "false"
priority = "low"
summary = "Allow unprotected (non EIP155 signed) transactions to be submitted via RPC."

[config."geth-regtest.conf".ivars."rpc_batch_request_limit"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of requests in a batch."

[config."geth-regtest.conf".ivars."rpc_batch_response_max_size"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of bytes returned from a batched call."

[config."geth-regtest.conf".ivars."rpc_enabledeprecatedpersonal"]
type = "string"
default = "false"
priority = "low"
summary = "Enables the deprecated personal namespace."

[config."geth-regtest.conf".ivars."rpc_evmtimeout"]
type = "string"
default = ""
priority = "low"
summary = "Sets a timeout used for eth_call."

[config."geth-regtest.conf".ivars."rpc_gascap"]
type = "string"
default = ""
priority = "low"
summary = "Sets a cap on gas that can be used in eth_call/estimateGas."

[config."geth-regtest.conf".ivars."rpc_txfeecap"]
type = "string"
default = ""
priority = "low"
summary = "Sets a cap on transaction fees that can be sent via the RPC APIs."

[config."geth-regtest.conf".ivars."ws"]
type = "string"
default = "false"
priority = "low"
summary = "Enable the WS-RPC server."

[config."geth-regtest.conf".ivars."ws_addr"]
type = "string"
default = ""
priority = "low"
summary = "WS-RPC server listening interface."

[config."geth-regtest.conf".ivars."ws_api"]
type = "string"
default = ""
priority = "low"
summary = "APIs offered over the WS-RPC interface."

[config."geth-regtest.conf".ivars."ws_origins"]
type = "string"
default = ""
priority = "low"
summary = "Origins from which to accept websockets requests."

[config."geth-regtest.conf".ivars."ws_port"]
type = "string"
default = ""
priority = "low"
summary = "WS-RPC server listening port."

[config."geth-regtest.conf".ivars."ws_rpcprefix"]
type = "string"
default = ""
priority = "low"
summary = "HTTP path prefix on which JSON-RPC is served."

# BEACON CHAIN

[config."geth-regtest.conf".ivars."beacon_api"]
type = "string"
default = ""
priority = "low"
summary = "Beacon node (CL) light client API URL."

[config."geth-regtest.conf".ivars."beacon_api_header"]
type = "string"
default = ""
priority = "low"
summary = "Pass custom HTTP header fields to the remote beacon node API in key:value format."

[config."geth-regtest.conf".ivars."beacon_checkpoint"]
type = "string"
default = ""
priority = "low"
summary = "Beacon chain weak subjectivity checkpoint block hash."

[config."geth-regtest.conf".ivars."beacon_config"]
type = "string"
default = ""
priority = "low"
summary = "Beacon chain config YAML file."

[config."geth-regtest.conf".ivars."beacon_genesis_gvroot"]
type = "string"
default = ""
priority = "low"
summary = "Beacon chain genesis validators root."

[config."geth-regtest.conf".ivars."beacon_genesis_time"]
type = "string"
default = ""
priority = "low"
summary = "Beacon chain genesis time."

[config."geth-regtest.conf".ivars."beacon_nofilter"]
type = "string"
default = "false"
priority = "low"
summary = "Disable future slot signature filter."

[config."geth-regtest.conf".ivars."beacon_threshold"]
type = "string"
default = ""
priority = "low"
summary = "Beacon sync committee participation threshold."


# DEVELOPER CHAIN

[config."geth-regtest.conf".ivars."dev"]
type = "string"
default = "false"
priority = "low"
summary = "Ephemeral proof-of-authority network with a pre-funded developer account."

[config."geth-regtest.conf".ivars."dev_gaslimit"]
type = "string"
default = ""
priority = "low"
summary = "Initial block gas limit."

[config."geth-regtest.conf".ivars."dev_period"]
type = "string"
default = ""
priority = "low"
summary = "Block period to use in developer mode (0 = mine only if transaction pending)."


# ETHEREUM

[config."geth-regtest.conf".ivars."bloomfilter_size"]
type = "string"
default = ""
priority = "low"
summary = "Megabytes of memory allocated to bloom-filter for pruning."

[config."geth-regtest.conf".ivars."config"]
type = "string"
default = ""
priority = "low"
summary = "TOML configuration file."

# [config."geth-regtest.conf".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Data directory for the databases and keystore."

[config."geth-regtest.conf".ivars."datadir_ancient"]
type = "string"
default = ""
priority = "low"
summary = "Root directory for ancient data (default = inside chaindata)."

[config."geth-regtest.conf".ivars."datadir_minfreedisk"]
type = "string"
default = ""
priority = "low"
summary = "Minimum free disk space in MB, once reached triggers auto shut down."

[config."geth-regtest.conf".ivars."db_engine"]
type = "string"
default = ""
priority = "low"
summary = "Backing database implementation to use ('pebble' or 'leveldb')."

[config."geth-regtest.conf".ivars."eth_requiredblocks"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated block number-to-hash mappings to require for peering."

[config."geth-regtest.conf".ivars."exitwhensynced"]
type = "string"
default = "false"
priority = "low"
summary = "Exits after block synchronization completes."

[config."geth-regtest.conf".ivars."holesky"]
type = "string"
default = "false"
priority = "low"
summary = "Holesky network: pre-configured proof-of-stake test network."

[config."geth-regtest.conf".ivars."mainnet"]
type = "string"
default = "false"
priority = "low"
summary = "Ethereum mainnet."

# [config."geth-regtest.conf".ivars."networkid"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Explicitly set network id (For testnets: use --sepolia, --holesky instead)."

[config."geth-regtest.conf".ivars."override_cancun"]
type = "string"
default = ""
priority = "low"
summary = "Manually specify the Cancun fork timestamp, overriding the bundled setting."

[config."geth-regtest.conf".ivars."override_verkle"]
type = "string"
default = ""
priority = "low"
summary = "Manually specify the Verkle fork timestamp, overriding the bundled setting."

[config."geth-regtest.conf".ivars."sepolia"]
type = "string"
default = "false"
priority = "low"
summary = "Sepolia network: pre-configured proof-of-work test network."

[config."geth-regtest.conf".ivars."snapshot"]
type = "string"
default = "false"
priority = "low"
summary = "Enables snapshot-database mode."


# GAS PRICE ORACLE

[config."geth-regtest.conf".ivars."gpo_blocks"]
type = "string"
default = ""
priority = "low"
summary = "Number of recent blocks to check for gas prices."

[config."geth-regtest.conf".ivars."gpo_ignoreprice"]
type = "string"
default = ""
priority = "low"
summary = "Gas price below which GPO will ignore transactions."

[config."geth-regtest.conf".ivars."gpo_maxprice"]
type = "string"
default = ""
priority = "low"
summary = "Maximum transaction priority fee (or gas price before London fork) to be recommended by GPO."

[config."geth-regtest.conf".ivars."gpo_percentile"]
type = "string"
default = ""
priority = "low"
summary = "Suggested gas price is the given percentile of a set of recent transaction gas prices."


# LOGGING AND DEBUGGING

[config."geth-regtest.conf".ivars."log_compress"]
type = "string"
default = "false"
priority = "low"
summary = "Compress the log files."

# [config."geth-regtest.conf".ivars."log_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Write logs to a file."

# [config."geth-regtest.conf".ivars."log_format"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Log format to use (json|logfmt|terminal)."

[config."geth-regtest.conf".ivars."log_maxage"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of days to retain a log file."

[config."geth-regtest.conf".ivars."log_maxbackups"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of log files to retain."

[config."geth-regtest.conf".ivars."log_maxsize"]
type = "string"
default = ""
priority = "low"
summary = "Maximum size in MB of a single log file."

[config."geth-regtest.conf".ivars."log_rotate"]
type = "string"
default = "false"
priority = "low"
summary = "Enables log file rotation."

[config."geth-regtest.conf".ivars."log_vmodule"]
type = "string"
default = ""
priority = "low"
summary = "Per-module verbosity: comma-separated list of <pattern>=<level>."

[config."geth-regtest.conf".ivars."nocompaction"]
type = "string"
default = "false"
priority = "low"
summary = "Disables database compaction after import."

[config."geth-regtest.conf".ivars."pprof"]
type = "string"
default = "false"
priority = "low"
summary = "Enable the pprof HTTP server."

[config."geth-regtest.conf".ivars."pprof_addr"]
type = "string"
default = ""
priority = "low"
summary = "pprof HTTP server listening interface."

[config."geth-regtest.conf".ivars."pprof_blockprofilerate"]
type = "string"
default = ""
priority = "low"
summary = "Turn on block profiling with the given rate."

[config."geth-regtest.conf".ivars."pprof_cpuprofile"]
type = "string"
default = ""
priority = "low"
summary = "Write CPU profile to the given file."

[config."geth-regtest.conf".ivars."pprof_memprofilerate"]
type = "string"
default = ""
priority = "low"
summary = "Turn on memory profiling with the given rate."

[config."geth-regtest.conf".ivars."pprof_port"]
type = "string"
default = ""
priority = "low"
summary = "pprof HTTP server listening port."

[config."geth-regtest.conf".ivars."remotedb"]
type = "string"
default = ""
priority = "low"
summary = "URL for remote database."

[config."geth-regtest.conf".ivars."trace"]
type = "string"
default = ""
priority = "low"
summary = "Write execution trace to the given file."

[config."geth-regtest.conf".ivars."verbosity"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity: 0=silent, 1=error, 2=warn, 3=info, 4=debug, 5=detail."


# METRICS AND STATS

[config."geth-regtest.conf".ivars."ethstats"]
type = "string"
default = ""
priority = "low"
summary = "Reporting URL of an ethstats service."

[config."geth-regtest.conf".ivars."metrics"]
type = "string"
default = "false"
priority = "low"
summary = "Enable metrics collection and reporting."

[config."geth-regtest.conf".ivars."metrics_addr"]
type = "string"
default = ""
priority = "low"
summary = "Enable stand-alone metrics HTTP server listening interface."

[config."geth-regtest.conf".ivars."metrics_influxdb"]
type = "string"
default = "false"
priority = "low"
summary = "Enable metrics export/push to an external InfluxDB database."

[config."geth-regtest.conf".ivars."metrics_influxdb_bucket"]
type = "string"
default = ""
priority = "low"
summary = "InfluxDB bucket name to push reported metrics to (v2 only)."

[config."geth-regtest.conf".ivars."metrics_influxdb_database"]
type = "string"
default = ""
priority = "low"
summary = "InfluxDB database name to push reported metrics to."

[config."geth-regtest.conf".ivars."metrics_influxdb_endpoint"]
type = "string"
default = ""
priority = "low"
summary = "InfluxDB API endpoint to report metrics to."

[config."geth-regtest.conf".ivars."metrics_influxdb_organization"]
type = "string"
default = ""
priority = "low"
summary = "InfluxDB organization name (v2 only)."

[config."geth-regtest.conf".ivars."metrics_influxdb_password"]
type = "string"
default = ""
priority = "low"
summary = "Password to authorize access to the database."

[config."geth-regtest.conf".ivars."metrics_influxdb_tags"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated InfluxDB tags (key/values) attached to all measurements."

[config."geth-regtest.conf".ivars."metrics_influxdb_token"]
type = "string"
default = ""
priority = "low"
summary = "Token to authorize access to the database (v2 only)."

[config."geth-regtest.conf".ivars."metrics_influxdb_username"]
type = "string"
default = ""
priority = "low"
summary = "Username to authorize access to the database."

[config."geth-regtest.conf".ivars."metrics_influxdbv2"]
type = "string"
default = "false"
priority = "low"
summary = "Enable metrics export/push to an external InfluxDB v2 database."

[config."geth-regtest.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = "Metrics HTTP server listening port."

# MINER

[config."geth-regtest.conf".ivars."miner_extradata"]
type = "string"
default = ""
priority = "low"
summary = "Block extra data set by the miner."

[config."geth-regtest.conf".ivars."miner_gaslimit"]
type = "string"
default = ""
priority = "low"
summary = "Target gas ceiling for mined blocks."

[config."geth-regtest.conf".ivars."miner_gasprice"]
type = "string"
default = ""
priority = "low"
summary = "Minimum gas price for mining a transaction."

[config."geth-regtest.conf".ivars."miner_pending_feerecipient"]
type = "string"
default = ""
priority = "low"
summary = "0x prefixed public address for the pending block producer."

[config."geth-regtest.conf".ivars."miner_recommit"]
type = "string"
default = ""
priority = "low"
summary = "Time interval to recreate the block being mined."


# MISC

[config."geth-regtest.conf".ivars."synctarget"]
type = "string"
default = ""
priority = "low"
summary = "Hash of the block to full sync to (dev testing feature)."


# NETWORKING

# [config."geth-regtest.conf".ivars."bootnodes"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma-separated enode URLs for P2P discovery bootstrap."

[config."geth-regtest.conf".ivars."discovery_dns"]
type = "string"
default = ""
priority = "low"
summary = "Sets DNS discovery entry points (use empty string to disable DNS)."

[config."geth-regtest.conf".ivars."discovery_port"]
type = "string"
default = ""
priority = "low"
summary = "Custom UDP port for P2P discovery."

[config."geth-regtest.conf".ivars."discovery_v4"]
type = "string"
default = "false"
priority = "low"
summary = "Enable the V4 discovery mechanism."

[config."geth-regtest.conf".ivars."discovery_v5"]
type = "string"
default = "false"
priority = "low"
summary = "Enable the V5 discovery mechanism."

[config."geth-regtest.conf".ivars."identity"]
type = "string"
default = ""
priority = "low"
summary = "Custom node name."

[config."geth-regtest.conf".ivars."maxpeers"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of network peers."

[config."geth-regtest.conf".ivars."maxpendpeers"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of pending connection attempts."

[config."geth-regtest.conf".ivars."nat"]
type = "string"
default = ""
priority = "low"
summary = "NAT port mapping mechanism (any|none|upnp|pmp|extip:<IP>)."

[config."geth-regtest.conf".ivars."netrestrict"]
type = "string"
default = ""
priority = "low"
summary = "Restrict network communication to the given IP networks (CIDR masks)."

[config."geth-regtest.conf".ivars."nodekey"]
type = "string"
default = ""
priority = "low"
summary = "P2P node key file."

[config."geth-regtest.conf".ivars."nodekeyhex"]
type = "string"
default = ""
priority = "low"
summary = "P2P node key as hex."

# [config."geth-regtest.conf".ivars."nodiscover"]
# type = "string"
# default = "false"
# priority = "low"
# summary = "Disable the peer discovery mechanism."

[config."geth-regtest.conf".ivars."port"]
type = "string"
default = ""
priority = "low"
summary = "Network listening port."


# PERFORMANCE TUNING

[config."geth-regtest.conf".ivars."cache"]
type = "string"
default = ""
priority = "low"
summary = "Megabytes of memory allocated to internal caching."

[config."geth-regtest.conf".ivars."cache_blocklogs"]
type = "string"
default = ""
priority = "low"
summary = "Size (in number of blocks) of the log cache for filtering."

[config."geth-regtest.conf".ivars."cache_database"]
type = "string"
default = ""
priority = "low"
summary = "Percentage of cache memory allowance to use for database IO."

[config."geth-regtest.conf".ivars."cache_gc"]
type = "string"
default = ""
priority = "low"
summary = "Percentage of cache memory allowance to use for trie pruning."

[config."geth-regtest.conf".ivars."cache_noprefetch"]
type = "string"
default = "false"
priority = "low"
summary = "Disable heuristic state prefetch during block import."

[config."geth-regtest.conf".ivars."cache_preimages"]
type = "string"
default = "false"
priority = "low"
summary = "Enable recording the SHA3/keccak preimages of trie keys."

[config."geth-regtest.conf".ivars."cache_snapshot"]
type = "string"
default = ""
priority = "low"
summary = "Percentage of cache memory allowance to use for snapshot caching."

[config."geth-regtest.conf".ivars."cache_trie"]
type = "string"
default = ""
priority = "low"
summary = "Percentage of cache memory allowance to use for trie caching."

[config."geth-regtest.conf".ivars."crypto_kzg"]
type = "string"
default = ""
priority = "low"
summary = "KZG library implementation to use (gokzg or ckzg)."

[config."geth-regtest.conf".ivars."fdlimit"]
type = "string"
default = ""
priority = "low"
summary = "Raise the open file descriptor resource limit."


# STATE HISTORY MANAGEMENT

[config."geth-regtest.conf".ivars."gcmode"]
type = "string"
default = ""
priority = "low"
summary = "Blockchain garbage collection mode (full or archive)."

[config."geth-regtest.conf".ivars."history_state"]
type = "string"
default = ""
priority = "low"
summary = "Number of recent blocks to retain state history for."

[config."geth-regtest.conf".ivars."history_transactions"]
type = "string"
default = ""
priority = "low"
summary = "Number of recent blocks to maintain transactions index for."

[config."geth-regtest.conf".ivars."state_scheme"]
type = "string"
default = ""
priority = "low"
summary = "Scheme to use for storing Ethereum state (hash or path)."

# [config."geth-regtest.conf".ivars."syncmode"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Blockchain sync mode (snap or full)."


# TRANSACTION POOL (BLOB)

[config."geth-regtest.conf".ivars."blobpool_datacap"]
type = "string"
default = ""
priority = "low"
summary = "Disk space to allocate for pending blob transactions (soft limit)."

[config."geth-regtest.conf".ivars."blobpool_datadir"]
type = "string"
default = ""
priority = "low"
summary = "Data directory to store blob transactions."

[config."geth-regtest.conf".ivars."blobpool_pricebump"]
type = "string"
default = ""
priority = "low"
summary = "Price bump percentage to replace an already existing blob transaction."


# TRANSACTION POOL (EVM)

[config."geth-regtest.conf".ivars."txpool_accountqueue"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of non-executable transaction slots permitted per account."

[config."geth-regtest.conf".ivars."txpool_accountslots"]
type = "string"
default = ""
priority = "low"
summary = "Minimum number of executable transaction slots guaranteed per account."

[config."geth-regtest.conf".ivars."txpool_globalqueue"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of non-executable transaction slots for all accounts."

[config."geth-regtest.conf".ivars."txpool_globalslots"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of executable transaction slots for all accounts."

[config."geth-regtest.conf".ivars."txpool_journal"]
type = "string"
default = ""
priority = "low"
summary = "Disk journal for local transactions to survive node restarts."

[config."geth-regtest.conf".ivars."txpool_lifetime"]
type = "string"
default = ""
priority = "low"
summary = "Maximum amount of time non-executable transactions are queued."

[config."geth-regtest.conf".ivars."txpool_locals"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated accounts to treat as locals (no flush, priority inclusion)."

[config."geth-regtest.conf".ivars."txpool_nolocals"]
type = "string"
default = "false"
priority = "low"
summary = "Disables price exemptions for locally submitted transactions."

[config."geth-regtest.conf".ivars."txpool_pricebump"]
type = "string"
default = ""
priority = "low"
summary = "Price bump percentage to replace an already existing transaction."

[config."geth-regtest.conf".ivars."txpool_pricelimit"]
type = "string"
default = ""
priority = "low"
summary = "Minimum gas price tip to enforce for acceptance into the pool."

[config."geth-regtest.conf".ivars."txpool_rejournal"]
type = "string"
default = ""
priority = "low"
summary = "Time interval to regenerate the local transaction journal."

# VIRTUAL MACHINE

[config."geth-regtest.conf".ivars."vmdebug"]
type = "string"
default = "false"
priority = "low"
summary = "Record information useful for VM and contract debugging."

[config."geth-regtest.conf".ivars."vmtrace"]
type = "string"
default = ""
priority = "low"
summary = "Name of tracer which should record internal VM operations."

[config."geth-regtest.conf".ivars."vmtrace_jsonconfig"]
type = "string"
default = ""
priority = "low"
summary = "Tracer configuration in JSON format."
