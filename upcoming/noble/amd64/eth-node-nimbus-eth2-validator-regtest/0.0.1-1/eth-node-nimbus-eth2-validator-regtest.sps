name = "eth-node-nimbus-eth2-validator-regtest"
bin_package = "eth-node-nimbus-eth2"
binary = "/usr/lib/eth-node-nimbus-eth2-validator-regtest/run-nimbus-eth2-validator-service.sh"
user = { name = "eth-node-nimbus-eth2-val-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
User=eth-node-nimbus-eth2-val-regtest
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
ReadWritePaths=/var/lib/eth-node-regtest/nimbus-eth2-validator
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/nimbus-eth2-validator
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    "debian/scripts/run-nimbus-eth2-validator-service.sh /usr/lib/eth-node-nimbus-eth2-validator-regtest/", 
    "debian/scripts/run-nimbus-eth2-validator.sh /usr/lib/eth-node-nimbus-eth2-validator-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-nimbus-eth2-validator-regtest",
    "debian/tmp/eth-node-nimbus-eth2-validator-regtest.service /lib/systemd/system/",
    "debian/validator/keys /var/lib/eth-node-regtest/nimbus-eth2-validator",
    "debian/validator/passwords /var/lib/eth-node-regtest/nimbus-eth2-validator",
]
provides = ["eth-node-regtest-validator"]
conflicts = ["eth-node-regtest-validator"]
depends=["eth-node-nimbus-eth2-regtest"]
summary = "validator service file for eth-node-nimbus-eth2 for network: regtest"

[config."nimbus-eth2-validator.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-nimbus-eth2-validator-regtest/postprocess.sh"]

[config."nimbus-eth2-validator.conf"]
format = "plain"

[config."nimbus-eth2-validator.conf".ivars."NIMBUS_ETH2_CLI_VALIDATOR_DATADIR"]
type = "string"
default = "$BASE_CONFIG_DATA_DIR/nimbus-eth2-validator/validator"
priority = "low"
summary = "Specifies the directory where Nimbus will store all blockchain data."