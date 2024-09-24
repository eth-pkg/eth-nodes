name = "eth-node-prysm-validator-testnet"
bin_package = "eth-node-prysm"
binary = "/usr/lib/eth-node-prysm-validator-testnet/run-prysm-validator-service.sh"
user = { name = "eth-node-prysm-val-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-prysm-val-testnet
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
ReadWritePaths=/var/lib/eth-node-testnet/prysm-validator
ReadOnlyPaths=/var/lib/eth-node-testnet
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-testnet/prysm-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-prysm-validator-service.sh /usr/lib/eth-node-prysm-validator-testnet/", 
    "debian/scripts/run-prysm-validator.sh /usr/lib/eth-node-prysm-validator-testnet/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-prysm-validator-testnet",
    "debian/tmp/eth-node-prysm-validator-testnet.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-testnet/prysm-validator",
    "debian/validator/passwords /var/lib/eth-node-testnet/prysm-validator",
]
provides = ["eth-node-testnet-validator"]
conflicts = ["eth-node-testnet-validator"]
depends=["eth-node-prysm-testnet"]
summary = "validator service file for eth-node-prysm for network: testnet"

[config."prysm-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-prysm-validator-testnet/postprocess.sh"]

[config."prysm-validator.conf"]
format = "plain"