name = "eth-node-nethermind-testnet"
bin_package = "eth-node-nethermind"
binary = "/usr/lib/eth-node-nethermind-testnet/run-nethermind-service.sh"
user = { name = "eth-node-nethermind-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-nethermind-testnet
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
ReadWritePaths=/var/lib/eth-node-testnet/nethermind
ReadOnlyPaths=/var/lib/eth-node-testnet
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-testnet/nethermind
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-nethermind-service.sh /usr/lib/eth-node-nethermind-testnet/", 
    "debian/scripts/run-nethermind.sh /usr/lib/eth-node-nethermind-testnet/bin/",
    "debian/tmp/eth-node-nethermind-testnet.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-nethermind-testnet",
]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-testnet-config", "eth-node-testnet"]
summary = "service file for eth-node-nethermind for network: testnet"

[config."nethermind-testnet.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-nethermind-testnet/postprocess.sh"]

[config."nethermind-testnet.conf"]
format = "plain"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_DATADIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/nethermind"
priority = "low"
summary = "Data directory for Nethermind"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_INIT_WEB_SOCKETS_ENABLED"]
type = "string"
default = "true"
priority = "low"
summary = "Whether to enable WebSocket service for JSON-RPC on startup"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_JSON_RPC_ENABLED_MODULES"]
type = "string"
default = "et,eth,consensus,subscribe,web3,admin"
priority = "low"
summary = "An array of JSON-RPC namespaces to enable"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_JSON_RPC_HOST"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "The JSON-RPC service host"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_JSON_RPC_ENGINE_HOST"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "The Engine API host"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_JSON_RPC_ENGINE_PORT"]
type = "string"
default = "8551"
priority = "low"
summary = "The Engine API port"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_JSON_RPC_JWT_SECRET_FILE"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "Path to JWT secret file for Engine API authentication"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_CONFIG"]
type = "string"
default = "none.cfg"
priority = "low"
summary = "Config file path"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_INIT_CHAIN_SPEC_PATH"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_TESTNET_DIR/chainspec.json"
priority = "low"
summary = "Path to the chain spec file"

[config."nethermind-testnet.conf".ivars."NETHERMIND_CLI_NETWORK_BOOTNODES"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENR"
priority = "low"
summary = "Comma-separated enode list used as boot nodes"
