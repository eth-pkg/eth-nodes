name = "eth-node-mainnet-service-nimbus-eth2"
bin_package = "eth-node-mainnet-service-nimbus-eth2"
binary = "/usr/bin/run-nimbus-eth2.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd /lib"]
provides = ["eth-node-mainnet-cl-service"]
conflicts = ["eth-node-mainnet-cl-service"]
depends=["eth-node-config-nimbus-eth2", "eth-node-mainnet-config"]
summary = "systemd service files for eth-node-nimbus-eth2 using eth-node-config-nimbus-eth2 and eth-node-mainnet-config"
