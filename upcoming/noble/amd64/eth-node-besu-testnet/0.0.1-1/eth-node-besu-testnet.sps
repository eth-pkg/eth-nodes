name = "eth-node-besu-testnet"
bin_package = "eth-node-besu"
binary = "/usr/lib/eth-node-besu-testnet/run-service.sh"
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

# we overwrite this
ProtectSystem=strict

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
add_dirs = ["/var/lib/eth-node-testnet"]
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-service.sh /usr/lib/eth-node-besu-testnet", 
    "debian/eth-node-besu-testnet.service /lib/systemd/system/"
    ]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-testnet-config", "eth-node-testnet"]
summary = "service file for eth-node-besu for network: testnet"


[config."service.conf"]
format = "plain"

[config."service.conf".ivars.shared_file]
type = "string"
default = "/etc/eth-node-testnet/conf.d/testnet.conf"
priority = "low"
summary = "Shared configuration file"

[config."service.conf".ivars.client_config]
type = "string"
default = "/etc/eth-node-testnet/besu/conf.d/besu-testnet.conf"
priority = "low"
summary = "Besu config, based on shared file"


# [config."conf.d/credentials.conf".evars."bitcoin".datadir]
# store = false

# [config."../eth-node-testnet/besu/conf.d/besu-testnet.conf".evars."eth-node-config-testnet-besu"."BESU_CLI_DATA_PATH"]
# BESU_CLI_DATA_PATH = "$BASE_CONFIG_DATA_DIR/besu"


