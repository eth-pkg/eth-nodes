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
    "debian/tmp/eth-node-besu-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-besu-regtest",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config", "eth-node-regtest"]
summary = "service file for eth-node-besu for network: regtest"

[config."besu-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-besu-regtest/postprocess.sh"]

[config."besu-regtest.conf"]
format = "plain"

# TESTNET OPTIONS 
### USED OPTIONS 

[config."besu-regtest.conf".ivars."data_path"]
type = "string"
default = "/var/lib/eth-node-regtest/besu"
priority = "low"
summary = "Path to Besu data directory (default: /var/lib/eth-node-regtest/besu)"

[config."besu-regtest.conf".ivars."engine_jwt_secret"]
type = "string"
default = "/etc/eth-node-regtest/jwt.hex"
priority = "low"
summary = "Path to file containing shared secret key for JWT signature verification"

[config."besu-regtest.conf".ivars."network"]
type = "string"
default = ""
priority = "low"
summary = "Synchronize against the indicated network: MAINNET, SEPOLIA, GOERLI, HOLESKY, DEV, FUTURE_EIPS, EXPERIMENTAL_EIPS, CLASSIC, MORDOR. (default: MAINNET) leave it empty for custom network"

[config."besu-regtest.conf".ivars."bootnodes"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENODE"
priority = "low"
summary = "P2P network identifier. (default: the selected network chain ID or custom genesis chain ID)"

[config."besu-regtest.conf".ivars."network_id"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_NETWORK_ID"
priority = "low"
summary = "P2P network identifier. (default: the selected network chain ID or custom genesis chain ID)"


[config."besu-regtest.conf".ivars."engine_rpc_enabled"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the engine API, even in the absence of merge-specific configurations (default: false)"

[config."besu-regtest.conf".ivars."sync_mode"]
type = "string"
default = "full"
priority = "low"
summary = "Synchronization mode, possible values are FULL, FAST, SNAP, CHECKPOINT, X_SNAP, X_CHECKPOINT (default: SNAP if a --network is supplied and privacy isn't enabled. FULL otherwise.)"

[config."besu-regtest.conf".ivars."genesis_file"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_TESTNET_DIR/besu.json"
priority = "low"
summary = "Path to genesis file for your custom network"

[config."besu-regtest.conf".ivars."bonsai_limit_trie_logs_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "--bonsai-limit-trie-logs-enabled"

[config."besu-regtest.conf".ivars."p2p_enabled"]
type = "string"
default = "false"
priority = "low"
summary = "Enable P2P functionality (default: true). Only running one EL client on regtest."

[config."besu-regtest.conf".ivars."rpc_http_api"]
type = "string"
default = "ADMIN,CLIQUE,ETH,NET,DEBUG,TXPOOL,ENGINE,TRACE,WEB3"
priority = "low"
summary = "Set RPC HTTP API to ETH"

[config."besu-regtest.conf".ivars."rpc_http_enabled"]
type = "string"
default = "true"
priority = "low"
summary = "Enable RPC HTTP functionality"

[config."besu-regtest.conf".ivars."rpc_http_port"]
type = "string"
default = "$BASE_CONFIG_EL_RPC_PORT"
priority = "low"
summary = "Set the RPC HTTP port"

[config."besu-regtest.conf".ivars."host_allowlist"]
type = "string"
default = "*"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_cors_origins"]
type = "string"
default = "*"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."engine_host_allowlist"]
type = "string"
default = "*"
priority = "low"
summary = ""

# All Default options, commented out the used one
### OPTIONS below are all set to default and provided to be used with debconf

[config."besu-regtest.conf".ivars."auto_log_bloom_caching_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."bonsai_historical_block_limit"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."bonsai_limit_trie_logs_enabled"]
# type = "string"
# default = "false"
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."bonsai_trie_logs_pruning_window_size"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."cache_last_blocks"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."compatibility_eth64_forkid_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."config_file"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."data_path"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."data_storage_format"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."ethstats"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."ethstats_cacert_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."ethstats_contact"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."genesis_file"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."genesis_state_hash_cache_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."host_allowlist"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."identity"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."key_value_storage"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."kzg_trusted_setup"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."logging"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."nat_method"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."network"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

# [config."besu-regtest.conf".ivars."network_id"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."node_private_key_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."pid_path"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."profile"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."reorg_logging_threshold"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."receipt_compaction_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."required_block"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."revert_reason_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."security_module"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."static_nodes_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."sync_min_peers"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."sync_mode"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."version_compatibility_protection"]
type = "string"
default = "false"
priority = "low"
summary = ""

# Tx Pool Layered Implementation Options
[config."besu-regtest.conf".ivars."tx_pool_layer_max_capacity"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_max_future_by_sender"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_max_prioritized"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_max_prioritized_by_type"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_min_score"]
type = "string"
default = ""
priority = "low"
summary = ""

# Tx Pool Sequenced Implementation Options
[config."besu-regtest.conf".ivars."tx_pool_limit_by_account_percentage"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_max_size"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_retention_hours"]
type = "string"
default = ""
priority = "low"
summary = ""

# Tx Pool Common Options
[config."besu-regtest.conf".ivars."rpc_tx_feecap"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."strict_tx_replay_protection_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_blob_price_bump"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_disable_locals"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_enable_save_restore"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_min_gas_price"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_price_bump"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_priority_senders"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."tx_pool_save_file"]
type = "string"
default = ""
priority = "low"
summary = ""

# Block Builder Options
[config."besu-regtest.conf".ivars."block_txs_selection_max_time"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."min_block_occupancy_ratio"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."min_gas_price"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."min_priority_fee"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."miner_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."miner_coinbase"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."miner_extra_data"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."miner_stratum_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."miner_stratum_host"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."miner_stratum_port"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."poa_block_txs_selection_max_time"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."target_gas_limit"]
type = "string"
default = ""
priority = "low"
summary = ""

# P2P Discovery Options
[config."besu-regtest.conf".ivars."banned_node_ids"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."bootnodes"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."discovery_dns_url"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."discovery_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."max_peers"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."net_restrict"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."p2p_enabled"]
# type = "string"
# default = "false"
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."p2p_host"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."p2p_interface"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."p2p_port"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."poa_discovery_retry_bootnodes"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."random_peer_priority_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."remote_connections_limit_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."remote_connections_max_percentage"]
type = "string"
default = ""
priority = "low"
summary = ""

# GraphQL Options
[config."besu-regtest.conf".ivars."graphql_http_cors_origins"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."graphql_http_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."graphql_http_host"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."graphql_http_port"]
type = "string"
default = ""
priority = "low"
summary = ""

# Engine JSON-RPC Options
# [config."besu-regtest.conf".ivars."engine_host_allowlist"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."engine_jwt_disabled"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."engine_jwt_secret"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

# [config."besu-regtest.conf".ivars."engine_rpc_enabled"]
# type = "string"
# default = "false"
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."engine_rpc_port"]
type = "string"
default = ""
priority = "low"
summary = ""

# JSON-RPC HTTP Options
[config."besu-regtest.conf".ivars."json_pretty_print_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."rpc_http_api"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."rpc_http_api_method_no_auth"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_authentication_credentials_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_authentication_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_authentication_jwt_algorithm"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_authentication_jwt_public_key_file"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."rpc_http_cors_origins"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

# [config."besu-regtest.conf".ivars."rpc_http_enabled"]
# type = "string"
# default = "false"
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."rpc_http_host"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_max_active_connections"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_max_batch_size"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_max_request_content_length"]
type = "string"
default = ""
priority = "low"
summary = ""

# [config."besu-regtest.conf".ivars."rpc_http_port"]
# type = "string"
# default = ""
# priority = "low"
# summary = ""

[config."besu-regtest.conf".ivars."rpc_http_tls_ca_clients_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_tls_cipher_suites"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_tls_client_auth_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_tls_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_tls_keystore_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_tls_keystore_password_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_tls_known_clients_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_http_tls_protocols"]
type = "string"
default = ""
priority = "low"
summary = ""

# JSON-RPC Websocket Options
[config."besu-regtest.conf".ivars."rpc_ws_api"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_api_method_no_auth"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_authentication_credentials_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_authentication_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_authentication_jwt_algorithm"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_authentication_jwt_public_key_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_host"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_max_active_connections"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_max_frame_size"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_ws_port"]
type = "string"
default = ""
priority = "low"
summary = ""

# In-Process RPC Options
# Privacy Options

[config."besu-regtest.conf".ivars."privacy_enable_database_migration"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_flexible_groups_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_marker_transaction_signing_key_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_multi_tenancy_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_public_key_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_tls_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_tls_keystore_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_tls_keystore_password_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_tls_known_enclave_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."privacy_url"]
type = "string"
default = ""
priority = "low"
summary = ""

# Metrics Options
[config."besu-regtest.conf".ivars."metrics_category"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_host"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_protocol"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_push_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_push_host"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_push_interval"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_push_port"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."metrics_push_prometheus_job"]
type = "string"
default = ""
priority = "low"
summary = ""

# Permissions Options
[config."besu-regtest.conf".ivars."permissions_accounts_config_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."permissions_accounts_config_file_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."permissions_accounts_contract_address"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."permissions_accounts_contract_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."permissions_nodes_config_file"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."permissions_nodes_config_file_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."permissions_nodes_contract_address"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."permissions_nodes_contract_enabled"]
type = "string"
default = "false"
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."permissions_nodes_contract_version"]
type = "string"
default = ""
priority = "low"
summary = ""

# API Configuration Options
[config."besu-regtest.conf".ivars."api_gas_price_blocks"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."api_gas_price_max"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."api_gas_price_percentile"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_gas_cap"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_max_logs_range"]
type = "string"
default = ""
priority = "low"
summary = ""

[config."besu-regtest.conf".ivars."rpc_max_trace_filter_range"]
type = "string"
default = ""
priority = "low"
summary = ""
