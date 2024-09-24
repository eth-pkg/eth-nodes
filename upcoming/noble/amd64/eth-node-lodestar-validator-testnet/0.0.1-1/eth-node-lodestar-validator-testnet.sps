name = "eth-node-lodestar-validator-testnet"
bin_package = "eth-node-lodestar"
binary = "/usr/lib/eth-node-lodestar-validator-testnet/run-lodestar-validator-service.sh"
user = { name = "eth-node-lodestar-val-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-lodestar-val-testnet
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
ReadWritePaths=/var/lib/eth-node-testnet/lodestar-validator
ReadOnlyPaths=/var/lib/eth-node-testnet
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-testnet/lodestar-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lodestar-validator-service.sh /usr/lib/eth-node-lodestar-validator-testnet/", 
    "debian/scripts/run-lodestar-validator.sh /usr/lib/eth-node-lodestar-validator-testnet/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lodestar-validator-testnet",
    "debian/tmp/eth-node-lodestar-validator-testnet.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-testnet/lodestar-validator",
    "debian/validator/passwords /var/lib/eth-node-testnet/lodestar-validator",
]
provides = ["eth-node-testnet-validator"]
conflicts = ["eth-node-testnet-validator"]
depends=["eth-node-lodestar-testnet"]
summary = "validator service file for eth-node-lodestar for network: testnet"

[config."lodestar-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lodestar-validator-testnet/postprocess.sh"]

[config."lodestar-validator.conf"]
format = "plain"



# [config."lodestar-validator.conf".ivars."LIGHTHOUSE_CLI_VALIDATOR_TESTNET_DIR"]
# type = "string"
# default = "$BASE_CONFIG_CUSTOM_NETWORK_TESTNET_DIR"
# priority = "low"
# summary = ""


[config."lodestar-validator.conf".ivars."LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR"]
type = "string"
default = "/var/lib/eth-node-testnet/lodestar-validator"
priority = "low"
summary = "Path to validators dir"

