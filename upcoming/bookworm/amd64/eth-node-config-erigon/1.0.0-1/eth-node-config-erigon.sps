name = "eth-node-config-erigon"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-el-config"]
suggests = []
depends=["eth-node-erigon"]
add_files = [
    "debian/scripts/run-erigon.sh /usr/lib/eth-node-config-erigon/bin/",
    "debian/conf.d /etc/eth-node-mainnet/erigon"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run erigon through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-erigon
By installing this package,
it will automatically it will install run-erigon.sh script and 
erigon minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up erigon. 
See eth-node-[network]-service-erigon package for how that is working.
"""
