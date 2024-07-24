name = "eth-node-mainnet-config-lodestar"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-cl-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-lodestar.sh /usr/lib/eth-node-mainnet-config-lodestar/bin/",
    "debian/conf.d /etc/eth-node-mainnet/lodestar"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run lodestar through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-mainnet-config-lodestar
By installing this package,
it will automatically it will install run-lodestar.sh script and 
lodestar minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up lodestar. 
See eth-node-[network]-service-lodestar package for how that is working.
"""