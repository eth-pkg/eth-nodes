name = "eth-node-lighthouse-testnet"
bin_package = "eth-node-lighthouse"
binary = "/usr/lib/eth-node-lighthouse-testnet/run-lighthouse-service.sh"
user = { name = "eth-node-lighthouse-testnet", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-lighthouse-testnet
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
ReadWritePaths=/var/lib/eth-node-testnet/lighthouse
ReadOnlyPaths=/var/lib/eth-node-testnet
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-testnet/lighthouse
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lighthouse-service.sh /usr/lib/eth-node-lighthouse-testnet/", 
    "debian/scripts/run-lighthouse.sh /usr/lib/eth-node-lighthouse-testnet/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lighthouse-testnet",
    "debian/tmp/eth-node-lighthouse-testnet.service /lib/systemd/system/",
]
provides = ["eth-node-testnet-cl-service"]
conflicts = ["eth-node-testnet-cl-service"]
depends=["eth-node-testnet-config", "eth-node-testnet"]
summary = "service file for eth-node-lighthouse for network: testnet"

[config."lighthouse-testnet.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lighthouse-testnet/postprocess.sh"]

[config."lighthouse-testnet.conf"]
format = "plain"


[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_NETWORK"]
type = "string"
default = ""  
priority = "low"
summary = "Name of the Eth2 chain Lighthouse will sync and follow."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_DISABLE_DEPOSIT_CONTRACT_SYNC"]
type = "string"
default = "true"
priority = "low"
summary = "Explicitly disables syncing of deposit logs from the execution node. Useful if you intend to run a non-validating beacon node."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_CHECKPOINT_SYNC_URL"]
type = "string"
default = ""
priority = "low"
summary = "Set the remote beacon node HTTP endpoint to use for checkpoint sync."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_DATADIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/lighthouse"
priority = "low"
summary = "Used to specify a custom root data directory for Lighthouse keys and databases."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_EXECUTION_ENDPOINT"]
type = "string"
default = "$BASE_CONFIG_ENDPOINT_URL"
priority = "low"
summary = "Server endpoint for an execution layer JWT-authenticated HTTP JSON-RPC connection."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_EXECUTION_JWT"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "File path containing the hex-encoded JWT secret for the execution endpoint."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_TESTNET_DIR"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_TESTNET_DIR"
priority = "low"
summary = "Path to directory containing Eth2 testnet specs. Only effective if no existing database is present."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_BOOT_NODES"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENR"
priority = "low"
summary = "One or more comma-delimited base64-encoded ENRs to bootstrap the P2P network."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_DISABLE_ENR_AUTO_UPDATE"]
type = "string"
default = "true"
priority = "low"
summary = "Disables automatic updates of ENR IP/PORT with external peers, fixing them to the boot values."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_LISTEN_ADDRESS"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "The address Lighthouse will listen for UDP and TCP connections. Defaults to IPv4."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP"]
type = "string"
default = "true"
priority = "low"
summary = "Enable the RESTful HTTP API server."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP_ADDRESS"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "Set the listen address for the RESTful HTTP API server."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP_ALLOW_SYNC_STALLED"]
type = "string"
default = "true"
priority = "low"
summary = "Forces HTTP sync to indicate the node is synced when it's actually stalled. Useful for testnets."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_DISABLE_PACKET_FILTER"]
type = "string"
default = "true"
priority = "low"
summary = "Disables the discovery packet filter, useful for testing in smaller networks."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_SUGGESTED_FEE_RECIPIENT"]
type = "string"
default = "$BASE_CONFIG_VALIDATOR_SHARED_FEE_RECIPENT_ADDRESS"
priority = "low"
summary = "Emergency fallback fee recipient if not configured by the validator client."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_SUBSCRIBE_ALL_SUBNETS"]
type = "string"
default = "true"
priority = "low"
summary = "Subscribes to all subnets regardless of validator count. Marks node as long-lived for all subnets."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_ENABLE_PRIVATE_DISCOVERY"]
type = "string"
default = "true"
priority = "low"
summary = "Enables connection attempts to private IP addresses for local discovery."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP_PORT"]
type = "string"
default = "$BASE_CONFIG_CL_RPC_PORT"
priority = "low"
summary = "Sets the port for the RESTful HTTP API server."

[config."lighthouse-testnet.conf".ivars."LIGHTHOUSE_CLI_BN_HTTP_ALLOW_ORIGIN"]
type = "string"
default = "*"
priority = "low"
summary = "Allows all origins for HTTP connections. Useful for testing."
