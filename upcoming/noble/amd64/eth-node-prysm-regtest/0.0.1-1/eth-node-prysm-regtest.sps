name = "eth-node-prysm-regtest"
bin_package = "eth-node-prysm"
binary = "/usr/lib/eth-node-prysm-regtest/run-prysm-service.sh"
user = { name = "eth-node-prysm-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-prysm-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/prysm
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/prysm
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-prysm-service.sh /usr/lib/eth-node-prysm-regtest/", 
    "debian/scripts/run-prysm.sh /usr/lib/eth-node-prysm-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-prysm-regtest",
    "debian/tmp/eth-node-prysm-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config", "eth-node-regtest"]
summary = "service file for eth-node-prysm for network: regtest"

[config."prysm-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-prysm-regtest/postprocess.sh"]

[config."prysm-regtest.conf"]
format = "plain"

[config."prysm-regtest.conf".ivars."PRSYM_CLI_EXECUTION_ENDPOINT"]
type = "string"
default = "$BASE_CONFIG_ENDPOINT_URL"
priority = "low"
summary = "An execution client HTTP endpoint. Can contain auth header as well in the format (default: 'http://localhost:8551')."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_MAINNET"]
type = "string"
default = "false"
priority = "low"
summary = "Runs on Ethereum main network. This is the default and can be omitted."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_SEPOLIA"]
type = "string"
default = "false"
priority = "low"
summary = "Runs Prysm configured for the Sepolia test network."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_CHAIN_ID"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_NETWORK_ID"
priority = "low"
summary = "Sets the chain ID of the beacon chain."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_JWT_SECRET"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "Provides a path to a file containing a hex-encoded string representing a 32-byte secret used for authentication with an execution node via HTTP."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_CHECKPOINT_SYNC_URL"]
type = "string"
default = "$BASE_CONFIG_CL_CHECKPPOINT_SYNC_URL"
priority = "low"
summary = "URL of a synced beacon node to trust in obtaining checkpoint sync data."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_GENESIS_BEACON_API_URL"]
type = "string"
default = "$BASE_CONFIG_CL_BEACON_API_URL"
priority = "low"
summary = "URL of a synced beacon node to trust for obtaining genesis state."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_ACCEPT_TERMS_OF_USE"]
type = "string"
default = "true"
priority = "low"
summary = "Accepts Terms and Conditions for non-interactive environments."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_DATADIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/prysm"
priority = "low"
summary = "Data directory for the databases."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_GENESIS_STATE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_GENESIS_STATE"
priority = "low"
summary = "Load a genesis state from ssz file."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_BOOTSTRAP_NODE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENR"
priority = "low"
summary = "The address of a bootstrap node for peer discovery via DHT."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_MINIMUM_PEERS_PER_SUBNET"]
type = "string"
default = "0"
priority = "low"
summary = "Sets the minimum number of peers that a node will attempt to peer with that are subscribed to a subnet."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_INTEROP_ETH1DATA_VOTES"]
type = "string"
default = "true"
priority = "low"
summary = "Enable mocking of eth1 data votes for proposers to package into blocks."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_CONTRACT_DEPLOYMENT_BLOCK"]
type = "string"
default = "0"
priority = "low"
summary = "The eth1 block in which the deposit contract was deployed."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_MIN_SYNC_PEERS"]
type = "string"
default = "0"
priority = "low"
summary = "The required number of valid peers to connect with before syncing."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_CHAIN_CONFIG_FILE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_regtest_DIR/config.yaml"
priority = "low"
summary = "Path to a YAML file with chain config values."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_DISABLE_GRPC_GATEWAY"]
type = "string"
default = "false"
priority = "low"
summary = "Disable the gRPC gateway for JSON-HTTP requests."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_GRPC_GATEWAY_CORSDOMAIN"]
type = "string"
default = ""
priority = "low"
summary = "Comma-separated list of domains from which to accept cross-origin requests."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_GRPC_GATEWAY_HOST"]
type = "string"
default = ""
priority = "low"
summary = "The host on which the gRPC gateway server runs on."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_GRPC_GATEWAY_PORT"]
type = "string"
default = "$BASE_CONFIG_CL_RPC_PORT"
priority = "low"
summary = "The port on which the gRPC gateway server runs."

[config."prysm-regtest.conf".ivars."PRSYM_CLI_HTTP_MODULES"]
type = "string"
default = "eth"
priority = "low"
summary = "Comma-separated list of API module names."