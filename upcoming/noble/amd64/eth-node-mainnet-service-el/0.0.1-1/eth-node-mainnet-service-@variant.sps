name = "eth-node-mainnet-service-@variant"
bin_package = "eth-node-config-mainnet-@variant"
binary = "/usr/bin/run-{variant}.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd/system/eth-node-mainnet-service-{variant}.service /lib/systemd/system/"]
provides = ["eth-node-mainnet-el-service"]
conflicts = ["eth-node-mainnet-el-service"]
depends=["eth-node-config-mainnet-{variant}", "eth-node-mainnet-config"]
summary = "systemd service files for eth-node-besu using eth-node-config-mainnet-{variant} and eth-node-mainnet-config"

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