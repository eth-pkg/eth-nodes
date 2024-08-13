name = "eth-node-mainnet-service-besu"
bin_package = "eth-node-config-besu"
binary = "/usr/bin/run-besu.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd /lib"]
provides = ["eth-node-mainnet-el-service"]
conflicts = ["eth-node-mainnet-el-service"]
depends=["eth-node-config-besu", "eth-node-mainnet-config"]
summary = "systemd service files for eth-node-besu using eth-node-config-besu and eth-node-mainnet-config"

# TODO debcrafter should do this
# [config."vars"]
# format = "plain"

# [config."vars.toml".ivars.base_dir]
# type = "path"
# file_type = "dir"
# create = { mode = 755, owner = "$service", group = "$service" }
# default = "/var/lib/eth-node-mainnet/besu"
# priority = "low"
# summary = "Node working directory"