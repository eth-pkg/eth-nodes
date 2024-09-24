name = "eth-node-erigon-regtest"
bin_package = "eth-node-erigon"
binary = "/usr/lib/eth-node-erigon-regtest/run-erigon-service.sh"
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
    "debian/scripts/run-erigon-service.sh /usr/lib/eth-node-erigon-regtest/", 
    "debian/scripts/run-erigon.sh /usr/lib/eth-node-erigon-regtest/bin/",
    "debian/tmp/eth-node-erigon-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-erigon-regtest",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config", "eth-node-regtest"]
summary = "service file for eth-node-erigon for network: regtest"

[config."erigon-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-erigon-regtest/postprocess.sh"]

[config."erigon-regtest.conf"]
format = "plain"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_NETWORKID"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_NETWORK_ID"
priority = "low"
summary = "Explicitly set network ID (integer)"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_DATADIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/erigon"
priority = "low"
summary = "Data directory for the databases"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_HTTP_API"]
type = "string"
default = "eth,erigon,engine,web3,net,debug,trace,txpool,admin"
priority = "low"
summary = "APIs offered over the HTTP-RPC interface"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_HTTP_VHOSTS"]
type = "string"
default = "localhost"
priority = "low"
summary = "Comma separated list of virtual hostnames from which to accept requests"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_WS"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the WS-RPC server"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_AUTHRPC_ADDR"]
type = "string"
default = "$BASE_CONFIG_ENGINE_IP"
priority = "low"
summary = "HTTP-RPC server listening interface for the Engine API"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_AUTHRPC_VHOSTS"]
type = "string"
default = "localhost"
priority = "low"
summary = "Comma separated list of virtual hostnames from which to accept Engine API requests"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_AUTHRPC_JWTSECRET"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "Path to the token that ensures safe connection between CL and EL"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_HTTP"]
type = "string"
default = "true"
priority = "low"
summary = "JSON-RPC server (enabled by default)"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_BOOTNODES"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENR"
priority = "low"
summary = "Comma separated enode URLs for P2P discovery bootstrap"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_HTTP_ADDR"]
type = "string"
default = "$BASE_CONFIG_ENGINE_IP"
priority = "low"
summary = "HTTP-RPC server listening interface"

[config."erigon-regtest.conf".ivars."ERIGON_CLI_HTTP_CORSDOMAIN"]
type = "string"
default = "localhost"
priority = "low"
summary = "Comma separated list of domains from which to accept cross-origin requests"
