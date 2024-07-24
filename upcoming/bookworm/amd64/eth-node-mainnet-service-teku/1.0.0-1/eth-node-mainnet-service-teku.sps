name = "eth-node-mainnet-service-teku"
bin_package = "eth-node-config-teku"
binary = "/usr/bin/run-teku.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd /lib"]
provides = ["eth-node-mainnet-cl-service"]
conflicts = ["eth-node-mainnet-cl-service"]
depends=["eth-node-config-teku", "eth-node-mainnet-config"]
summary = "systemd service files for eth-node-teku using eth-node-config-teku and eth-node-mainnet-config"
