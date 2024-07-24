name = "eth-node-mainnet-config-nimbus-eth2"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-cl-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-nimbus-eth2.sh /usr/lib/eth-node-mainnet-config-nimbus-eth2/bin/",
    "debian/conf.d /etc/eth-node-mainnet/nimbus-eth2"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run nimbus-eth2 through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-mainnet-config-nimbus-eth2
By installing this package,
it will automatically it will install run-nimbus-eth2.sh script and 
nimbus-eth2 minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up nimbus-eth2. 
See eth-node-[network]-service-nimbus-eth2 package for how that is working.
"""