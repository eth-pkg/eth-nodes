name = "eth-node-lodestar-regtest"
bin_package = "eth-node-lodestar"
binary = "/usr/lib/eth-node-lodestar-regtest/run-lodestar-service.sh"
user = { name = "eth-node-lodestar-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-lodestar-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/lodestar
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
# TODO: this specially not working with only lodestar
# SystemCallFilter=@system-service
# does not work with lodestar as well
#SystemCallFilter=~@privileged @resources @obsolete
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/lodestar
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lodestar-service.sh /usr/lib/eth-node-lodestar-regtest/", 
    "debian/scripts/run-lodestar.sh /usr/lib/eth-node-lodestar-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lodestar-regtest",
    "debian/tmp/eth-node-lodestar-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config", "eth-node-regtest"]
summary = "service file for eth-node-lodestar for network: regtest"

[config."lodestar-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lodestar-regtest/postprocess.sh"]

[config."lodestar-regtest.conf"]
format = "plain"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_DATA_DIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/lodestar"
priority = "low"
summary = "Lodestar root data directory"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_ETH1_DEPOSIT_CONTRACT_DEPLOY_BLOCK"]
type = "string"
default = "0"
priority = "low"
summary = "Eth1 deposit contract deploy block number"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_NETWORK_CONNECT_TO_DISCV5_BOOTNODES"]
type = "string"
default = "false"
priority = "low"
summary = "Whether to connect to discv5 bootnodes"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_DEV_DISCV5"]
type = "string"
default = "true"
priority = "low"
summary = "Enable discv5 discovery"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_ETH1"]
type = "string"
default = "true"
priority = "low"
summary = "Follow the Eth1 chain"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_ETH1_PROVIDER_URLS"]
type = "string"
default = ""
priority = "low"
summary = "URLs to Eth1 node with enabled RPC"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_REST"]
type = "string"
default = "true"
priority = "low"
summary = "Enable HTTP API"

# [config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_REST_NAMESPACE"]
# type = "string"
# default = "localhost"
# priority = "low"
# summary = "Pick namespaces to expose for HTTP API"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_REST_ADDRESS"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Set host for HTTP API"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_NAT"]
type = "string"
default = "true"
priority = "low"
summary = "Allow non-local addresses configuration"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_SUBSCRIBE_ALL_SUBNETS"]
type = "string"
default = "true"
priority = "low"
summary = "Subscribe to all subnets regardless of validator count"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_JWT_SECRET"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "Path to shared JWT secret for authentication with EL client's RPC server"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_PARAMS_FILE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_CHAINCONFIG"
priority = "low"
summary = "Network configuration file"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_GENSIS_STATE_FILE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_GENESIS_STATE"
priority = "low"
summary = "Genesis state file for custom network"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_DEV_BOOTNODES"]
type = "string"
default = ""
priority = "low"
summary = "Bootnodes for discv5 discovery"


# [config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_REST_NAMESPACE"]
# type = "string"
# default = "eth"
# priority = "low"
# summary = "Pick namespaces to expose for HTTP API"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_REST_PORT"]
type = "string"
default = "$BASE_CONFIG_CL_RPC_PORT"
priority = "low"
summary = "Set port for HTTP API (custom config)"

[config."lodestar-regtest.conf".ivars."LODESTAR_CLI_BN_SUGGESTED_FEE_RECIPIENT"]
type = "string"
default = "$BASE_CONFIG_VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"
priority = "low"
summary = ""