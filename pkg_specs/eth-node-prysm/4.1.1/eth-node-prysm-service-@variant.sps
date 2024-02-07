name = "eth-node-prysm-service-@variant"
bin_package = "eth-node-prysm"
binary = "/usr/bin/prysm-beacon-chain"
conf_param = "--{variant} --config-file="
user = { group = true, create = { home = true} }
depends = ["eth-node-prysm-config-{variant}", "eth-node-service-{variant}", "eth-node-prysm"]
conflicts = ["eth-node-execution-client-service-{variant}"]
provides = ["eth-node-execution-client-service-{variant}"]
summary = "Service package for prysm"

[extra_groups."eth-node-{variant}"]
create=false

# Do not define default config, as that would affect all the service packages
# Create a new config if you need a new configuration, but not modify this file
# alternativel use dpkg-configure
# or override the value in the desired config package
