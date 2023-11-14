name = "eth-node-service-@variant"
architecture = "any"
summary = "Configuration for Ethereum clients shared for {variant}"
conflicts = []
recommends = ["eth-node-{variant}"]
provides = []
suggests = []
depends = []
add_files = ["postprocess.sh /etc/lib/eth-node-service-{variant}"]
add_manpages = []
long_doc = """eth-node-service-{variant}

Essential shared configuration shared by Ethereum clients, 
that are not owned by one client but shared between them.

If you wish to define configuration values that need to used 
by different clients, and if changes must be reflected in others 
clients as well, you must add configuration value to this package,
and reference the config values from the dependent package.
"""

[config."config.toml"]
format="toml"

[config."config.toml".ivars."jwtsecret"]
summary = "Path to jwt secret"
default = "/data/jwt/{variant}/jwt.hex"
type = "path"
file_type = "regular"
priority = "medium"

[config."config.toml".ivars.datadir]
summary = "Data dir"
type = "path"
file_type = "dir"
default = "/data/{variant}"
priority = "medium"

[config."config.toml".postprocess]
command = ["bash", "/etc/eth-node-service-{variant}/postprocess.sh", "{variant}"]

