name = "eth-node-prometheus-node-exporter-regtest"
bin_package = "eth-node-besu"
binary = "/usr/lib/eth-node-prometheus-node-exporter-regtest/run-besu-service.sh"
user = { name = "eth-node-prometheus-node-exporter-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-prometheus-node-exporter-regtest
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
    "debian/tmp/eth-node-prometheus-node-exporter-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-prometheus-node-exporter-regtest",
]
provides = ["eth-node-regtest-el-monitoring-service"]
conflicts = ["eth-node-regtest-el-monitoring-service"]
depends=["eth-node-besu-regtest", "eth-node-prometheus"]
summary = "service file for eth-node-besu-monitoring for network: regtest"

[config."prometheus-node-exporter-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-prometheus-node-exporter-regtest/postprocess.sh"]

[config."prometheus-node-exporter-regtest.conf"]
format = "plain"



