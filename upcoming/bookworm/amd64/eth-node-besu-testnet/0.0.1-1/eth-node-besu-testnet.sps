name = "eth-node-besu-testnet"
bin_package = "eth-node-besu"
binary = "/usr/lib/eth-node-besu-testnet/run-service.sh"
user = { name = "eth-node-besu-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
CapabilityBoundingSet=
ExecStart=/bin/bash /usr/lib/eth-node-besu-testnet/run-service.sh
CapabilityBoundingSet=
IPAddressDeny=none
LockPersonality=true
NoNewPrivileges=true
PrivateDevices=true
PrivateIPC=true
PrivateTmp=true
PrivateUsers=true
ProtectClock=true
ProtectControlGroups=true
ProtectHome=true
ProtectHostname=true
ProtectKernelLogs=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectProc=invisible
ProtectSystem=strict
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
User=eth-node-besu-testnet
WorkingDirectory=/var/lib/eth-node-testnet/besu
"""
add_dirs = ["/var/lib/eth-node-testnet"]
## hack to actually use system.d but let debcrafter manage the user creation
# add_files = ["debian/lib/systemd/system/eth-node-besu-testnet.service /lib/systemd/system/"]
add_files = ["debian/scripts/run-service.sh /usr/lib/eth-node-besu-testnet"]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-testnet-config", "eth-node-testnet"]
summary = "systemd service files for eth-node-besu using eth-node-config-besu-testnet and eth-node-testnet-config"


[config."service.conf"]
format = "plain"

[config."service.conf".ivars.shared_file]
type = "string"
default = "/etc/eth-node-testnet/conf.d/testnet.conf"
priority = "high"
summary = "Shared configuration file"

[config."service.conf".ivars.client_config]
type = "string"
default = "/etc/eth-node-testnet/besu/conf.d/besu-testnet.conf"
priority = "high"
summary = "Besu config, based on shared file"


# [config."conf.d/credentials.conf".evars."bitcoin".datadir]
# store = false

# [config."../eth-node-testnet/besu/conf.d/besu-testnet.conf".evars."eth-node-config-besu-testnet"."BESU_CLI_DATA_PATH"]
# BESU_CLI_DATA_PATH = "$BASE_CONFIG_DATA_DIR/besu"


