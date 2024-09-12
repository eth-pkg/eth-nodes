name = "eth-node-geth-testnet"
bin_package = "eth-node-geth"
binary = "/usr/lib/eth-node-geth-testnet/run-geth-service.sh"
user = { name = "eth-node-geth-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-geth-testnet
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
ReadWritePaths=/var/lib/eth-node-testnet/geth
ReadOnlyPaths=/var/lib/eth-node-testnet
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-testnet/geth
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-geth-service.sh /usr/lib/eth-node-geth-testnet/", 
    "debian/scripts/run-geth.sh /usr/lib/eth-node-geth-testnet/bin/",
    "debian/tmp/eth-node-geth-testnet.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-geth-testnet",
]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-testnet-config", "eth-node-testnet"]
summary = "service file for eth-node-geth for network: testnet"

[config."geth-testnet.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-geth-testnet/postprocess.sh"]

[config."geth-testnet.conf"]
format = "plain"

[config."geth-testnet.conf".ivars."GETH_CLI_DATADIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/geth"
priority = "low"
summary = "Data directory for the databases and keystore"

[config."geth-testnet.conf".ivars."GETH_CLI_AUTHRPC_JWTSECRET"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "Path to a JWT secret to use for authenticated RPC endpoints"

[config."geth-testnet.conf".ivars."GETH_CLI_HTTP"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the HTTP-RPC server"

[config."geth-testnet.conf".ivars."GETH_CLI_HTTP_API"]
type = "string"
default = "eth,net,web3"
priority = "low"
summary = "APIs offered over the HTTP-RPC interface"

[config."geth-testnet.conf".ivars."GETH_CLI_SYNCMODE"]
type = "string"
default = "full"
priority = "low"
summary = "Blockchain sync mode (\"snap\" or \"full\")"

[config."geth-testnet.conf".ivars."GETH_CLI_AUTHRPC_ADDR"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Listening address for authenticated APIs"

[config."geth-testnet.conf".ivars."GETH_CLI_HTTP_ADDR"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "HTTP-RPC server listening interface"

[config."geth-testnet.conf".ivars."GETH_CLI_GRAPHQL_CORSDOMAIN"]
type = "string"
default = "localhost"
priority = "low"
summary = "Comma separated list of domains from which to accept cross origin requests (browser enforced)"

[config."geth-testnet.conf".ivars."GETH_CLI_WS"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the WS-RPC server"

[config."geth-testnet.conf".ivars."GETH_CLI_WS_API"]
type = "string"
default = "eth,net,web3"
priority = "low"
summary = "APIs offered over the WS-RPC interface"

[config."geth-testnet.conf".ivars."GETH_CLI_WS_ADDR"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "WS-RPC server listening interface"

[config."geth-testnet.conf".ivars."GETH_CLI_WS_ORIGINS"]
type = "string"
default = "localhost"
priority = "low"
summary = "Origins from which to accept websockets requests"

[config."geth-testnet.conf".ivars."GETH_CLI_AUTHRPC_VHOSTS"]
type = "string"
default = "localhost"
priority = "low"
summary = "Comma separated list of virtual hostnames from which to accept requests (server enforced). Accepts '*' wildcard."

[config."geth-testnet.conf".ivars."GETH_CLI_ALLOW_INSECURE_UNLOCK"]
type = "string"
default = "true"
priority = "low"
summary = "Allow insecure account unlocking when account-related RPCs are exposed by HTTP"

[config."geth-testnet.conf".ivars."GETH_CLI_PASSWORD"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/geth/geth_password.txt"
priority = "low"
summary = "Password file to use for non-interactive password input"

[config."geth-testnet.conf".ivars."GETH_CLI_UNLOCK"]
type = "string"
default = "$BASE_CONFIG_VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = "Comma separated list of accounts to unlock"

[config."geth-testnet.conf".ivars."GETH_CLI_NODISCOVER"]
type = "string"
default = "true"
priority = "low"
summary = "Disables the peer discovery mechanism (manual peer addition)"
