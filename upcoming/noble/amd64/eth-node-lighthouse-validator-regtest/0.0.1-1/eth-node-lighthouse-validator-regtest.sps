name = "eth-node-lighthouse-validator-regtest"
bin_package = "eth-node-lighthouse"
binary = "/usr/lib/eth-node-lighthouse-validator-regtest/run-lighthouse-validator-service.sh"
user = { name = "eth-node-lighthouse-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-lighthouse-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/lighthouse-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/lighthouse-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-lighthouse-validator-service.sh /usr/lib/eth-node-lighthouse-validator-regtest/", 
    "debian/scripts/run-lighthouse-validator.sh /usr/lib/eth-node-lighthouse-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lighthouse-validator-regtest",
    "debian/tmp/eth-node-lighthouse-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/lighthouse-validator",
    "debian/validator/passwords /var/lib/eth-node-regtest/lighthouse-validator",
]
provides = ["eth-node-regtest-validator"]
conflicts = ["eth-node-regtest-validator"]
depends=["eth-node-lighthouse-regtest"]
summary = "validator service file for eth-node-lighthouse for network: regtest"

[config."lighthouse-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-lighthouse-validator-regtest/postprocess.sh"]

[config."lighthouse-validator.conf"]
format = "plain"


[config."lighthouse-validator.conf".ivars."LIGHTHOUSE_CLI_VALIDATOR_TESTNET_DIR"]
type = "string"
default = "$BASE_CONFIG_CUSTOM_NETWORK_TESTNET_DIR"
priority = "low"
summary = "Path to directory containing Eth2 regtest specs. Only effective if no existing database is present."


[config."lighthouse-validator.conf".ivars."LIGHTHOUSE_CLI_VALIDATOR_VALIDATORS_DIR"]
type = "string"
default = "/var/lib/eth-node-regtest/lighthouse-validator"
priority = "low"
summary = "Path to validators dir"

