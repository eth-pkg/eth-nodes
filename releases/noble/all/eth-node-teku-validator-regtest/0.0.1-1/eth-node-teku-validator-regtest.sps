name = "eth-node-teku-validator-regtest"
bin_package = "eth-node-teku"
binary = "/usr/lib/eth-node-teku-validator-regtest/run-teku-validator-service.sh"
user = { name = "eth-node-teku-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-teku-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/teku-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/teku-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-teku-validator-service.sh /usr/lib/eth-node-teku-validator-regtest/", 
    "debian/scripts/run-teku-validator.sh /usr/lib/eth-node-teku-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-teku-validator-regtest",
    "debian/tmp/eth-node-teku-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/teku-validator",
    "debian/validator/passwords /var/lib/eth-node-regtest/teku-validator",
]
provides = ["eth-node-regtest-validator"]
conflicts = ["eth-node-regtest-validator"]
depends=["eth-node-teku-regtest"]
summary = "validator service file for eth-node-teku for network: regtest"

[config."teku-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-teku-validator-regtest/postprocess.sh"]

[config."teku-validator.conf"]
format = "plain"


[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_BEACON_NODE_API_ENDPOINTS"]
type = "string"
default = "http://127.0.0.1:5052"  
priority = "low"
summary = ""

[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_DATA_BASE_PATH"]
type = "string"
default = "/var/lib/eth-node-regtest/teku-validator"  
priority = "low"
summary = ""

[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_VALIDATOR_KEYS"]
type = "string"
default = "/var/lib/eth-node-regtest/teku-validator/keys:/var/lib/eth-node-regtest/teku-validator/passwords"  
priority = "low"
summary = ""

[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_LOG_FILE"]
type = "string"
default = "/var/lib/eth-node-regtest/teku-validator/logs/teku.log"  
priority = "low"
summary = ""

[config."teku-validator.conf".ivars."TEKU_CLI_VALIDATOR_VALIDATORS_PROPOSER_DEFAULT_FEE_RECIPIENT"]
type = "string"
default = "$BASE_CONFIG_VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS" 
priority = "low"
summary = ""

