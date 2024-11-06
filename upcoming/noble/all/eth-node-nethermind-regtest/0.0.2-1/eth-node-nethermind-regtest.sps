name = "eth-node-nethermind-regtest"
bin_package = "eth-node-nethermind"
binary = "/usr/bin/nethermind"
conf_param = "--config="
user = { name = "eth-node-nethermind-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-nethermind-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/nethermind
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/nethermind
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/tmp/eth-node-nethermind-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-nethermind-regtest",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-nethermind for network: regtest"

[config."nethermind-regtest.cfg".postprocess]
command = ["bash", "/usr/lib/eth-node-nethermind-regtest/postprocess.sh"]

[config."nethermind-regtest.cfg"]
format = "json"




#### THIS IS A HACK, DO NOT MERGE

[config."nethermind-regtest.cfg".hvars."DATA_DIR"]
type = "string"
constant = "/var/lib/eth-node-regtest"
store = false

[config."nethermind-regtest.cfg".hvars."JWT_FILE"]
type = "path"
file_type = "regular"
constant = "/etc/eth-node-regtest/jwt.hex"
store = false

[config."nethermind-regtest.cfg".hvars."NETWORK_ID"]
type = "string"
constant = "1337"
store = false

[config."nethermind-regtest.cfg".hvars."TESTNET_DIR"]
type = "string"
constant = "/var/lib/eth-node-regtest/regtest/genesis"
store = false

[config."nethermind-regtest.cfg".hvars."EL_RPC_PORT"]
type = "string"
constant = "8545"
store = false

[config."nethermind-regtest.cfg".hvars."ENGINE_IP"]
type = "string"
constant = "127.0.0.1"
store = false

[config."nethermind-regtest.cfg".hvars."LOG_DIR"]
type = "string"
constant = "/var/logs/eth-node-regtest"
# priority = "low"
# ignore_empty = true
# summary = "Base dir for logging"
store = false

################

[config."nethermind-regtest.cfg".hvars."datadir"]
type = "string"
template = "{/DATA_DIR}/nethermind"
# priority = "low"
ignore_empty = true
# summary = "Data directory for Nethermind"

[config."nethermind-regtest.cfg".ivars."jsonrpc_enabled"]
type = "bool"
default = "true"
priority = "low"
ignore_empty = true
summary = "Whether to enable the JSON-RPC service."
structure = ["JsonRpc", "Enabled"]

[config."nethermind-regtest.cfg".ivars."jsonrpc_engine_enabled_modules"]
type = "string"
default = "net,eth,subscribe,web3"
priority = "low"
ignore_empty = true
summary = "An array of JSON-RPC namespaces to enable"
structure = ["JsonRpc", "EngineEnabledModules"]



[config."nethermind-regtest.cfg".ivars."jsonrpc_enabled_modules"]
type = "string"
default = "net,eth,consensus,subscribe,web3,admin"
priority = "low"
ignore_empty = true
summary = "An array of JSON-RPC namespaces to enable"
structure = ["JsonRpc", "EnabledModules"]


[config."nethermind-regtest.cfg".ivars."jsonrpc_host"]
type = "string"
default = "127.0.0.1"
priority = "low"
ignore_empty = true
summary = "The JSON-RPC service host"
structure = ["JsonRpc", "Host"]


[config."nethermind-regtest.cfg".ivars."jsonrpc_engine_host"]
type = "string"
default = "127.0.0.1"
priority = "low"
ignore_empty = true
summary = "The Engine API host"
structure = ["JsonRpc", "EngineHost"]


[config."nethermind-regtest.cfg".ivars."jsonrpc_engine_port"]
type = "string"
default = "8551"
priority = "low"
ignore_empty = true
summary = "The Engine API port"
structure = ["JsonRpc", "EngingPort"]


[config."nethermind-regtest.cfg".hvars."jsonrpc_jwt_secret_file"]
type = "string"
template = "{/JWT_FILE}"
# priority = "low"
ignore_empty = true
# summary = "Path to JWT secret file for Engine API authentication"
structure = ["JsonRpc", "JwtSecretFile"]


# [config."nethermind-regtest.cfg".ivars."config"]
# type = "string"
# default = "none.cfg"
# priority = "low"
# ignore_empty = true
# summary = "Config file path"

[config."nethermind-regtest.cfg".hvars."init_chain_spec_path"]
type = "string"
template = "{/TESTNET_DIR}/chainspec.json"
# priority = "low"
# ignore_empty = true
# summary = "Path to the chain spec file"
structure = ["Init", "ChainSpecPath"]


[config."nethermind-regtest.cfg".ivars."network_max_active_peers"]
type = "string"
default = "0"
priority = "low"
ignore_empty = true
summary = "Max allowed number of connected peers."
structure = ["Network", "MaxActivePeers"]


[config."nethermind-regtest.cfg".hvars."init_log_directory"]
type = "string"
template = "{/LOG_DIR}/nethermind"
# priority = "low"
# ignore_empty = true
# summary = "Path to the Nethermind logs directory."
structure = ["Init", "LogDirectory"]


[config."nethermind-regtest.cfg".ivars."init_log_file_name"]
type = "string"
default = "nethermind.log"
priority = "low"
ignore_empty = true
summary = "Name of the log file."
structure = ["Init", "LogFileName"]


# All Default options, commented out the used one
### OPTIONS below are all set to default and provided to be used with debconf

# [config."nethermind-regtest.cfg".ivars."datadir"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Data directory"

# [config."nethermind-regtest.cfg".ivars."config"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Config file path"

[config."nethermind-regtest.cfg".ivars."base_db_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Base db path"

[config."nethermind-regtest.cfg".ivars."log_level"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Log level override. Possible values: OFF|TRACE|DEBUG|INFO|WARN|ERROR"

[config."nethermind-regtest.cfg".ivars."configs_directory"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Configs directory"

[config."nethermind-regtest.cfg".ivars."logger_config_source"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the NLog config file"

[config."nethermind-regtest.cfg".ivars."plugins_directory"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Plugins directory"

[config."nethermind-regtest.cfg".ivars."aura_allow_aura_private_chains"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to allow private Aura-based chains only. Do not use with existing Aura-based chains."

[config."nethermind-regtest.cfg".ivars."aura_force_sealing"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to seal empty blocks if mining."

[config."nethermind-regtest.cfg".ivars."aura_minimum_2mln_gas_per_block_when_using_block_gas_limit_contract"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to use 2M gas if the contract returns less than that when using BlockGasLimitContractTransitions."

[config."nethermind-regtest.cfg".ivars."aura_tx_priority_config_file_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The path to the transaction priority rules file to use when selecting transactions from the transaction pool."

[config."nethermind-regtest.cfg".ivars."aura_tx_priority_contract_address"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The address of the transaction priority contract to use when selecting transactions from the transaction pool."

[config."nethermind-regtest.cfg".ivars."blocks_block_production_timeout_ms"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block Production timeout, in milliseconds."

[config."nethermind-regtest.cfg".ivars."blocks_extra_data"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The block header extra data up to 32 bytes in length."

[config."nethermind-regtest.cfg".ivars."blocks_genesis_timeout_ms"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Genesis block load timeout, in milliseconds."

[config."nethermind-regtest.cfg".ivars."blocks_min_gas_price"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The minimum gas premium (or the gas price before the London hard fork) for transactions accepted by the block producer."

[config."nethermind-regtest.cfg".ivars."blocks_pre_warm_state_on_block_processing"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to pre-warm the state when processing blocks."

[config."nethermind-regtest.cfg".ivars."blocks_randomized_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to change the difficulty of the block randomly within the constraints. Used in NethDev only."

[config."nethermind-regtest.cfg".ivars."blocks_seconds_per_slot"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The block time slot, in seconds."

[config."nethermind-regtest.cfg".ivars."blocks_target_block_gas_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The block gas limit that the block producer should try to reach in the fastest possible way based on the protocol rules."

[config."nethermind-regtest.cfg".ivars."bloom_index"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to use the Bloom index. The Bloom index speeds up the RPC log searches."

[config."nethermind-regtest.cfg".ivars."bloom_index_level_bucket_sizes"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "An array of multipliers for index levels. Can be tweaked per chain to boost performance."

[config."nethermind-regtest.cfg".ivars."bloom_migration"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to migrate the previously downloaded blocks to the Bloom index."

[config."nethermind-regtest.cfg".ivars."bloom_migration_statistics"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether the migration statistics should be calculated and output."

[config."nethermind-regtest.cfg".ivars."censorship_detector_addresses_for_censorship_detection"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The addresses for which censorship is being detected."

[config."nethermind-regtest.cfg".ivars."censorship_detector_block_censorship_threshold"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of consecutive blocks with detected potential censorship to report censorship attempt."

[config."nethermind-regtest.cfg".ivars."censorship_detector_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enabling censorship detection feature."


[config."nethermind-regtest.cfg".ivars."db_block_infos_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for block info storage."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for block info storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for block info storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for block info in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for block info storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for block info storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for block info storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in block info storage."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for block info storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of write buffers for block info storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_infos_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for block info storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for block number storage."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_max_bytes_for_level_base"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes for level base in block number storage RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_row_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Row cache size for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in block number storage."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_use_hash_index"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use hash index for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_use_hash_skip_list_memtable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use hash skip list memtable for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_numbers_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for block number storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_restart_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block restart interval in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size in RocksDb."


[config."nethermind-regtest.cfg".ivars."db_blocks_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Blocks block size in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for blocks database."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for blocks database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for blocks database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for blocks database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for blocks database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for blocks database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in blocks database."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for blocks database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for blocks database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_blocks_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for blocks database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_bloom_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for Bloom database."

[config."nethermind-regtest.cfg".ivars."db_bloom_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for Bloom database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_bloom_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for Bloom database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_bloom_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for Bloom database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_bloom_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for Bloom database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_bloom_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for Bloom database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_bloom_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for Bloom database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_bloom_filter_bits_per_key"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of bits per key in Bloom filter."

[config."nethermind-regtest.cfg".ivars."db_bytes_per_sync"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of bytes between sync operations in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for code storage in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for code database."

[config."nethermind-regtest.cfg".ivars."db_code_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_row_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Row cache size for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_use_hash_index"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use hash index for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_use_hash_skip_list_memtable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use hash skip list memtable for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_code_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in code database."

[config."nethermind-regtest.cfg".ivars."db_code_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for code database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for RocksDb."

[config."nethermind-regtest.cfg".ivars."db_compressibility_hint"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Hint for compressibility of data in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_data_block_index_util_ratio"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Data block index utilization ratio for RocksDb."

[config."nethermind-regtest.cfg".ivars."db_disable_compression"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable compression in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_enable_db_statistics"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable database statistics in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_enable_file_warmer"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable file warmer for RocksDb."

[config."nethermind-regtest.cfg".ivars."db_enable_metrics_updater"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable metrics updater for RocksDb."


[config."nethermind-regtest.cfg".ivars."db_headers_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for headers database."

[config."nethermind-regtest.cfg".ivars."db_headers_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_max_bytes_for_level_base"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes for level base in headers database RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in headers database."

[config."nethermind-regtest.cfg".ivars."db_headers_db_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_headers_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for headers database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_level_compaction_dynamic_level_bytes"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable dynamic level bytes for level compaction in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_max_bytes_for_level_base"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes for level base in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_max_bytes_for_level_multiplier"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes multiplier for level in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_max_compaction_bytes"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max compaction bytes in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_max_write_buffer_size_to_maintain"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max write buffer size to maintain in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_memtable_prefix_bloom_size_ratio"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Memtable prefix bloom size ratio in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for metadata in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for metadata database."

[config."nethermind-regtest.cfg".ivars."db_metadata_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for metadata database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for metadata database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for metadata database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for metadata database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for metadata database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for metadata database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for metadata database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_metadata_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in metadata database."

[config."nethermind-regtest.cfg".ivars."db_metadata_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for metadata database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_min_write_buffer_number_to_merge"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Min write buffer number to merge in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_only_compress_last_level"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Only compress the last level in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_optimize_filters_for_hits"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Optimize filters for hits in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for pending transactions database."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in pending transactions database."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_pending_txs_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for pending transactions database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_prefix_extractor_length"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prefix extractor length in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_read_ahead_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Read ahead size in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for receipts database."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_compressibility_hint"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compressibility hint for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_target_file_size_base"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Target file size base for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in receipts database."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_receipts_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for receipts database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_recycle_log_file_num"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of recycled log files in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_row_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Row cache size in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_shared_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Shared block cache size in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_skip_memory_hint_setting"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Skip memory hint setting in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_additional_rocks_db_options"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional RocksDb options for state database."

[config."nethermind-regtest.cfg".ivars."db_state_db_advise_random_on_open"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Advise random I/O on open for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_allow_mmap_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Allow memory-mapped file reads for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_block_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block cache size for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_block_restart_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block restart interval for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_bloom_filter_bits_per_key"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Bloom filter bits per key for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_cache_index_and_filter_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cache index and filter blocks for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_compaction_read_ahead"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compaction read-ahead for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_compressibility_hint"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compressibility hint for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_data_block_index_util_ratio"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Data block index utilization ratio for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_disable_compression"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable compression for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_enable_file_warmer"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable file warmer for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_max_bytes_for_level_base"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes for level base in state database RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_max_bytes_for_level_multiplier"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes multiplier for level in state database RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_max_bytes_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max bytes per second for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_max_compaction_bytes"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max compaction bytes for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_max_open_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max open files for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_max_write_buffer_size_to_maintain"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max write buffer size to maintain for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_memtable_prefix_bloom_size_ratio"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Memtable prefix bloom size ratio for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_min_write_buffer_number_to_merge"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Min write buffer number to merge for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_only_compress_last_level"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Only compress last level for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_optimize_filters_for_hits"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Optimize filters for hits for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_prefix_extractor_length"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prefix extractor length for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_row_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Row cache size for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_target_file_size_multiplier"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Target file size multiplier for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in state database."

[config."nethermind-regtest.cfg".ivars."db_state_db_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_use_hash_index"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use hash index for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_use_hash_skip_list_memtable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use hash skip list memtable for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_use_lz4"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use LZ4 compression for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_use_ribbon_filter_starting_from_level"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use ribbon filter starting from specific level for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_use_two_level_index"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use two-level index for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_verify_checksum"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Verify checksum for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer number for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_state_db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size for state database in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_stats_dump_period_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Stats dump period in seconds for RocksDb."

[config."nethermind-regtest.cfg".ivars."db_target_file_size_base"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Target file size base for RocksDb."

[config."nethermind-regtest.cfg".ivars."db_target_file_size_multiplier"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Target file size multiplier for RocksDb."

[config."nethermind-regtest.cfg".ivars."db_use_direct_io_for_flush_and_compactions"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct I/O for flush and compaction in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_use_direct_reads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use direct reads in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_use_hash_index"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use hash index in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_use_hash_skip_list_memtable"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use hash skip list memtable in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_use_lz4"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use LZ4 compression in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_use_ribbon_filter_starting_from_level"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use ribbon filter starting from a specific level in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_use_two_level_index"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use two-level index in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_verify_checksum"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Verify checksum in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_write_ahead_log_sync"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable write-ahead log sync in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_write_buffer_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of write buffers in RocksDb."

[config."nethermind-regtest.cfg".ivars."db_write_buffer_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write buffer size in RocksDb."

[config."nethermind-regtest.cfg".ivars."discovery_bootnode_pong_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Bootnode Pong timeout in milliseconds."

[config."nethermind-regtest.cfg".ivars."discovery_bootnodes"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "List of bootnodes."

[config."nethermind-regtest.cfg".ivars."discovery_bucket_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Discovery bucket size."

[config."nethermind-regtest.cfg".ivars."discovery_concurrency"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Discovery concurrency."

[config."nethermind-regtest.cfg".ivars."discovery_discovery_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Discovery interval in milliseconds."

[config."nethermind-regtest.cfg".ivars."discovery_discovery_new_cycle_wait_time"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Discovery new cycle wait time in milliseconds."

[config."nethermind-regtest.cfg".ivars."discovery_discovery_persistence_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Discovery persistence interval in milliseconds."

[config."nethermind-regtest.cfg".ivars."discovery_discovery_version"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Discovery version(s) to enable."

[config."nethermind-regtest.cfg".ivars."discovery_drop_full_bucket_node_probability"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Probability to drop full bucket node."

[config."nethermind-regtest.cfg".ivars."discovery_eviction_check_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Eviction check interval in milliseconds."

[config."nethermind-regtest.cfg".ivars."discovery_max_discovery_rounds"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max discovery rounds."

[config."nethermind-regtest.cfg".ivars."discovery_max_node_lifecycle_managers_count"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max node lifecycle managers count."

[config."nethermind-regtest.cfg".ivars."discovery_max_outgoing_message_per_second"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of outgoing discovery messages per second."

[config."nethermind-regtest.cfg".ivars."discovery_node_lifecycle_managers_cleanup_count"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Node lifecycle managers cleanup count."

[config."nethermind-regtest.cfg".ivars."discovery_ping_retry_count"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Ping retry count."

[config."nethermind-regtest.cfg".ivars."discovery_pong_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Pong timeout in milliseconds."

[config."nethermind-regtest.cfg".ivars."discovery_send_node_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Send node timeout in milliseconds."

[config."nethermind-regtest.cfg".ivars."discovery_udp_channel_close_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "UDP channel close timeout in milliseconds."

[config."nethermind-regtest.cfg".ivars."ethstats_contact"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Node owner contact details for Ethstats."

[config."nethermind-regtest.cfg".ivars."ethstats_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable Ethstats publishing."

[config."nethermind-regtest.cfg".ivars."ethstats_name"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Node name for Ethstats."

[config."nethermind-regtest.cfg".ivars."ethstats_secret"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Ethstats secret."

[config."nethermind-regtest.cfg".ivars."ethstats_send_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Stats update interval for Ethstats in seconds."

[config."nethermind-regtest.cfg".ivars."ethstats_server"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Ethstats server URL."

[config."nethermind-regtest.cfg".ivars."healthchecks_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable health checks."

[config."nethermind-regtest.cfg".ivars."healthchecks_low_storage_check_await_on_startup"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Check for low disk space on startup."

[config."nethermind-regtest.cfg".ivars."healthchecks_low_storage_space_shutdown_threshold"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disk space percentage threshold for shutdown."

[config."nethermind-regtest.cfg".ivars."healthchecks_low_storage_space_warning_threshold"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disk space percentage threshold for warning."

[config."nethermind-regtest.cfg".ivars."healthchecks_max_interval_cl_request_time"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max request interval for consensus client health."

[config."nethermind-regtest.cfg".ivars."healthchecks_max_interval_without_processed_block"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max interval without processing a block."

[config."nethermind-regtest.cfg".ivars."healthchecks_max_interval_without_produced_block"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max interval without producing a block."

[config."nethermind-regtest.cfg".ivars."healthchecks_polling_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Polling interval for health check updates in seconds."

[config."nethermind-regtest.cfg".ivars."healthchecks_slug"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Health checks service URL slug."

[config."nethermind-regtest.cfg".ivars."healthchecks_ui_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable the health checks UI."

[config."nethermind-regtest.cfg".ivars."healthchecks_webhooks_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable webhooks for health checks."

[config."nethermind-regtest.cfg".ivars."healthchecks_webhooks_payload"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "JSON payload for webhooks on failure."

[config."nethermind-regtest.cfg".ivars."healthchecks_webhooks_restore_payload"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "JSON payload for webhooks on recovery."

[config."nethermind-regtest.cfg".ivars."healthchecks_webhooks_uri"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Webhook URL for health checks."

[config."nethermind-regtest.cfg".ivars."hive_blocks_dir"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the directory with additional blocks for Hive."

[config."nethermind-regtest.cfg".ivars."hive_chain_file"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the test chain spec file for Hive."

[config."nethermind-regtest.cfg".ivars."hive_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable Hive for debugging."

[config."nethermind-regtest.cfg".ivars."hive_genesis_file_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the genesis block file for Hive."

[config."nethermind-regtest.cfg".ivars."hive_keys_dir"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the keystore directory for Hive."

[config."nethermind-regtest.cfg".ivars."init_auto_dump"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Auto-dump on bad blocks for diagnostics."

[config."nethermind-regtest.cfg".ivars."init_background_task_concurrency"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Concurrency limit for background tasks."

[config."nethermind-regtest.cfg".ivars."init_bad_blocks_stored"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of bad blocks observed on the network that will be stored."

[config."nethermind-regtest.cfg".ivars."init_base_db_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Base path for all Nethermind databases."

# [config."nethermind-regtest.cfg".ivars."init_chain_spec_path"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Path to the chain spec file."

[config."nethermind-regtest.cfg".ivars."init_diagnostic_mode"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The diagnostic mode."

[config."nethermind-regtest.cfg".ivars."init_disable_gc_on_new_payload"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable garbage collector on new payload."

[config."nethermind-regtest.cfg".ivars."init_disable_malloc_opts"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable setting malloc options."

[config."nethermind-regtest.cfg".ivars."init_discovery_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable the node discovery."

[config."nethermind-regtest.cfg".ivars."init_enable_unsecured_dev_wallet"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable the in-app wallet/keystore."

[config."nethermind-regtest.cfg".ivars."init_exit_on_block_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Exit when block number is reached."

[config."nethermind-regtest.cfg".ivars."init_genesis_hash"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The hash of the genesis block."

[config."nethermind-regtest.cfg".ivars."init_hive_chain_spec_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the chain spec file for Hive tests."

[config."nethermind-regtest.cfg".ivars."init_is_mining"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to seal/mine new blocks."

[config."nethermind-regtest.cfg".ivars."init_keep_dev_wallet_in_memory"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to create session-only accounts and delete them on shutdown."

[config."nethermind-regtest.cfg".ivars."init_kzg_setup_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to KZG trusted setup file."

# [config."nethermind-regtest.cfg".ivars."init_log_directory"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Path to the Nethermind logs directory."

# [config."nethermind-regtest.cfg".ivars."init_log_file_name"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Name of the log file."

[config."nethermind-regtest.cfg".ivars."init_log_rules"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Logs format rules."

[config."nethermind-regtest.cfg".ivars."init_memory_hint"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Memory hint for the max memory limit."

[config."nethermind-regtest.cfg".ivars."init_peer_manager_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to connect to newly discovered peers."

[config."nethermind-regtest.cfg".ivars."init_processing_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to download/process new blocks."

[config."nethermind-regtest.cfg".ivars."init_receipts_migration"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to migrate the receipts."

[config."nethermind-regtest.cfg".ivars."init_rpc_db_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "URL of the remote node used as a database source."

[config."nethermind-regtest.cfg".ivars."init_state_db_key_scheme"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Key scheme for state database."

[config."nethermind-regtest.cfg".ivars."init_static_nodes_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the static nodes file."

[config."nethermind-regtest.cfg".ivars."init_store_receipts"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to store receipts after a new block is processed."

[config."nethermind-regtest.cfg".ivars."init_websockets_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable WebSocket service."

[config."nethermind-regtest.cfg".ivars."jsonrpc_additional_rpc_urls"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Additional JSON-RPC URLs."

[config."nethermind-regtest.cfg".ivars."jsonrpc_buffer_responses"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to buffer responses before sending."

[config."nethermind-regtest.cfg".ivars."jsonrpc_calls_filter_file_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to a file with the list of JSON-RPC calls."

# [config."nethermind-regtest.cfg".ivars."jsonrpc_enabled"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Whether to enable the JSON-RPC service."

# [config."nethermind-regtest.cfg".ivars."jsonrpc_enabled_modules"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "JSON-RPC namespaces to enable."

# [config."nethermind-regtest.cfg".ivars."jsonrpc_engine_enabled_modules"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Additional JSON-RPC Engine API modules."

# [config."nethermind-regtest.cfg".ivars."jsonrpc_engine_host"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Engine API host."

# [config."nethermind-regtest.cfg".ivars."jsonrpc_engine_port"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Engine API port."

[config."nethermind-regtest.cfg".ivars."jsonrpc_estimate_error_margin"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Error margin for eth_estimateGas in basis points."

[config."nethermind-regtest.cfg".ivars."jsonrpc_eth_module_concurrent_instances"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of concurrent instances for eth_* JSON-RPC methods."

[config."nethermind-regtest.cfg".ivars."jsonrpc_gas_cap"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Gas limit for eth_call and eth_estimateGas."

# [config."nethermind-regtest.cfg".ivars."jsonrpc_host"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Host for the JSON-RPC service."

[config."nethermind-regtest.cfg".ivars."jsonrpc_ipc_unix_domain_socket_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to connect a UNIX domain socket over."

# [config."nethermind-regtest.cfg".ivars."jsonrpc_jwt_secret_file"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Path to the JWT secret file required for Engine API authentication."

[config."nethermind-regtest.cfg".ivars."jsonrpc_max_batch_response_body_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max batch size limit for batched JSON-RPC calls."

[config."nethermind-regtest.cfg".ivars."jsonrpc_max_batch_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of JSON-RPC requests in a batch."

[config."nethermind-regtest.cfg".ivars."jsonrpc_max_logged_request_parameters_characters"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of characters of a JSON-RPC request parameter printed in the log."

[config."nethermind-regtest.cfg".ivars."jsonrpc_max_logs_per_response"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of logs per response for eth_getLogs."

[config."nethermind-regtest.cfg".ivars."jsonrpc_max_request_body_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max length of HTTP request body in bytes."

[config."nethermind-regtest.cfg".ivars."jsonrpc_max_simulate_blocks_cap"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max block count limit for eth_simulate."

[config."nethermind-regtest.cfg".ivars."jsonrpc_methods_logging_filtering"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Methods not to log in JSON-RPC."

[config."nethermind-regtest.cfg".ivars."jsonrpc_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Port for the JSON-RPC service."

[config."nethermind-regtest.cfg".ivars."jsonrpc_report_interval_seconds"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Interval between JSON-RPC stats report logs in seconds."

[config."nethermind-regtest.cfg".ivars."jsonrpc_request_queue_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of concurrent requests in the queue for JSON-RPC calls."

[config."nethermind-regtest.cfg".ivars."jsonrpc_rpc_recorder_base_file_path"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Base file path for diagnostic recording."

[config."nethermind-regtest.cfg".ivars."jsonrpc_rpc_recorder_state"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Diagnostic recording mode for JSON-RPC."

[config."nethermind-regtest.cfg".ivars."jsonrpc_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Request timeout for JSON-RPC in milliseconds."

[config."nethermind-regtest.cfg".ivars."jsonrpc_unsecure_dev_no_rpc_authentication"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable authentication of the Engine API in development environments."

[config."nethermind-regtest.cfg".ivars."jsonrpc_websockets_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "WebSockets port for the JSON-RPC service."

[config."nethermind-regtest.cfg".ivars."keystore_block_author_account"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Account to use as the block author (coinbase)."

[config."nethermind-regtest.cfg".ivars."keystore_cipher"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Cipher used in keystore encryption. Default is aes-128-ctr."

[config."nethermind-regtest.cfg".ivars."keystore_enode_account"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Account to use for networking (enode)."

[config."nethermind-regtest.cfg".ivars."keystore_enode_key_file"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the key file used for networking (enode)."

[config."nethermind-regtest.cfg".ivars."keystore_iv_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Initialization vector size for keystore encryption. Default is 16."

[config."nethermind-regtest.cfg".ivars."keystore_kdf"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Key derivation function used in keystore encryption. Default is scrypt."

[config."nethermind-regtest.cfg".ivars."keystore_kdfparams_dklen"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Derived key length for key derivation function. Default is 32."

[config."nethermind-regtest.cfg".ivars."keystore_kdfparams_n"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "N parameter for the key derivation function (scrypt). Default is 262144."

[config."nethermind-regtest.cfg".ivars."keystore_kdfparams_p"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "P parameter for the key derivation function (scrypt). Default is 1."

[config."nethermind-regtest.cfg".ivars."keystore_kdfparams_r"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "R parameter for the key derivation function (scrypt). Default is 8."

[config."nethermind-regtest.cfg".ivars."keystore_kdfparams_salt_len"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Length of the salt used in the key derivation function. Default is 32."

[config."nethermind-regtest.cfg".ivars."keystore_keystore_directory"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the keystore directory."

[config."nethermind-regtest.cfg".ivars."keystore_keystore_encoding"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Keystore encoding format. Default is UTF-8."

[config."nethermind-regtest.cfg".ivars."keystore_password_files"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Array of password files paths used to unlock the accounts set with UnlockAccounts."

[config."nethermind-regtest.cfg".ivars."keystore_passwords"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Array of passwords used to unlock the accounts set with UnlockAccounts."

[config."nethermind-regtest.cfg".ivars."keystore_symmetric_encrypter_block_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block size for symmetric encrypter in keystore encryption. Default is 128."

[config."nethermind-regtest.cfg".ivars."keystore_symmetric_encrypter_key_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Key size for symmetric encrypter in keystore encryption. Default is 128."

[config."nethermind-regtest.cfg".ivars."keystore_test_node_key"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Plaintext private key to use for testing purposes."

[config."nethermind-regtest.cfg".ivars."keystore_unlock_accounts"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Array of accounts to unlock on startup using passwords."

[config."nethermind-regtest.cfg".ivars."merge_builder_relay_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "URL of a builder relay for block production."

[config."nethermind-regtest.cfg".ivars."merge_collections_per_decommit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Request the garbage collector to release process memory after a specified number of Engine API calls."

[config."nethermind-regtest.cfg".ivars."merge_compact_memory"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Memory compaction mode for merge blocks."

[config."nethermind-regtest.cfg".ivars."merge_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable the Merge hard fork."

[config."nethermind-regtest.cfg".ivars."merge_final_total_difficulty"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Total difficulty of the last PoW block."

[config."nethermind-regtest.cfg".ivars."merge_new_payload_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Timeout for the engine_newPayload method in seconds."

[config."nethermind-regtest.cfg".ivars."merge_prioritize_block_latency"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Reduce block latency by disabling garbage collection during Engine API calls."

[config."nethermind-regtest.cfg".ivars."merge_seconds_per_slot"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Deprecated. Use Blocks.SecondsPerSlot instead."

[config."nethermind-regtest.cfg".ivars."merge_simulate_block_production"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Simulate block production for every possible slot for stress-testing."

[config."nethermind-regtest.cfg".ivars."merge_sweep_memory"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Garbage collection mode between Engine API calls."

[config."nethermind-regtest.cfg".ivars."merge_terminal_block_hash"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Terminal PoW block hash for the Merge transition."

[config."nethermind-regtest.cfg".ivars."merge_terminal_block_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Terminal PoW block number for the Merge transition."

[config."nethermind-regtest.cfg".ivars."merge_terminal_total_difficulty"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Terminal total difficulty (TTD) for the Merge transition."

[config."nethermind-regtest.cfg".ivars."metrics_counters_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable counters for .NET diagnostics to collect with dotnet-counters."

[config."nethermind-regtest.cfg".ivars."metrics_enable_db_size_metrics"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable database size metrics."

[config."nethermind-regtest.cfg".ivars."metrics_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to publish metrics to Prometheus Pushgateway."

[config."nethermind-regtest.cfg".ivars."metrics_expose_host"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "IP address to expose Prometheus metrics."

[config."nethermind-regtest.cfg".ivars."metrics_expose_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Port to expose Prometheus metrics."

[config."nethermind-regtest.cfg".ivars."metrics_interval_seconds"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Frequency of pushing metrics to Prometheus in seconds."

[config."nethermind-regtest.cfg".ivars."metrics_node_name"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Node name to display on the Grafana dashboard."

[config."nethermind-regtest.cfg".ivars."metrics_push_gateway_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Prometheus Pushgateway instance URL."

[config."nethermind-regtest.cfg".ivars."mining_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable block production."

[config."nethermind-regtest.cfg".ivars."mining_extra_data"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block header extra data (32-byte max length)."

[config."nethermind-regtest.cfg".ivars."mining_min_gas_price"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Minimum gas premium for transactions accepted by the block producer."

[config."nethermind-regtest.cfg".ivars."mining_randomized_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Change the block difficulty randomly within constraints (NethDev only)."

[config."nethermind-regtest.cfg".ivars."mining_signer"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "URL of an external signer, like Clef."

[config."nethermind-regtest.cfg".ivars."mining_target_block_gas_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block gas limit that the block producer should try to reach."

[config."nethermind-regtest.cfg".ivars."network_active_peers_max_count"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Deprecated. Use MaxActivePeers instead."

[config."nethermind-regtest.cfg".ivars."network_bootnodes"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Comma-separated enode list to be used as boot nodes."

[config."nethermind-regtest.cfg".ivars."network_client_id_matcher"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Regex to match clientId. Useful for testing (e.g., 'besu')."

[config."nethermind-regtest.cfg".ivars."network_connect_timeout_ms"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Outgoing connection timeout in milliseconds."

[config."nethermind-regtest.cfg".ivars."network_diag_tracer_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable verbose diagnostic tracing."

[config."nethermind-regtest.cfg".ivars."network_disable_disc_v4_dns_feeder"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable feeding ENR DNS records to discv4 table."

[config."nethermind-regtest.cfg".ivars."network_discovery_dns"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "DNS name for discovery tree (e.g., '<chain name>.ethdisco.net')."

[config."nethermind-regtest.cfg".ivars."network_discovery_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "UDP port number for incoming discovery connections."

[config."nethermind-regtest.cfg".ivars."network_enable_upnp"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable automatic port forwarding via UPnP."

[config."nethermind-regtest.cfg".ivars."network_external_ip"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "External IP address if it cannot be resolved automatically."

[config."nethermind-regtest.cfg".ivars."network_local_ip"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Local IP address if it cannot be resolved automatically."

summary = "Max allowed number of connected peers."


[config."nethermind-regtest.cfg".ivars."network_max_netty_arena_count"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum DotNetty arena count."

[config."nethermind-regtest.cfg".ivars."network_max_outgoing_connect_per_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of new outgoing connections per second."

[config."nethermind-regtest.cfg".ivars."network_netty_arena_order"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Size of DotNetty arena order."

[config."nethermind-regtest.cfg".ivars."network_num_concurrent_outgoing_connects"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of concurrent outgoing connections."

[config."nethermind-regtest.cfg".ivars."network_only_static_peers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to use static peers only."

[config."nethermind-regtest.cfg".ivars."network_p2p_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "TCP port for incoming P2P connections."

[config."nethermind-regtest.cfg".ivars."network_priority_peers_max_count"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of priority peers."

[config."nethermind-regtest.cfg".ivars."network_processing_thread_count"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of threads in final processing of network packets."

[config."nethermind-regtest.cfg".ivars."network_simulate_send_latency_ms"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Fixed latency for all P2P message sends (useful for testing)."

[config."nethermind-regtest.cfg".ivars."network_static_peers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "List of static peers to maintain connection."

[config."nethermind-regtest.cfg".ivars."optimism_sequencer_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sequencer URL for Optimism."

[config."nethermind-regtest.cfg".ivars."plugin_plugin_order"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Order of plugin initialization."

[config."nethermind-regtest.cfg".ivars."pruning_available_space_check_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable available disk space check for pruning."

[config."nethermind-regtest.cfg".ivars."pruning_cache_mb"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "In-memory cache size in MB for pruning."

[config."nethermind-regtest.cfg".ivars."pruning_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable in-memory pruning."

[config."nethermind-regtest.cfg".ivars."pruning_full_pruning_completion_behavior"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Behavior after pruning completion."

[config."nethermind-regtest.cfg".ivars."pruning_full_pruning_disable_low_priority_writes"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable low-priority for pruning writes."

[config."nethermind-regtest.cfg".ivars."pruning_full_pruning_max_degree_of_parallelism"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of parallel tasks for full pruning."

[config."nethermind-regtest.cfg".ivars."pruning_full_pruning_memory_budget_mb"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Memory budget in MB for the trie visit during pruning."

[config."nethermind-regtest.cfg".ivars."pruning_full_pruning_minimum_delay_hours"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Minimum delay between full pruning operations in hours."

[config."nethermind-regtest.cfg".ivars."pruning_full_pruning_threshold_mb"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Threshold in MB to trigger full pruning."

[config."nethermind-regtest.cfg".ivars."pruning_full_pruning_trigger"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Trigger for full pruning (Manual, StateDbSize, VolumeFreeSpace)."

[config."nethermind-regtest.cfg".ivars."pruning_mode"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Pruning mode (None, Memory, Full, Hybrid)."

[config."nethermind-regtest.cfg".ivars."pruning_persistence_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Block persistence frequency in pruning."

[config."nethermind-regtest.cfg".ivars."pruning_pruning_boundary"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of past states to keep from the head before pruning."

[config."nethermind-regtest.cfg".ivars."pruning_tracked_past_key_count_memory_ratio"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Memory ratio for LRU cache used to track past keys for pruning."

[config."nethermind-regtest.cfg".ivars."receipt_compact_receipt_store"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compact receipts database size."

[config."nethermind-regtest.cfg".ivars."receipt_compact_tx_index"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Compact receipts transaction index database size."

[config."nethermind-regtest.cfg".ivars."receipt_force_receipts_migration"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Force receipt recovery if not able to detect it."

[config."nethermind-regtest.cfg".ivars."receipt_max_block_depth"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of blocks per eth_getLogs request."

[config."nethermind-regtest.cfg".ivars."receipt_receipts_migration"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Migrate the receipts database to the new schema."

[config."nethermind-regtest.cfg".ivars."receipt_receipts_migration_degree_of_parallelism"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Degree of parallelism during receipt migration."

[config."nethermind-regtest.cfg".ivars."receipt_store_receipts"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Store receipts after a new block is processed."

[config."nethermind-regtest.cfg".ivars."receipt_tx_lookup_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of recent blocks to maintain transaction index for."

[config."nethermind-regtest.cfg".ivars."seq_api_key"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "API key for Seq."

[config."nethermind-regtest.cfg".ivars."seq_min_level"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Minimum log level sent to Seq."

[config."nethermind-regtest.cfg".ivars."seq_server_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "URL of the Seq instance."

[config."nethermind-regtest.cfg".ivars."snapshot_checksum"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "SHA-256 checksum of the snapshot file."

[config."nethermind-regtest.cfg".ivars."snapshot_download_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "URL of the snapshot file."

[config."nethermind-regtest.cfg".ivars."snapshot_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable the Snapshot plugin."

[config."nethermind-regtest.cfg".ivars."snapshot_snapshot_directory"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Path to the directory for storing the snapshot file."

[config."nethermind-regtest.cfg".ivars."snapshot_snapshot_file_name"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Name of the snapshot file."

[config."nethermind-regtest.cfg".ivars."sync_ancient_bodies_barrier"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Earliest body downloaded with fast sync when `DownloadBodiesInFastSync` is enabled."

[config."nethermind-regtest.cfg".ivars."sync_ancient_receipts_barrier"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Earliest receipt downloaded with fast sync when `DownloadReceiptsInFastSync` is enabled."

[config."nethermind-regtest.cfg".ivars."sync_blocks_db_tune_db_mode"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Configure blocks database for write optimizations during sync."

[config."nethermind-regtest.cfg".ivars."sync_download_bodies_in_fast_sync"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to download block bodies in fast sync mode."

[config."nethermind-regtest.cfg".ivars."sync_download_headers_in_fast_sync"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to download old block headers in fast sync mode."

[config."nethermind-regtest.cfg".ivars."sync_download_receipts_in_fast_sync"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to download receipts in fast sync mode."

[config."nethermind-regtest.cfg".ivars."sync_exit_on_synced"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to shut down Nethermind once sync is finished."

[config."nethermind-regtest.cfg".ivars."sync_exit_on_synced_wait_time_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Time to wait before shutting down after sync is finished, in seconds."

[config."nethermind-regtest.cfg".ivars."sync_fast_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Deprecated."

[config."nethermind-regtest.cfg".ivars."sync_fast_sync"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to use the fast sync mode."

[config."nethermind-regtest.cfg".ivars."sync_fast_sync_catch_up_height_delta"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Minimum height threshold up to which full sync stays on during fast sync."

[config."nethermind-regtest.cfg".ivars."sync_fix_receipts"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable receipts validation and fix if necessary."

[config."nethermind-regtest.cfg".ivars."sync_fix_total_difficulty"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Recalculate total difficulty between specified blocks."

[config."nethermind-regtest.cfg".ivars."sync_fix_total_difficulty_last_block"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Last block for total difficulty recalculation."

[config."nethermind-regtest.cfg".ivars."sync_fix_total_difficulty_starting_block"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Starting block for total difficulty recalculation."

[config."nethermind-regtest.cfg".ivars."sync_malloc_trim_interval_sec"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Interval between `malloc_trim` calls during sync, in seconds."

[config."nethermind-regtest.cfg".ivars."sync_max_attempts_to_update_pivot"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of attempts to update the pivot block."

[config."nethermind-regtest.cfg".ivars."sync_max_processing_threads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of threads used for syncing."

[config."nethermind-regtest.cfg".ivars."sync_multi_sync_mode_selector_loop_timer_ms"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sync mode timer loop interval for testing, in milliseconds."

[config."nethermind-regtest.cfg".ivars."sync_networking_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable networking and sync."

[config."nethermind-regtest.cfg".ivars."sync_non_validator_node"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to operate as a non-validator node."

[config."nethermind-regtest.cfg".ivars."sync_pivot_hash"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Hash of the pivot block in fast sync mode."

[config."nethermind-regtest.cfg".ivars."sync_pivot_number"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of the pivot block in fast sync mode."

[config."nethermind-regtest.cfg".ivars."sync_pivot_total_difficulty"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Total difficulty of the pivot block in fast sync mode."

[config."nethermind-regtest.cfg".ivars."sync_snap_serving_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable Snap serving."

[config."nethermind-regtest.cfg".ivars."sync_snap_sync"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to use Snap sync mode."

[config."nethermind-regtest.cfg".ivars."sync_snap_sync_account_range_partition_count"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of account range partitions for Snap sync."

[config."nethermind-regtest.cfg".ivars."sync_strict_mode"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Disable optimizations and perform more extensive sync."

[config."nethermind-regtest.cfg".ivars."sync_synchronization_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to download and process new blocks."

[config."nethermind-regtest.cfg".ivars."sync_trie_healing"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable healing trie from the network when state is corrupted."

[config."nethermind-regtest.cfg".ivars."sync_tune_db_mode"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Configure the database for write optimizations during sync."

[config."nethermind-regtest.cfg".ivars."sync_use_geth_limits_in_fast_blocks"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Make smaller requests in fast blocks mode to avoid Geth disconnections."

[config."nethermind-regtest.cfg".ivars."tracestore_blocks_to_keep"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of blocks to store in TraceStore."

[config."nethermind-regtest.cfg".ivars."tracestore_deserialization_parallelization"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max parallelization for deserialization in trace_filter method."

[config."nethermind-regtest.cfg".ivars."tracestore_enabled"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to enable the TraceStore plugin."

[config."nethermind-regtest.cfg".ivars."tracestore_max_depth"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max depth allowed when deserializing traces."

[config."nethermind-regtest.cfg".ivars."tracestore_trace_types"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Types of traces to store (Trace, Rewards, etc.)."

[config."nethermind-regtest.cfg".ivars."tracestore_verify_serialized"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Whether to verify all serialized elements in TraceStore."

[config."nethermind-regtest.cfg".ivars."txpool_blob_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of full blob transactions cached in memory."

[config."nethermind-regtest.cfg".ivars."txpool_blobs_support"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Blobs support mode in TxPool (Disabled, InMemory, Storage, StorageWithReorgs)."

[config."nethermind-regtest.cfg".ivars."txpool_gas_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max transaction gas allowed in TxPool."

[config."nethermind-regtest.cfg".ivars."txpool_hash_cache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of cached hashes of known transactions."

[config."nethermind-regtest.cfg".ivars."txpool_in_memory_blob_pool_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of full blob transactions stored in memory."

[config."nethermind-regtest.cfg".ivars."txpool_max_pending_blob_txs_per_sender"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of pending blob transactions per sender."

[config."nethermind-regtest.cfg".ivars."txpool_max_pending_txs_per_sender"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of pending transactions per sender."

[config."nethermind-regtest.cfg".ivars."txpool_min_base_fee_threshold"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Minimum percentage of the current base fee that must be surpassed by the max fee for the transaction to be broadcasted."

[config."nethermind-regtest.cfg".ivars."txpool_peer_notification_threshold"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Percentage of transaction hashes from broadcast sent to a peer."

[config."nethermind-regtest.cfg".ivars."txpool_persistent_blob_storage_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of full blob transactions stored in the database."

[config."nethermind-regtest.cfg".ivars."txpool_report_minutes"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Interval in minutes for reporting the current transaction pool state."

[config."nethermind-regtest.cfg".ivars."txpool_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Max number of transactions held in the TxPool."

[config."nethermind-regtest.cfg".ivars."wallet_dev_accounts"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of autogenerated developer accounts with predefined private keys."

