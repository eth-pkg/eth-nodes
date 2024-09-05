name = "eth-node-testnet-service-prysm"
bin_package = "eth-node-config-testnet-prysm"
binary = "/usr/lib/eth-node-config-testnet/bin/run-prysm.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd/system/eth-node-testnet-service-lighhtouse.service /lib/systemd/system/"]
provides = ["eth-node-testnet-cl-service"]
conflicts = ["eth-node-testnet-cl-service"]
depends=["eth-node-config-testnet-prysm", "eth-node-testnet-config", "eth-node-testnet"]
summary = "systemd service files for eth-node-prysm using eth-node-config-testnet-prysm and eth-node-testnet-config"

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