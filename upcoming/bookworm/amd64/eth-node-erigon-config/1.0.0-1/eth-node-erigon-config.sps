name = "eth-node-erigon-config"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-el-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-erigon.sh /usr/lib/eth-node-erigon-config/bin/",
    "debian/conf.d /etc/eth-node-erigon-config"
]
add_links = ["/usr/lib/eth-node-erigon-config/bin/run-erigon.sh /usr/bin/run-erigon.sh"]
add_manpages = []
summary = "Simple config and run script to run erigon through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-erigon-config
By installing this package,
it will automatically it will install run-erigon.sh script and 
erigon minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up erigon. 
See eth-node-[network]-service-erigon package for how that is working.
"""
