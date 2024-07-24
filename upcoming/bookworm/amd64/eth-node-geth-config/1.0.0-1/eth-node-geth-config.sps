name = "eth-node-geth-config"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-el-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-geth.sh /usr/lib/eth-node-geth-config/bin/",
    "debian/conf.d /etc/eth-node-geth-config"
]
add_links = ["/usr/lib/eth-node-geth-config/bin/run-geth.sh /usr/bin/run-geth.sh"]
add_manpages = []
summary = "Simple config and run script to run geth through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-geth-config
By installing this package,
it will automatically it will install run-geth.sh script and 
geth minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up geth. 
See eth-node-[network]-service-geth package for how that is working.
"""
