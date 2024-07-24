name = "eth-node-reth-config"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-el-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-reth.sh /usr/lib/eth-node-reth-config/bin/",
    "debian/conf.d /etc/eth-node-reth-config"
]
add_links = ["/usr/lib/eth-node-reth-config/bin/run-reth.sh /usr/bin/run-reth.sh"]
add_manpages = []
summary = "Simple config and run script to run reth through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-reth-config
By installing this package,
it will automatically it will install run-reth.sh script and 
reth minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up reth. 
See eth-node-[network]-service-reth package for how that is working.
"""
