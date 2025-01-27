name = "eth-node-besu-regtest"
bin_package = "eth-node-besu"
binary = "/usr/bin/besu"
conf_param = "--config-file=/etc/eth-node-besu/eth-node-besu.toml"
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
## hack to actually use system.d but let debcrafter manage the user creationc
add_files = [
    "debian/scripts/admin.xml /usr/lib/eth-node-besu-regtest/",
    "debian/tmp/eth-node-besu-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-besu-regtest",
    "debian/config/eth-node-besu.toml /etc/eth-node-besu-regtest/",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-besu for network: regtest"

[config."eth-node-besu.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-besu-regtest/postprocess.sh"]

[config."eth-node-besu.conf"]
format = "plain"
public = true 