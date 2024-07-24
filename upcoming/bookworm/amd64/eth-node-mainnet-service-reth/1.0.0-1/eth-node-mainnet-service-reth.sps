name = "eth-node-mainnet-service-reth"
bin_package = "eth-node-mainnet-config-reth"
binary = "/usr/bin/run-reth.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd /lib"]
provides = ["eth-node-mainnet-el-service"]
conflicts = ["eth-node-mainnet-el-service"]
depends=["eth-node-mainnet-config-reth", "eth-node-mainnet-config"]
summary = "systemd service files for eth-node-reth using eth-node-mainnet-config-reth and eth-node-mainnet-config"

# TODO debcrafter should do this
# [config."vars"]
# format = "plain"

# [config."vars.toml".ivars.base_dir]
# type = "path"
# file_type = "dir"
# create = { mode = 755, owner = "$service", group = "$service" }
# default = "/var/lib/eth-node-mainnet/reth"
# priority = "low"
# summary = "Node working directory"