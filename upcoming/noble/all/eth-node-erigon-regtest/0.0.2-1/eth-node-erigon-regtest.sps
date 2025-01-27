name = "eth-node-erigon-regtest"
bin_package = "eth-node-erigon"
binary = "/usr/bin/erigon"
## TODO remove http.api from here
conf_param = "--http.api='eth,erigon,engine,web3,net,debug,trace,txpool,admin,ots' --config=/etc/eth-node-erigon-regtest/eth-node-erigon-regtest.yaml"
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
    "debian/tmp/eth-node-erigon-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-erigon-regtest",
    "debian/config/eth-node-erigon-regtest.yaml /etc/eth-node-erigon-regtest/",
]
provides = ["eth-node-regtest-el-service"]
conflicts = ["eth-node-regtest-el-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-erigon for network: regtest"

[config."erigon-regtest.yaml".postprocess]
command = ["bash", "/usr/lib/eth-node-erigon-regtest/postprocess.sh"]

[config."erigon-regtest.yaml"]
format = "yaml"
