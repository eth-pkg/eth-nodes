name = "eth-node-prysm-validator-regtest"
bin_package = "eth-node-prysm"
binary = "/usr/lib/eth-node-prysm-validator-regtest/run-prysm-validator-service.sh"
user = { name = "eth-node-prysm-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-prysm-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/prysm-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/prysm-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-prysm-validator-service.sh /usr/lib/eth-node-prysm-validator-regtest/", 
    "debian/scripts/run-prysm-validator.sh /usr/lib/eth-node-prysm-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-prysm-validator-regtest",
    "debian/tmp/eth-node-prysm-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/prysm-validator",
    "debian/validator/passwords /var/lib/eth-node-regtest/prysm-validator",
    "debian/validator/dummy_account_password.txt /var/lib/eth-node-regtest/prysm-validator",
    "debian/validator/dummy_wallet_password.txt /var/lib/eth-node-regtest/prysm-validator",
]
provides = ["eth-node-regtest-validator"]
conflicts = ["eth-node-regtest-validator"]
depends=["eth-node-regtest-cl-service"]
summary = "validator service file for eth-node-prysm for network: regtest"

[config."prysm-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-prysm-validator-regtest/postprocess.sh"]

[config."prysm-validator.conf"]
format = "plain"

[config."prysm-validator.conf".ivars."PRYSM_CLI_VALIDATOR_DATADIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/prysm-validator"
priority = "low"
summary = "Data directory for the databases."

[config."prysm-validator.conf".ivars."PRYSM_CLI_VALIDATOR_ACCEPT_TERMS_OF_USE"]
type = "string"
default = "true"
priority = "low"
summary = "Accepts Terms and Conditions for non-interactive environments."

[config."prysm-validator.conf".ivars."PRYSM_CLI_VALIDATOR_WALLET_DIR"]
type = "string"
default = "/var/lib/eth-node-regtest/prysm-validator"
priority = "low"
summary = ""

[config."prysm-validator.conf".ivars."PRYSM_CLI_VALIDATOR_WALLET_PASSWORD_FILE"]
type = "string"
default = "/var/lib/eth-node-regtest/prysm-validator/dummy_wallet_password.txt"
priority = "low"
summary = ""

[config."prysm-validator.conf".ivars."PRYSM_CLI_VALIDATOR_ACCOUNT_PASSWORD_FILE"]
type = "string"
default = "/var/lib/eth-node-regtest/prysm-validator/passwords/keystore-m_12381_3600_0_0_0-1726217560.txt"
priority = "low"
summary = ""

[config."prysm-validator.conf".ivars."PRYSM_CLI_VALIDATOR_WALLET_KEYSTORE"]
type = "string"
default = "/var/lib/eth-node-regtest/prysm-validator/keys"
priority = "low"
summary = ""

[config."prysm-validator.conf".ivars."PRYSM_CLI_VALIDATOR_CHAIN_CONFIG_FILE"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_TESTNET_DIR/config.yaml"
priority = "low"
summary = "Path to a YAML file with chain config values."