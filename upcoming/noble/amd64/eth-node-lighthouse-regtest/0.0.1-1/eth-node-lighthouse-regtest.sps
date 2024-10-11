name = "eth-node-lighthouse-regtest"
bin_package = "eth-node-lighthouse"
binary = "/usr/lib/eth-node-lighthouse-regtest/run-lighthouse-service.sh"
user = { name = "eth-node-lighthouse-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-lighthouse-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/lighthouse
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/lighthouse
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lighthouse-service.sh /usr/lib/eth-node-lighthouse-regtest/", 
    "debian/scripts/run-lighthouse.sh /usr/lib/eth-node-lighthouse-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lighthouse-regtest",
    "debian/tmp/eth-node-lighthouse-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config", "eth-node-regtest"]
summary = "service file for eth-node-lighthouse for network: regtest"

[config."lighthouse-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lighthouse-regtest/postprocess.sh"]

[config."lighthouse-regtest.conf"]
format = "plain"


[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_NETWORK"]
type = "string"
default = ""  
priority = "low"
summary = "Name of the Eth2 chain Lighthouse will sync and follow."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_DISABLE_DEPOSIT_CONTRACT_SYNC"]
type = "string"
default = "true"
priority = "low"
summary = "Explicitly disables syncing of deposit logs from the execution node. Useful if you intend to run a non-validating beacon node."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_CHECKPOINT_SYNC_URL"]
type = "string"
default = ""
priority = "low"
summary = "Set the remote beacon node HTTP endpoint to use for checkpoint sync."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_DATADIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/lighthouse"
priority = "low"
summary = "Used to specify a custom root data directory for Lighthouse keys and databases."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_EXECUTION_ENDPOINT"]
type = "string"
default = "$BASE_CONFIG_ENDPOINT_URL"
priority = "low"
summary = "Server endpoint for an execution layer JWT-authenticated HTTP JSON-RPC connection."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_EXECUTION_JWT"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "File path containing the hex-encoded JWT secret for the execution endpoint."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_TESTNET_DIR"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_TESTNET_DIR"
priority = "low"
summary = "Path to directory containing Eth2 regtest specs. Only effective if no existing database is present."

# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_BOOT_NODES"]
# type = "string"
# default = "$BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENR"
# priority = "low"
# summary = "One or more comma-delimited base64-encoded ENRs to bootstrap the P2P network."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_DISABLE_ENR_AUTO_UPDATE"]
type = "string"
default = "true"
priority = "low"
summary = "Disables automatic updates of ENR IP/PORT with external peers, fixing them to the boot values."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_LISTEN_ADDRESS"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "The address Lighthouse will listen for UDP and TCP connections. Defaults to IPv4."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the RESTful HTTP API server."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP_ADDRESS"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Set the listen address for the RESTful HTTP API server."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP_ALLOW_SYNC_STALLED"]
type = "string"
default = "true"
priority = "low"
summary = "Forces HTTP sync to indicate the node is synced when it's actually stalled. Useful for regtests."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_DISABLE_PACKET_FILTER"]
type = "string"
default = "true"
priority = "low"
summary = "Disables the discovery packet filter, useful for testing in smaller networks."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_SUGGESTED_FEE_RECIPIENT"]
type = "string"
default = "$BASE_CONFIG_VALIDATOR_SHARED_FEE_RECIPENT_ADDRESS"
priority = "low"
summary = "Emergency fallback fee recipient if not configured by the validator client."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_SUBSCRIBE_ALL_SUBNETS"]
type = "string"
default = "true"
priority = "low"
summary = "Subscribes to all subnets regardless of validator count. Marks node as long-lived for all subnets."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_ENABLE_PRIVATE_DISCOVERY"]
type = "string"
default = "true"
priority = "low"
summary = "Enables connection attempts to private IP addresses for local discovery."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP_PORT"]
type = "string"
default = "$BASE_CONFIG_CL_RPC_PORT"
priority = "low"
summary = "Sets the port for the RESTful HTTP API server."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP_ALLOW_ORIGIN"]
type = "string"
default = "*"
priority = "low"
summary = "Allows all origins for HTTP connections. Useful for testing."

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_DISABLE_PEER_SCORING"]
type = "string"
default = "true"
priority = "low"
summary = ""

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_STAKING"]
type = "string"
default = "true"
priority = "low"
summary = ""

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_SLOTS_PER_RESTORE_POINT"]
type = "string"
default = "8192"
priority = "low"
summary = ""

[config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_ALLOW_INSECURE_GENESIS_SYNC"]
type = "string"
default = "true"
priority = "low"
summary = ""


# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_SYNC_STALLED"]
# type = "string"
# default = "true"
# priority = "low"
# summary = ""

# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_ENR_ADDRESS"]
# type = "string"
# default = "127.0.0.1"
# priority = "low"
# summary = ""

# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_ENR_UDP_PORT"]
# type = "string"
# default = "9000"
# priority = "low"
# summary = ""

# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_ENR_TCP_PORT"]
# type = "string"
# default = "9000"
# priority = "low"
# summary = ""

# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_ENR_QUIC_PORT"]
# type = "string"
# default = "9100"
# priority = "low"
# summary = ""

# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_PORT"]
# type = "string"
# default = "9000"
# priority = "low"
# summary = ""

# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_QUIC_PORT"]
# type = "string"
# default = "9100"
# priority = "low"
# summary = ""

# [config."lighthouse-regtest.conf".ivars."LIGHTHOUSE_CLI_BN_TARGET_PEERS"]
# type = "string"
# default = "0"
# priority = "low"
# summary = ""