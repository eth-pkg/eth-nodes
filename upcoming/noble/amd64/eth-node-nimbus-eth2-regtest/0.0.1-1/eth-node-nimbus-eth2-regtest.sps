name = "eth-node-nimbus-eth2-regtest"
bin_package = "eth-node-nimbus-eth2"
binary = "/usr/lib/eth-node-nimbus-eth2-regtest/run-nimbus-eth2-service.sh"
user = { name = "eth-node-nimbus-eth2-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-nimbus-eth2-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/nimbus-eth2
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/nimbus-eth2
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-nimbus-eth2-service.sh /usr/lib/eth-node-nimbus-eth2-regtest/", 
    "debian/scripts/run-nimbus-eth2.sh /usr/lib/eth-node-nimbus-eth2-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-nimbus-eth2-regtest",
    "debian/tmp/eth-node-nimbus-eth2-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config", "eth-node-regtest"]
summary = "service file for eth-node-nimbus-eth2 for network: regtest"

[config."nimbus-eth2-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-nimbus-eth2-regtest/postprocess.sh"]

[config."nimbus-eth2-regtest.conf"]
format = "plain"

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_NON_INTERACTIVE"]
type = "string"
default = "true"
priority = "low"
summary = "Sets non-interactive mode for Nimbus, meaning it will quit on missing configuration."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_NETWORK"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_regtest_DIR"
priority = "low"
summary = "Specifies the Eth2 network to join, typically regtest."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_DATA_DIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/nimbus-eth2"
priority = "low"
summary = "Specifies the directory where Nimbus will store all blockchain data."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_WEB3_URL"]
type = "string"
default = "$BASE_CONFIG_ENDPOINT_URL"
priority = "low"
summary = "Specifies one or more execution layer Engine API URLs."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_JWT_SECRET"]
type = "string"
default = "$BASE_CONFIG_SECRETS_FILE"
priority = "low"
summary = "Points to a file containing the hex-encoded 256-bit secret key used for JWT token verification/generation."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_NAT"]
type = "string"
default = ""
priority = "low"
summary = "Specifies the method to determine the public address for the node, such as any, none, upnp, pmp, or extip."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_ENR_AUTO_UPDATE"]
type = "string"
default = "false"
priority = "low"
summary = "Determines whether ENR auto-update functionality is enabled or disabled."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_DOPPELGANGER_DETECTION"]
type = "string"
default = "false"
priority = "low"
summary = "Determines whether doppelganger detection is enabled (to avoid slashing)."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_SUBSCRIBE_ALL_SUBNETS"]
type = "string"
default = "true"
priority = "low"
summary = "Determines whether the node subscribes to all subnet topics for gossiping."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_REST"]
type = "string"
default = "true"
priority = "low"
summary = "Enables or disables the REST server for Nimbus."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_REST_PORT"]
type = "string"
default = "$BASE_CONFIG_CL_RPC_PORT"
priority = "low"
summary = "Specifies the port number for the REST server."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_REST_ADDRESS"]
type = "string"
default = ""
priority = "low"
summary = "Sets the listening address of the REST server."

[config."nimbus-eth2-regtest.conf".ivars."NIMBUS_ETH2_REST_ALLOW_ORIGIN"]
type = "string"
default = ""
priority = "low"
summary = "Limits access to the REST API to a specific hostname for CORS-enabled clients, such as browsers."
