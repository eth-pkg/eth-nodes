name = "eth-node-besu-config"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-el-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-besu.sh /usr/lib/eth-node-besu-config/bin/",
    "debian/conf.d /etc/eth-node-besu-config"
]
add_links = ["/usr/lib/eth-node-besu-config/bin/run-besu.sh /usr/bin/run-besu.sh"]
add_manpages = []
summary = "Simple config and run script to run besu through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-besu-config
By installing this package,
it will automatically it will install run-besu.sh script and 
besu minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up besu. 
See eth-node-[network]-service-besu package for how that is working.
"""
