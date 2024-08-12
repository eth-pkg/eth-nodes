name = "eth-node-config-prysm"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-cl-config"]
suggests = []
depends=["eth-node-prysm"]
add_files = [
    "debian/scripts/run-prysm.sh /usr/lib/eth-node-config-prysm/bin/",
    "debian/conf.d/prysm-mainnet.conf /etc/eth-node-mainnet/prysm/conf.d/"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run prysm through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-prysm
By installing this package,
it will automatically it will install run-prysm.sh script and 
prysm minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up prysm. 
See eth-node-[network]-service-prysm package for how that is working.
"""