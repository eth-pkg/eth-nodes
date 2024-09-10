name = "eth-node-nimbus-eth2-testnet"
bin_package = "eth-node-config-nimbus-eth2-testnet"
binary = "/usr/lib/eth-node-config-testnet/bin/run-nimbus-eth2.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd/system/eth-node-nimbus-eth2-testnet.service /lib/systemd/system/"]
provides = ["eth-node-testnet-cl-service"]
conflicts = ["eth-node-testnet-cl-service"]
depends=["eth-node-config-nimbus-eth2-testnet", "eth-node-testnet-config", "eth-node-testnet"]
summary = "systemd service files for eth-node-nimbus-eth2 using eth-node-config-nimbus-eth2-testnet and eth-node-testnet-config"

# TODO debcrafter should do this
# [config."vars"]
# format = "plain"

# [config."vars.toml".ivars.base_dir]
# type = "path"
# file_type = "dir"
# create = { mode = 755, owner = "$service", group = "$service" }
# default = "/var/lib/eth-node-testnet/besu"
# priority = "low"
# summary = "Node working directory"