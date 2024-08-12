name = "eth-node-config-geth"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-el-config"]
suggests = []
depends=["eth-node-geth"]
add_files = [
    "debian/scripts/run-geth.sh /usr/lib/eth-node-config-geth/bin/",
    "debian/conf.d/geth-mainnet.conf /etc/eth-node-mainnet/geth/conf.d/"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run geth through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-geth
By installing this package,
it will automatically it will install run-geth.sh script and 
geth minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up geth. 
See eth-node-[network]-service-geth package for how that is working.
"""
