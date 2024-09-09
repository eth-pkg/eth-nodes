name = "eth-node-testnet-service-besu"
bin_package = "eth-node-config-testnet-besu"
binary = "/usr/lib/eth-node-config-testnet/bin/run-besu.sh"
conf_param = "--conf-file"
user = { name = "eth-node-testnet-besu", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
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
User=eth-node-testnet-besu
WorkingDirectory=/var/lib/eth-node-testnet/besu
"""
add_dirs = ["/var/lib/eth-node-testnet"]
## hack to actually use system.d but let debcrafter manage the user creation
# add_files = ["debian/lib/systemd/system/eth-node-testnet-service-besu.service /lib/systemd/system/"]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-config-testnet-besu", "eth-node-testnet-config", "eth-node-testnet"]
summary = "systemd service files for eth-node-besu using eth-node-config-testnet-besu and eth-node-testnet-config"

[config."/etc/eth-node-testnet/conf.d/testnet.conf"]
format = "plain"

[config."/etc/eth-node-testnet/besu/conf.d/besu-testnet.conf"]
format = "plain"

# [config."/etc/eth-node-testnet/besu-testnet.conf".evars."BESU_CLI_DATA_PATH"]
# BESU_CLI_DATA_PATH = "$BASE_CONFIG_DATA_DIR/besu"

# type = "path"
# file_type = "dir"
# create = { mode = 755, owner = "eth-node-testnet-besu", group = "eth-node-testnet-besu" }
# default = "/var/lib/eth-node-testnet/besu"
# priority = "low"
# summary = "Node working directory"

# we need to create extra groups as group creation will fail if name is too long, 
# example: eth-node-testnet-service-nimbus-eth2 will be too long
# this is a debian limitation of the length of user and group name
[extra_groups."eth-node-testnet-besu"]
create = false
