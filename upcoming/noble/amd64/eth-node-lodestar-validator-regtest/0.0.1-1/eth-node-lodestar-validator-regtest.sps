name = "eth-node-lodestar-validator-regtest"
bin_package = "eth-node-lodestar"
binary = "/usr/lib/eth-node-lodestar-validator-regtest/run-lodestar-validator-service.sh"
user = { name = "eth-node-lodestar-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-lodestar-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/lodestar-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
# SystemCallArchitectures=native
# SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/lodestar-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lodestar-validator-service.sh /usr/lib/eth-node-lodestar-validator-regtest/", 
    "debian/scripts/run-lodestar-validator.sh /usr/lib/eth-node-lodestar-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lodestar-validator-regtest",
    "debian/tmp/eth-node-lodestar-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/lodestar-validator",
    "debian/validator/passwords /var/lib/eth-node-regtest/lodestar-validator",
]
provides = ["eth-node-regtest-validator"]
conflicts = ["eth-node-regtest-validator"]
depends=["eth-node-lodestar-regtest"]
summary = "validator service file for eth-node-lodestar for network: regtest"

[config."lodestar-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lodestar-validator-regtest/postprocess.sh"]

[config."lodestar-validator.conf"]
format = "plain"


[config."lodestar-validator.conf".ivars."LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR"]
type = "string"
default = "/var/lib/eth-node-regtest/lodestar-validator"
priority = "low"
summary = "Path to validators dir"

[config."lodestar-validator.conf".ivars."LODESTAR_CLI_VALIDATOR_PARAMSFILE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_CHAINCONFIG"
priority = "low"
summary = "Network configuration file"

[config."lodestar-validator.conf".ivars."LODESTAR_CLI_VALIDATOR_BEACONNODES"]
type = "string"
default = "http://127.0.0.1:$BASE_CONFIG_CL_RPC_PORT"
priority = "low"
summary = "Bootnodes for discv5 discovery"

[config."lodestar-validator.conf".ivars."LODESTAR_CLI_VALIDATOR_USEPRODUCEBLOCKV3"]
type = "string"
default = "true"
priority = "low"
summary = ""

[config."lodestar-validator.conf".ivars."LODESTAR_CLI_VALIDATOR_IMPORTKEYSTORES"]
type = "string"
default = "/var/lib/eth-node-regtest/lodestar-validator/keys"
priority = "low"
summary = ""

[config."lodestar-validator.conf".ivars."LODESTAR_CLI_VALIDATOR_IMPORTKEYSTORESPASSWORD"]
type = "string"
default = "/var/lib/eth-node-regtest/lodestar-validator/passwords/keystore-m_12381_3600_0_0_0-1728531488.txt"
priority = "low"
summary = ""

[config."lodestar-validator.conf".ivars."LODESTAR_CLI_DISABLE_KEYSTORES_THREADPOOL"]
type = "string"
default = "true"
priority = "low"
summary = ""

[config."lodestar-validator.conf".ivars."LODESTAR_CLI_VALIDATOR_DATADIR"]
type = "string"
default = "/var/lib/eth-node-regtest/lodestar-validator"
priority = "low"
summary = ""

[config."lodestar-validator.conf".ivars."LODESTAR_CLI_VALIDATOR_SUGGESTEDFEERECIPIENT"]
type = "string"
default = "$BASE_CONFIG_VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = ""

