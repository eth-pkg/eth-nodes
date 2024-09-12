name = "eth-node-teku-validator-testnet"
bin_package = "eth-node-teku"
binary = "/usr/lib/eth-node-teku-validator-testnet/run-teku-service.sh"
user = { name = "eth-node-teku-validator-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-teku-validator-testnet
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
ReadWritePaths=/var/lib/eth-node-testnet/teku
ReadOnlyPaths=/var/lib/eth-node-testnet
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-testnet/teku
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-teku-service.sh /usr/lib/eth-node-teku-validator-testnet/", 
    "debian/scripts/run-teku.sh /usr/lib/eth-node-teku-validator-testnet/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-teku-validator-testnet",
    "debian/tmp/eth-node-teku-validator-testnet.service /lib/systemd/system/",
]
provides = ["eth-node-testnet-cl-service"]
conflicts = ["eth-node-testnet-cl-service"]
depends=["eth-node-testnet-config", "eth-node-testnet"]
summary = "service file for eth-node-teku for network: testnet"

[config."teku-validator-testnet.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-teku-validator-testnet/postprocess.sh"]

[config."teku-validator-testnet.conf"]
format = "plain"

