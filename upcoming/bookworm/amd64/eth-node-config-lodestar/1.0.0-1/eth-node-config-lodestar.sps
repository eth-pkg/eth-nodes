name = "eth-node-config-lodestar"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-cl-config"]
suggests = []
depends=["eth-node-lodestar"]
add_files = [
    "debian/scripts/run-lodestar.sh /usr/lib/eth-node-config-lodestar/bin/",
    "debian/conf.d/lodestar-mainnet.conf /etc/eth-node-mainnet/lodestar/conf.d/"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run lodestar through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-lodestar
By installing this package,
it will automatically it will install run-lodestar.sh script and 
lodestar minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up lodestar. 
See eth-node-[network]-service-lodestar package for how that is working.
"""