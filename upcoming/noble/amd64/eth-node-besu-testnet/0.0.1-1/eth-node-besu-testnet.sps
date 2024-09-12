name = "eth-node-besu-testnet"
bin_package = "eth-node-besu"
binary = "/usr/lib/eth-node-besu-testnet/run-besu-service.sh"
user = { name = "eth-node-besu-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-besu-testnet
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
ReadWritePaths=/var/lib/eth-node-testnet/besu
ReadOnlyPaths=/var/lib/eth-node-testnet
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-testnet/besu
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-besu-service.sh /usr/lib/eth-node-besu-testnet/", 
    "debian/scripts/run-besu.sh /usr/lib/eth-node-besu-testnet/bin/",
    "debian/tmp/eth-node-besu-testnet.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-besu-testnet",
]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-testnet-config", "eth-node-testnet"]
summary = "service file for eth-node-besu for network: testnet"

[config."besu-testnet.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-besu-testnet/postprocess.sh"]

[config."besu-testnet.conf"]
format = "plain"

[config."besu-testnet.conf".ivars."BESU_CLI_DATA_PATH"]
type = "string"
default = "/var/lib/eth-node-testnet/besu"
priority = "low"
summary = "Path to Besu data directory (default: /var/lib/eth-node-testnet/besu)"

[config."besu-testnet.conf".ivars."BESU_CLI_ENGINE_JWT_SECRET"]
type = "string"
default = "/etc/eth-node-testnet/jwt.hex"
priority = "low"
summary = "Path to file containing shared secret key for JWT signature verification"

[config."besu-testnet.conf".ivars."BESU_CLI_NETWORK"]
type = "string"
default = ""
priority = "low"
summary = "Synchronize against the indicated network: MAINNET, SEPOLIA, GOERLI, HOLESKY, DEV, FUTURE_EIPS, EXPERIMENTAL_EIPS, CLASSIC, MORDOR. (default: MAINNET) leave it empty for custom network"

[config."besu-testnet.conf".ivars."BESU_CLI_BOOTNODES"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENODE"
priority = "low"
summary = "P2P network identifier. (default: the selected network chain ID or custom genesis chain ID)"

[config."besu-testnet.conf".ivars."BESU_CLI_NETWORK_ID"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_NETWORK_ID"
priority = "low"
summary = "P2P network identifier. (default: the selected network chain ID or custom genesis chain ID)"


[config."besu-testnet.conf".ivars."BESU_CLI_ENGINE_RPC_ENABLED"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the engine API, even in the absence of merge-specific configurations (default: false)"

[config."besu-testnet.conf".ivars."BESU_CLI_SYNC_MODE"]
type = "string"
default = "full"
priority = "low"
summary = "Synchronization mode, possible values are FULL, FAST, SNAP, CHECKPOINT, X_SNAP, X_CHECKPOINT (default: SNAP if a --network is supplied and privacy isn't enabled. FULL otherwise.)"

[config."besu-testnet.conf".ivars."BESU_CLI_GENESIS_FILE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_TESTNET_DIR/besu.json"
priority = "low"
summary = "Path to genesis file for your custom network"

[config."besu-testnet.conf".ivars."BESU_CLI_BONSAI_LIMIT_TRIE_LOGS_ENABLED"]
type = "string"
default = "false"
priority = "low"
summary = "--bonsai-limit-trie-logs-enabled"

[config."besu-testnet.conf".ivars."BESU_CLI_P2P_ENABLED"]
type = "string"
default = "false"
priority = "low"
summary = "Enable P2P functionality (default: true). Only running one EL client on testnet."

[config."besu-testnet.conf".ivars."BESU_CLI_RPC_HTTP_API"]
type = "string"
default = "ETH"
priority = "low"
summary = "Set RPC HTTP API to ETH"

[config."besu-testnet.conf".ivars."BESU_CLI_RPC_HTTP_ENABLED"]
type = "string"
default = "true"
priority = "low"
summary = "Enable RPC HTTP functionality"

[config."besu-testnet.conf".ivars."BESU_CLI_RPC_HTTP_PORT"]
type = "string"
default = "$BASE_CONFIG_EL_RPC_PORT"
priority = "low"
summary = "Set the RPC HTTP port"



