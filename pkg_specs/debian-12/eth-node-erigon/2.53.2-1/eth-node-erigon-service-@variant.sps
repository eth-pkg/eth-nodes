name = "eth-node-erigon-service-@variant"
bin_package = "eth-node-erigon"
binary = "/usr/bin/erigon"
conf_param = "-config="
user = { group = true, create = { home = true } }
depends = ["eth-node-erigon-config-{variant}", "eth-node-service-{variant}", "eth-node-erigon"]
conflicts = ["eth-node-execution-client-service-{variant}"]
provides = ["eth-node-execution-client-service-{variant}"]
summary = "Service package for erigon"

[extra_groups."eth-node-service-{variant}"]
create=false

# Do not define default config in this file, as that would affect all the service packages
# Create a new config if you need a new configuration, but not modify this file
# alternative use dpkg-configure
# or override the value in the desired config package
