name = "eth-node-besu-regtest"
bin_package = "eth-node-besu"
binary = "/usr/lib/eth-node-besu-regtest/run-besu-service.sh"
user = { name = "eth-node-besu-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-besu-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/besu
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/besu
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-besu-service.sh /usr/lib/eth-node-besu-regtest/", 
    "debian/scripts/run-besu.sh /usr/lib/eth-node-besu-regtest/bin/",
    "debian/scripts/admin.xml /usr/lib/eth-node-besu-regtest/",
    "debian/tmp/eth-node-besu-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-besu-regtest",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-besu for network: regtest"

[config."besu-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-besu-regtest/postprocess.sh"]

[config."besu-regtest.conf"]
format = "plain"

# TESTNET OPTIONS 
### USED OPTIONS 

[config."besu-regtest.conf".ivars."data_path"]
type = "string"
default = "$DATA_DIR/besu"
priority = "low"
summary = "Path to Besu data directory (default: $DATA_DIR/besu)"

[config."besu-regtest.conf".ivars."engine_jwt_secret"]
type = "string"
default = "$JWT_FILE"
priority = "low"
summary = "Disable authentication for Engine APIs (default: false)."

[config."besu-regtest.conf".ivars."network"]
type = "string"
default = ""
priority = "low"
summary = "Synchronize against the indicated network: MAINNET, SEPOLIA, GOERLI, HOLESKY, DEV, FUTURE_EIPS, EXPERIMENTAL_EIPS, CLASSIC, MORDOR. (default: MAINNET) leave it empty for custom network"

[config."besu-regtest.conf".ivars."bootnodes"]
type = "string"
default = "$BOOTNODES_ENODE"
priority = "low"
summary = "Comma separated enode URLs for P2P discovery bootstrap."

[config."besu-regtest.conf".ivars."network_id"]
type = "string"
default = "$NETWORK_ID"
priority = "low"
summary = "P2P network identifier. (default: the selected network chain ID or custom genesis chain ID)"


[config."besu-regtest.conf".ivars."engine_rpc_enabled"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the engine API even in the absence of merge-specific configurations."

[config."besu-regtest.conf".ivars."sync_mode"]
type = "string"
default = "full"
priority = "low"
summary = "Synchronization mode, possible values are FULL, FAST, SNAP, CHECKPOINT, X_SNAP, X_CHECKPOINT (default: SNAP if a --network is supplied and privacy isn't enabled. FULL otherwise.)"

[config."besu-regtest.conf".ivars."genesis_file"]
type = "string"
default = "$TESTNET_DIR/besu.json"
priority = "low"
summary = "Genesis file for your custom network. Requires --network-id to be set. Cannot be used with --network."

[config."besu-regtest.conf".ivars."bonsai_limit_trie_logs_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Limit the number of trie logs that are retained. (default: true)"

[config."besu-regtest.conf".ivars."p2p_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable P2P functionality (default: true)."

[config."besu-regtest.conf".ivars."rpc_http_api"]
type = "string"
default = "ADMIN,CLIQUE,ETH,NET,DEBUG,TXPOOL,ENGINE,TRACE,WEB3"
priority = "low"
summary = "Set RPC HTTP API to ETH"

[config."besu-regtest.conf".ivars."rpc_http_enabled"]
type = "string"
default = "true"
priority = "low"
summary = "Set to start the JSON-RPC HTTP service (default: false)."

[config."besu-regtest.conf".ivars."rpc_http_port"]
type = "string"
default = "$EL_RPC_PORT"
priority = "low"
summary = "Port for JSON-RPC HTTP to listen on (default: 8545)."

[config."besu-regtest.conf".ivars."host_allowlist"]
type = "string"
default = "*"
priority = "low"
summary = "Comma separated list of hostnames to allow for RPC access, or * to accept any host (default: localhost,127.0.0.1)"

[config."besu-regtest.conf".ivars."rpc_http_cors_origins"]
type = "string"
default = "*"
priority = "low"
summary = "Comma separated origin domain URLs for CORS validation."

[config."besu-regtest.conf".ivars."engine_host_allowlist"]
type = "string"
default = "*"
priority = "low"
summary = "Comma separated list of hostnames to allow for ENGINE API access (default: localhost,127.0.0.1)."


# All Default options, commented out the used one
### OPTIONS below are all set to default and provided to be used with debconf

[config."besu-regtest.conf".ivars."auto_log_bloom_caching_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable automatic log bloom caching (default: true)"

[config."besu-regtest.conf".ivars."bonsai_historical_block_limit"]
type = "string"
default = ""
priority = "low"
summary = "Limit of historical layers that can be loaded with BONSAI (default: 512). When using --bonsai-limit-trie-logs-enabled it will also be used as the number of layers of trie logs to retain."


# [config."besu-regtest.conf".ivars."bonsai_limit_trie_logs_enabled"]
# type = "string"
# default = "false"
# priority = "low"
# summary = "Limit the number of trie logs that are retained. (default: true)"

[config."besu-regtest.conf".ivars."bonsai_trie_logs_pruning_window_size"]
type = "string"
default = ""
priority = "low"
summary = "The max number of blocks to load and prune trie logs for at startup. (default: 5000)"

[config."besu-regtest.conf".ivars."cache_last_blocks"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the number of last blocks to cache (default: 0)"

[config."besu-regtest.conf".ivars."compatibility_eth64_forkid_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable the legacy Eth/64 fork id. (default: false)"

[config."besu-regtest.conf".ivars."config_file"]
type = "string"
default = ""
priority = "low"
summary = "TOML config file (default: none)"

# [config."besu-regtest.conf".ivars."data_path"]
# type = "string"
# default = ""
# priority = "low"
# summary = "The path to Besu data directory (default: /usr/lib/eth-node-besu/besu)"

[config."besu-regtest.conf".ivars."data_storage_format"]
type = "string"
default = ""
priority = "low"
summary = "Format to store trie data in. Either FOREST or BONSAI (default: BONSAI)"

[config."besu-regtest.conf".ivars."ethstats"]
type = "string"
default = ""
priority = "low"
summary = "Reporting URL of a ethstats server. Scheme and port can be omitted."

[config."besu-regtest.conf".ivars."ethstats_cacert_file"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the path to the root CA certificate file that has signed ethstats server certificate. This option is optional."

[config."besu-regtest.conf".ivars."ethstats_contact"]
type = "string"
default = ""
priority = "low"
summary = "Contact address to send to ethstats server."

# [config."besu-regtest.conf".ivars."genesis_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Genesis file for your custom network. Requires --network-id to be set. Cannot be used with --network."

[config."besu-regtest.conf".ivars."genesis_state_hash_cache_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Use genesis state hash from data on startup if specified (default: false)"

# [config."besu-regtest.conf".ivars."host_allowlist"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma separated list of hostnames to allow for RPC access, or * to accept any host (default: localhost,127.0.0.1)"

[config."besu-regtest.conf".ivars."identity"]
type = "string"
default = ""
priority = "low"
summary = "Identification for this node in the Client ID."

[config."besu-regtest.conf".ivars."key_value_storage"]
type = "string"
default = ""
priority = "low"
summary = "Identity for the key-value storage to be used."

[config."besu-regtest.conf".ivars."kzg_trusted_setup"]
type = "string"
default = ""
priority = "low"
summary = "Path to file containing the KZG trusted setup, mandatory for custom networks that support data blobs."

[config."besu-regtest.conf".ivars."logging"]
type = "string"
default = ""
priority = "low"
summary = "Logging verbosity levels: OFF, ERROR, WARN, INFO, DEBUG, TRACE, ALL."

[config."besu-regtest.conf".ivars."nat_method"]
type = "string"
default = ""
priority = "low"
summary = "Specify the NAT circumvention method to be used, possible values are UPNP, UPNPP2PONLY, DOCKER, KUBERNETES, AUTO, NONE. (default: AUTO)"


# [config."besu-regtest.conf".ivars."network"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Synchronize against the indicated network. Possible values are MAINNET, SEPOLIA, HOLESKY, LUKSO, DEV, etc. (default: MAINNET)"

# [config."besu-regtest.conf".ivars."network_id"]
# type = "string"
# default = ""
# priority = "low"
# summary = "P2P network identifier. (default: the selected network chain ID or custom genesis chain ID)"

[config."besu-regtest.conf".ivars."node_private_key_file"]
type = "string"
default = ""
priority = "low"
summary = "The node's private key file (default: a file named 'key' in the Besu data directory)"

[config."besu-regtest.conf".ivars."pid_path"]
type = "string"
default = ""
priority = "low"
summary = "Path to PID file (optional)."

[config."besu-regtest.conf".ivars."profile"]
type = "string"
default = ""
priority = "low"
summary = "Overwrite default settings. Possible values are dev, enterprise, minimalist_staker, private, staker."

[config."besu-regtest.conf".ivars."receipt_compaction_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enables compact storing of receipts (default: true)."

[config."besu-regtest.conf".ivars."reorg_logging_threshold"]
type = "string"
default = ""
priority = "low"
summary = "How deep a chain reorganization must be in order for it to be logged (default: 6)."

[config."besu-regtest.conf".ivars."required_block"]
type = "string"
default = ""
priority = "low"
summary = "Block number and hash peers are required to have."

[config."besu-regtest.conf".ivars."revert_reason_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable passing the revert reason back through TransactionReceipts (default: false)."

[config."besu-regtest.conf".ivars."security_module"]
type = "string"
default = ""
priority = "low"
summary = "Identity for the Security Module to be used."

[config."besu-regtest.conf".ivars."static_nodes_file"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the static node file containing the static nodes for this node to connect to."

[config."besu-regtest.conf".ivars."sync_min_peers"]
type = "string"
default = ""
priority = "low"
summary = "Minimum number of peers required before starting sync (default: 5)."

# [config."besu-regtest.conf".ivars."sync_mode"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Synchronization mode. Possible values are FULL, FAST, SNAP, CHECKPOINT (default: SNAP)."

[config."besu-regtest.conf".ivars."version_compatibility_protection"]
type = "string"
default = "false"
priority = "low"
summary = "Perform compatibility checks between the version of Besu being started and the version of Besu that last started with this data directory."

# Tx Pool Layered Implementation Options
[config."besu-regtest.conf".ivars."tx_pool_layer_max_capacity"]
type = "string"
default = ""
priority = "low"
summary = "Max amount of memory space, in bytes, that any layer within the transaction pool could occupy (default: 12500000)."

[config."besu-regtest.conf".ivars."tx_pool_max_future_by_sender"]
type = "string"
default = ""
priority = "low"
summary = "Max number of future pending transactions allowed for a single sender (default: 200)."

[config."besu-regtest.conf".ivars."tx_pool_max_prioritized"]
type = "string"
default = ""
priority = "low"
summary = "Max number of pending transactions that are prioritized and kept sorted (default: 2000)."

[config."besu-regtest.conf".ivars."tx_pool_max_prioritized_by_type"]
type = "string"
default = ""
priority = "low"
summary = "Max number of pending transactions of a specific type that are prioritized and kept sorted (default: BLOB=6)."

[config."besu-regtest.conf".ivars."tx_pool_min_score"]
type = "string"
default = ""
priority = "low"
summary = "Remove a pending transaction from the txpool if its score is lower than this value (default: -128)."

# Tx Pool Sequenced Implementation Options
type = "string"
default = ""
priority = "low"
summary = "Maximum portion of the transaction pool a single account may occupy with future transactions (default: 0.001)."

[config."besu-regtest.conf".ivars."tx_pool_max_size"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of pending transactions that will be kept in the transaction pool (default: 4096)."

[config."besu-regtest.conf".ivars."tx_pool_retention_hours"]
type = "string"
default = ""
priority = "low"
summary = "Maximum retention period of pending transactions in hours (default: 13)."


# Tx Pool Common Options
[config."besu-regtest.conf".ivars."rpc_tx_feecap"]
type = "string"
default = ""
priority = "low"
summary = "Maximum transaction fees (in Wei) accepted for transactions submitted through RPC (default: 0xde0b6b3a7640000)."

[config."besu-regtest.conf".ivars."strict_tx_replay_protection_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Require transactions submitted via JSON-RPC to use replay protection in accordance with EIP-155 (default: false)."

[config."besu-regtest.conf".ivars."tx_pool"]
type = "string"
default = ""
priority = "low"
summary = "The Transaction Pool implementation to use (default: LAYERED)."

[config."besu-regtest.conf".ivars."tx_pool_blob_price_bump"]
type = "string"
default = ""
priority = "low"
summary = "Blob price bump percentage to replace an already existing transaction blob tx (default: 100%)."

[config."besu-regtest.conf".ivars."tx_pool_disable_locals"]
type = "string"
default = ""
priority = "low"
summary = "Set to true if senders of transactions sent via RPC should not have priority (default: false)."

[config."besu-regtest.conf".ivars."tx_pool_enable_save_restore"]
type = "string"
default = ""
priority = "low"
summary = "Set to true to enable saving the txpool content to a file on shutdown and reloading it on startup (default: false)."

[config."besu-regtest.conf".ivars."tx_pool_min_gas_price"]
type = "string"
default = ""
priority = "low"
summary = "Transactions with gas price (in Wei) lower than this minimum will not be accepted into the txpool (default: 0x3e8)."

[config."besu-regtest.conf".ivars."tx_pool_price_bump"]
type = "string"
default = ""
priority = "low"
summary = "Price bump percentage to replace an already existing transaction (default: 10%)."

[config."besu-regtest.conf".ivars."tx_pool_priority_senders"]
type = "string"
default = ""
priority = "low"
summary = "Pending transactions sent by these addresses are prioritized and only evicted after all others (default: [])."

[config."besu-regtest.conf".ivars."tx_pool_save_file"]
type = "string"
default = ""
priority = "low"
summary = "Define a custom path for the txpool save file (default: txpool.dump in the data-dir)."


# Block Builder Options
[config."besu-regtest.conf".ivars."block_txs_selection_max_time"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the maximum time (in milliseconds) that could be spent selecting transactions to be included in the block (default: 5000)."

[config."besu-regtest.conf".ivars."min_block_occupancy_ratio"]
type = "string"
default = ""
priority = "low"
summary = "Minimum occupancy ratio for a mined block (default: 0.8)."

[config."besu-regtest.conf".ivars."min_gas_price"]
type = "string"
default = ""
priority = "low"
summary = "Minimum price (in Wei) offered by a transaction for it to be included in a mined block (default: 0x3e8)."

[config."besu-regtest.conf".ivars."min_priority_fee"]
type = "string"
default = ""
priority = "low"
summary = "Minimum priority fee per gas (in Wei) offered by a transaction for it to be included in a block (default: 0)."

[config."besu-regtest.conf".ivars."miner_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Set if the node will perform mining (default: false)."

[config."besu-regtest.conf".ivars."miner_coinbase"]
type = "string"
default = ""
priority = "low"
summary = "Account to which mining rewards are paid. Must specify a valid coinbase if mining is enabled."

[config."besu-regtest.conf".ivars."miner_extra_data"]
type = "string"
default = ""
priority = "low"
summary = "A hex string representing the (32) bytes to be included in the extra data field of a mined block (default: 0x)."

[config."besu-regtest.conf".ivars."miner_stratum_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Set if node will perform Stratum mining (default: false). Compatible with Proof of Work (PoW) only."

[config."besu-regtest.conf".ivars."miner_stratum_host"]
type = "string"
default = ""
priority = "low"
summary = "Host for Stratum network mining service (default: 0.0.0.0)."

[config."besu-regtest.conf".ivars."miner_stratum_port"]
type = "string"
default = ""
priority = "low"
summary = "Stratum port binding (default: 8008)."

[config."besu-regtest.conf".ivars."poa_block_txs_selection_max_time"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the maximum time that could be spent selecting transactions to be included in the block, for PoA networks (default: 75%)."

[config."besu-regtest.conf".ivars."target_gas_limit"]
type = "string"
default = ""
priority = "low"
summary = "Sets target gas limit per block. If set, each block's gas limit will approach this setting over time."


# P2P Discovery Options

[config."besu-regtest.conf".ivars."banned_node_ids"]
type = "string"
default = ""
priority = "low"
summary = "A list of node IDs to ban from the P2P network."

# [config."besu-regtest.conf".ivars."bootnodes"]
# type = "string"
# default = ""
# priority = "low"
# summary =  "Comma separated enode URLs for P2P discovery bootstrap."

[config."besu-regtest.conf".ivars."discovery_dns_url"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the URL to use for DNS discovery."

[config."besu-regtest.conf".ivars."discovery_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable P2P discovery (default: true)."

[config."besu-regtest.conf".ivars."max_peers"]
type = "string"
default = ""
priority = "low"
summary = "Maximum P2P connections that can be established (default: 25)."

[config."besu-regtest.conf".ivars."net_restrict"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of allowed IP subnets (e.g., '192.168.1.0/24,10.0.0.0/8')."


# [config."besu-regtest.conf".ivars."p2p_enabled"]
# type = "string"
# default = "false"
# priority = "low"
# summary = "Enable P2P functionality (default: true)."

[config."besu-regtest.conf".ivars."p2p_host"]
type = "string"
default = ""
priority = "low"
summary = "IP address this node advertises to its peers (default: 127.0.0.1)."

[config."besu-regtest.conf".ivars."p2p_interface"]
type = "string"
default = ""
priority = "low"
summary = "The network interface address on which this node listens for P2P communication (default: 0.0.0.0)."

[config."besu-regtest.conf".ivars."p2p_port"]
type = "string"
default = ""
priority = "low"
summary = "Port on which to listen for P2P communication (default: 30303)."

[config."besu-regtest.conf".ivars."poa_discovery_retry_bootnodes"]
type = "string"
default = ""
priority = "low"
summary = "Always use bootnodes for discovery in PoA networks (default: true)."

[config."besu-regtest.conf".ivars."random_peer_priority_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Allow incoming connections to be prioritized randomly (default: false)."

[config."besu-regtest.conf".ivars."remote_connections_limit_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Whether to limit the number of P2P connections initiated remotely (default: true)."

[config."besu-regtest.conf".ivars."remote_connections_max_percentage"]
type = "string"
default = ""
priority = "low"
summary = "Maximum percentage of P2P connections that can be initiated remotely (default: 60%)."

# GraphQL Options
[config."besu-regtest.conf".ivars."graphql_http_cors_origins"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated origin domain URLs for CORS validation."

[config."besu-regtest.conf".ivars."graphql_http_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Set to start the GraphQL HTTP service (default: false)."

[config."besu-regtest.conf".ivars."graphql_http_host"]
type = "string"
default = ""
priority = "low"
summary = "Host for GraphQL HTTP to listen on."

[config."besu-regtest.conf".ivars."graphql_http_port"]
type = "string"
default = ""
priority = "low"
summary = "Port for GraphQL HTTP to listen on (default: 8547)."


# Engine JSON-RPC Options
# [config."besu-regtest.conf".ivars."engine_host_allowlist"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma separated list of hostnames to allow for ENGINE API access (default: localhost,127.0.0.1)."


[config."besu-regtest.conf".ivars."engine_jwt_disabled"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."engine_jwt_secret"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Disable authentication for Engine APIs (default: false)."

# [config."besu-regtest.conf".ivars."engine_rpc_enabled"]
# type = "string"
# default = "false"
# priority = "low"
# summary = "Enable the engine API even in the absence of merge-specific configurations."


[config."besu-regtest.conf".ivars."engine_rpc_port"]
type = "string"
default = ""
priority = "low"
summary = "Port to provide consensus client APIs on (default: 8551)."

# JSON-RPC HTTP Options
[config."besu-regtest.conf".ivars."json_pretty_print_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable JSON pretty print format (default: false)."


# [config."besu-regtest.conf".ivars."rpc_http_api"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."rpc_http_api_method_no_auth"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of API methods to exclude from RPC authentication services, RPC HTTP authentication must be enabled."

[config."besu-regtest.conf".ivars."rpc_http_authentication_credentials_file"]
type = "string"
default = ""
priority = "low"
summary = "Storage file for JSON-RPC HTTP authentication credentials (default: null)."

[config."besu-regtest.conf".ivars."rpc_http_authentication_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Require authentication for the JSON-RPC HTTP service (default: false)."

[config."besu-regtest.conf".ivars."rpc_http_authentication_jwt_algorithm"]
type = "string"
default = ""
priority = "low"
summary = "Encryption algorithm used for HTTP JWT public key. Possible values are RS256, RS384, RS512, ES256, ES384, HS256, ES512 (default: RS256)."

[config."besu-regtest.conf".ivars."rpc_http_authentication_jwt_public_key_file"]
type = "string"
default = ""
priority = "low"
summary = "JWT public key file for JSON-RPC HTTP authentication."

# [config."besu-regtest.conf".ivars."rpc_http_cors_origins"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Comma separated origin domain URLs for CORS validation."

# [config."besu-regtest.conf".ivars."rpc_http_enabled"]
# type = "string"
# default = "false"
# priority = "low"
# summary = "Set to start the JSON-RPC HTTP service (default: false)."

[config."besu-regtest.conf".ivars."rpc_http_host"]
type = "string"
default = ""
priority = "low"
summary = "Host for JSON-RPC HTTP to listen on."

[config."besu-regtest.conf".ivars."rpc_http_max_active_connections"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of HTTP connections allowed for JSON-RPC (default: 80). Incoming connections will be rejected once the limit is reached."

[config."besu-regtest.conf".ivars."rpc_http_max_batch_size"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the maximum number of requests in a single RPC batch request via RPC. -1 specifies no limit (default: 1024)."

[config."besu-regtest.conf".ivars."rpc_http_max_request_content_length"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the maximum request content length (default: 5242880)."

# [config."besu-regtest.conf".ivars."rpc_http_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = "Port for JSON-RPC HTTP to listen on (default: 8545)."

[config."besu-regtest.conf".ivars."rpc_http_tls_ca_clients_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable to accept clients certificate signed by a valid CA for client authentication (default: false)."

[config."besu-regtest.conf".ivars."rpc_http_tls_cipher_suites"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of TLS cipher suites to support."

[config."besu-regtest.conf".ivars."rpc_http_tls_client_auth_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable TLS client authentication for the JSON-RPC HTTP service (default: false)."

[config."besu-regtest.conf".ivars."rpc_http_tls_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable TLS for the JSON-RPC HTTP service (default: false)."

[config."besu-regtest.conf".ivars."rpc_http_tls_keystore_file"]
type = "string"
default = ""
priority = "low"
summary = "Keystore (PKCS#12) containing key/certificate for the JSON-RPC HTTP service. Required if TLS is enabled."

[config."besu-regtest.conf".ivars."rpc_http_tls_keystore_password_file"]
type = "string"
default = ""
priority = "low"
summary = "File containing password to unlock keystore for the JSON-RPC HTTP service. Required if TLS is enabled."

[config."besu-regtest.conf".ivars."rpc_http_tls_known_clients_file"]
type = "string"
default = ""
priority = "low"
summary = "Path to file containing clients certificate common name and fingerprint for client authentication."

[config."besu-regtest.conf".ivars."rpc_http_tls_protocols"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of TLS protocols to support (default: [TLSv1.3, TLSv1.2])."

# JSON-RPC Websocket Options
[config."besu-regtest.conf".ivars."rpc_ws_api"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of APIs to enable on JSON-RPC WebSocket service (default: [ETH, NET, WEB3])."

[config."besu-regtest.conf".ivars."rpc_ws_api_method_no_auth"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of API methods to exclude from RPC authentication services, RPC WebSocket authentication must be enabled."

[config."besu-regtest.conf".ivars."rpc_ws_authentication_credentials_file"]
type = "string"
default = ""
priority = "low"
summary = "Storage file for JSON-RPC WebSocket authentication credentials (default: null)."

[config."besu-regtest.conf".ivars."rpc_ws_authentication_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Require authentication for the JSON-RPC WebSocket service (default: false)."

[config."besu-regtest.conf".ivars."rpc_ws_authentication_jwt_algorithm"]
type = "string"
default = ""
priority = "low"
summary = "Encryption algorithm used for WebSockets JWT public key. Possible values are RS256, RS384, RS512, ES256, ES384, HS256, ES512 (default: RS256)."

[config."besu-regtest.conf".ivars."rpc_ws_authentication_jwt_public_key_file"]
type = "string"
default = ""
priority = "low"
summary = "JWT public key file for JSON-RPC WebSocket authentication."

[config."besu-regtest.conf".ivars."rpc_ws_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Set to start the JSON-RPC WebSocket service (default: false)."

[config."besu-regtest.conf".ivars."rpc_ws_host"]
type = "string"
default = ""
priority = "low"
summary = "Host for JSON-RPC WebSocket service to listen on."

[config."besu-regtest.conf".ivars."rpc_ws_max_active_connections"]
type = "string"
default = ""
priority = "low"
summary = "Maximum number of WebSocket connections allowed for JSON-RPC (default: 80). Incoming connections will be rejected once the limit is reached."

[config."besu-regtest.conf".ivars."rpc_ws_max_frame_size"]
type = "string"
default = ""
priority = "low"
summary = "Maximum size in bytes for JSON-RPC WebSocket frames (default: 1048576). If this limit is exceeded, the websocket will be disconnected."

[config."besu-regtest.conf".ivars."rpc_ws_port"]
type = "string"
default = ""
priority = "low"
summary = "Port for JSON-RPC WebSocket service to listen on (default: 8546)."

# In-Process RPC Options
# Privacy Options
[config."besu-regtest.conf".ivars."privacy_enable_database_migration"]
type = "string"
default = "false"
priority = "low"
summary = "Enable private database metadata migration (default: false)."

[config."besu-regtest.conf".ivars."privacy_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable private transactions (default: false)."

[config."besu-regtest.conf".ivars."privacy_flexible_groups_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable flexible privacy groups (default: false)."

[config."besu-regtest.conf".ivars."privacy_marker_transaction_signing_key_file"]
type = "string"
default = ""
priority = "low"
summary = "The name of a file containing the private key used to sign privacy marker transactions. If unset, each transaction will be signed with a random key."

[config."besu-regtest.conf".ivars."privacy_multi_tenancy_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable multi-tenant private transactions (default: false)."

[config."besu-regtest.conf".ivars."privacy_public_key_file"]
type = "string"
default = ""
priority = "low"
summary = "The enclave's public key file."

[config."besu-regtest.conf".ivars."privacy_tls_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable TLS for connecting to the privacy enclave (default: false)."

[config."besu-regtest.conf".ivars."privacy_tls_keystore_file"]
type = "string"
default = ""
priority = "low"
summary = "Path to a PKCS#12 formatted keystore, used to enable TLS on inbound connections."

[config."besu-regtest.conf".ivars."privacy_tls_keystore_password_file"]
type = "string"
default = ""
priority = "low"
summary = "Path to a file containing the password used to decrypt the keystore."

[config."besu-regtest.conf".ivars."privacy_tls_known_enclave_file"]
type = "string"
default = ""
priority = "low"
summary = "Path to a file containing the fingerprints of the authorized privacy enclave."

[config."besu-regtest.conf".ivars."privacy_url"]
type = "string"
default = ""
priority = "low"
summary = "The URL on which the enclave is running."

# Metrics Options
[config."besu-regtest.conf".ivars."metrics_category"]
type = "string"
default = ""
priority = "low"
summary = "Comma separated list of categories to track metrics for (default: [BLOCKCHAIN, ETHEREUM, EXECUTORS, NETWORK, PEERS, etc.])."

[config."besu-regtest.conf".ivars."metrics_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Set to start the metrics exporter (default: false)."

[config."besu-regtest.conf".ivars."metrics_host"]
type = "string"
default = ""
priority = "low"
summary = "Host for the metrics exporter to listen on."

[config."besu-regtest.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = "Port for the metrics exporter to listen on (default: 9545)."

[config."besu-regtest.conf".ivars."metrics_protocol"]
type = "string"
default = ""
priority = "low"
summary = "Metrics protocol, one of PROMETHEUS, OPENTELEMETRY, or NONE (default: PROMETHEUS)."

[config."besu-regtest.conf".ivars."metrics_push_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable the metrics push gateway integration (default: false)."

[config."besu-regtest.conf".ivars."metrics_push_host"]
type = "string"
default = ""
priority = "low"
summary = "Host of the Prometheus Push Gateway for push mode."

[config."besu-regtest.conf".ivars."metrics_push_interval"]
type = "string"
default = ""
priority = "low"
summary = "Interval in seconds to push metrics when in push mode (default: 15)."

[config."besu-regtest.conf".ivars."metrics_push_port"]
type = "string"
default = ""
priority = "low"
summary = "Port of the Prometheus Push Gateway for push mode."

[config."besu-regtest.conf".ivars."metrics_push_prometheus_job"]
type = "string"
default = ""
priority = "low"
summary = "Job name to use when in push mode (default: besu-client)."

# Permissions Options
[config."besu-regtest.conf".ivars."permissions_accounts_config_file"]
type = "string"
default = ""
priority = "low"
summary = "Account permissioning config TOML file (default: a file named 'permissions_config.toml' in the Besu data folder)."

[config."besu-regtest.conf".ivars."permissions_accounts_config_file_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable account level permissions (default: false)."

[config."besu-regtest.conf".ivars."permissions_accounts_contract_address"]
type = "string"
default = ""
priority = "low"
summary = "Address of the account permissioning smart contract."

[config."besu-regtest.conf".ivars."permissions_accounts_contract_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable account level permissions via smart contract (default: false)."

[config."besu-regtest.conf".ivars."permissions_nodes_config_file"]
type = "string"
default = ""
priority = "low"
summary = "Node permissioning config TOML file (default: a file named 'permissions_config.toml' in the Besu data folder)."

[config."besu-regtest.conf".ivars."permissions_nodes_config_file_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable node level permissions (default: false)."

[config."besu-regtest.conf".ivars."permissions_nodes_contract_address"]
type = "string"
default = ""
priority = "low"
summary = "Address of the node permissioning smart contract."

[config."besu-regtest.conf".ivars."permissions_nodes_contract_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable node level permissions via smart contract (default: false)."

[config."besu-regtest.conf".ivars."permissions_nodes_contract_version"]
type = "string"
default = ""
priority = "low"
summary = "Version of the EEA Node Permissioning interface (default: 1)."

# API Configuration Options
[config."besu-regtest.conf".ivars."api_gas_price_blocks"]
type = "string"
default = ""
priority = "low"
summary = "Number of blocks to consider for eth_gasPrice (default: 100)."

[config."besu-regtest.conf".ivars."api_gas_price_max"]
type = "string"
default = ""
priority = "low"
summary = "Maximum gas price for eth_gasPrice (default: 500000000000)."

[config."besu-regtest.conf".ivars."api_gas_price_percentile"]
type = "string"
default = ""
priority = "low"
summary = "Percentile value to measure for eth_gasPrice (default: 50.0)."

[config."besu-regtest.conf".ivars."rpc_gas_cap"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the gasLimit cap for transaction simulation RPC methods. Must be >=0 (default: 0)."

[config."besu-regtest.conf".ivars."rpc_max_logs_range"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the maximum number of blocks to retrieve logs from via RPC (default: 5000)."

[config."besu-regtest.conf".ivars."rpc_max_trace_filter_range"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the maximum number of blocks for the trace_filter method (default: 1000)."
