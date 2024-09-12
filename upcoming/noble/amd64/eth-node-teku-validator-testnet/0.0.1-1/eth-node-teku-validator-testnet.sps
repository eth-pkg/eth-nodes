name = "eth-node-teku-validator-testnet"
bin_package = "eth-node-teku"
binary = "/usr/lib/eth-node-teku-validator-testnet/run-teku-validator-service.sh"
user = { name = "eth-node-teku-val-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-teku-val-testnet
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
ReadWritePaths=/var/lib/eth-node-testnet/teku-validator
ReadOnlyPaths=/var/lib/eth-node-testnet
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-testnet/teku-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-teku-validator-service.sh /usr/lib/eth-node-teku-validator-testnet/", 
    "debian/scripts/run-teku-validator.sh /usr/lib/eth-node-teku-validator-testnet/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-teku-validator-testnet",
    "debian/tmp/eth-node-teku-validator-testnet.service /lib/systemd/system/",
]
provides = ["eth-node-testnet-validator-service"]
conflicts = ["eth-node-testnet-validator-service"]
depends=["eth-node-teku-testnet"]
summary = "validator service file for eth-node-teku for network: testnet"

[config."teku-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-teku-validator-testnet/postprocess.sh"]

[config."teku-validator.conf"]
format = "plain"


[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_BEACON_NODE_API_ENDPOINTS"]
type = "string"
default = "http://127.0.0.1:5052"  
priority = "low"
summary = ""

[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_VALIDATOR_KEYS"]
type = "string"
default = "validator/keys:validator/passwords"  
priority = "low"
summary = ""

[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_LOG_FILE"]
type = "string"
default = "/var/lib/eth-node-testnet/teku-validator-logs/teku.log"  
priority = "low"
summary = ""

[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_VALIDATORS_PROPOSER_DEFAULT_FEE_RECIPIENT"]
type = "string"
default = "$BASE_CONFIG_VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS" 
priority = "low"
summary = ""

