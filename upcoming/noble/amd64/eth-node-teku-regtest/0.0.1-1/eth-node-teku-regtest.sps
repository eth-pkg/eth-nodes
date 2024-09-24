name = "eth-node-teku-regtest"
bin_package = "eth-node-teku"
binary = "/usr/lib/eth-node-teku-regtest/run-teku-service.sh"
user = { name = "eth-node-teku-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-teku-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/teku
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/teku
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-teku-service.sh /usr/lib/eth-node-teku-regtest/", 
    "debian/scripts/run-teku.sh /usr/lib/eth-node-teku-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-teku-regtest",
    "debian/tmp/eth-node-teku-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config", "eth-node-regtest"]
summary = "service file for eth-node-teku for network: regtest"

[config."teku-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-teku-regtest/postprocess.sh"]

[config."teku-regtest.conf"]
format = "plain"

[config."teku-regtest.conf".ivars."TEKU_CLI_EE_ENDPOINT"]
type = "string"
default = "$BASE_CONFIG_ENDPOINT_URL"
priority = "low"
summary = "URL for Execution Engine node."

[config."teku-regtest.conf".ivars."TEKU_CLI_EE_JWT_SECRET_FILE"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "Location of the file specifying the hex-encoded 256-bit secret key to be used for verifying/generating JWT tokens."

[config."teku-regtest.conf".ivars."TEKU_CLI_CHECKPOINT_SYNC_URL"]
type = "string"
default = ""
priority = "low"
summary = "The Checkpointz server that will be used to bootstrap this node."

[config."teku-regtest.conf".ivars."TEKU_CLI_DATA_BASE_PATH"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/teku"
priority = "low"
summary = "Path to the base directory for storage. Default: $HOME/.local/share/teku."

[config."teku-regtest.conf".ivars."TEKU_CLI_NETWORK"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_regtest_DIR/config.yaml"
priority = "low"
summary = "Represents which network to use. Default: mainnet."

[config."teku-regtest.conf".ivars."TEKU_CLI_P2P_DISCOVERY_BOOTNODES"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENR"
priority = "low"
summary = "List of ENRs of the bootnodes."

[config."teku-regtest.conf".ivars."TEKU_CLI_GENESIS_STATE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_GENESIS_STATE"
priority = "low"
summary = "The genesis state. This value should be a file or URL pointing to an SSZ-encoded finalized checkpoint state."

[config."teku-regtest.conf".ivars."TEKU_CLI_IGNORE_WEAK_SUBJECTIVITY_PERIOD_ENABLED"]
type = "string"
default = "true"
priority = "low"
summary = "Allows syncing outside of the weak subjectivity period. Default: false."

[config."teku-regtest.conf".ivars."TEKU_CLI_REST_API_CORS_ORIGINS"]
type = "string"
default = "[]"
priority = "low"
summary = "Comma-separated list of origins to allow, or * to allow any origin. Default: []."

[config."teku-regtest.conf".ivars."TEKU_CLI_REST_API_DOCS_ENABLED"]
type = "string"
default = "false"
priority = "low"
summary = "Enable swagger-docs and swagger-ui endpoints. Default: false."

[config."teku-regtest.conf".ivars."TEKU_CLI_REST_API_ENABLED"]
type = "string"
default = "true"
priority = "low"
summary = "Enables Beacon Rest API. Default: null."

[config."teku-regtest.conf".ivars."TEKU_CLI_REST_API_HOST_ALLOWLIST"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of hostnames to allow, or * to allow any host. Default: [127.0.0.1, localhost]."

[config."teku-regtest.conf".ivars."TEKU_CLI_REST_API_INTERFACE"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Interface of Beacon Rest API. Default: 127.0.0.1."

[config."teku-regtest.conf".ivars."TEKU_CLI_REST_API_PORT"]
type = "string"
default = "$BASE_CONFIG_CL_RPC_PORT"
priority = "low"
summary = "Port number of Beacon Rest API."
