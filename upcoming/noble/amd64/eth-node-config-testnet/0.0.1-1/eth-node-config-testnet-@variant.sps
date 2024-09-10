name = "eth-node-config-testnet-@variant"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-config-testnet-{variant}"]
suggests = []
depends=["eth-node-{variant}"]
add_files = [
    "debian/scripts/run-{variant}.sh /usr/lib/eth-node-config-testnet-{variant}/bin/",
    "debian/conf.d/{variant}-testnet.conf /etc/eth-node-testnet/{variant}/conf.d/",

]
add_links = []
add_manpages = []
summary = "Simple config and run script to ethereum clients, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-testnet-{variant}
By installing this package,
it will automatically it will install scripts to start clients and 
minimal configs for each supported network, which you can use in tandem
with to spin up clients. 
See eth-node-testnet-service-{variant} package for how that is working. 
"""
