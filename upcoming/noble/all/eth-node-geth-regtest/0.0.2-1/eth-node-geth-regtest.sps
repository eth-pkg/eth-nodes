name = "eth-node-geth-regtest"
bin_package = "eth-node-geth"
binary = "/usr/lib/eth-node-geth-regtest/run-geth-service.sh"
user = { name = "eth-node-geth-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-geth-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/geth
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/geth
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-geth-service.sh /usr/lib/eth-node-geth-regtest/", 
    "debian/scripts/run-geth.sh /usr/lib/eth-node-geth-regtest/bin/",
    "debian/tmp/eth-node-geth-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-geth-regtest",
    "debian/keystore /var/lib/eth-node-regtest/geth/",
    "debian/geth_password.txt /var/lib/eth-node-regtest/geth/",
    "debian/sk.json /var/lib/eth-node-regtest/geth/",
    "debian/config/eth-node-geth-regtest.yaml /etc/eth-node-geth-regtest/",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-geth for network: regtest"

[config."geth-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-geth-regtest/postprocess.sh"]

[config."geth-regtest.conf"]
format = "plain"
