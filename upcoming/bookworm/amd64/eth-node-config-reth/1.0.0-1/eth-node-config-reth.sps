name = "eth-node-config-reth"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-el-config"]
suggests = []
depends=["eth-node-reth"]
add_files = [
    "debian/scripts/run-reth.sh /usr/lib/eth-node-config-reth/bin/",
    "debian/conf.d /etc/eth-node-mainnet/reth"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run reth through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-reth
By installing this package,
it will automatically it will install run-reth.sh script and 
reth minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up reth. 
See eth-node-[network]-service-reth package for how that is working.
"""
