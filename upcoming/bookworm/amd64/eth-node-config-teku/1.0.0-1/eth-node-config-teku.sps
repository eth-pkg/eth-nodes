name = "eth-node-config-teku"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-cl-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-teku.sh /usr/lib/eth-node-config-teku/bin/",
    "debian/conf.d /etc/eth-node-mainnet/teku"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run teku through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-teku
By installing this package,
it will automatically it will install run-teku.sh script and 
teku minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up teku. 
See eth-node-[network]-service-teku package for how that is working.
"""