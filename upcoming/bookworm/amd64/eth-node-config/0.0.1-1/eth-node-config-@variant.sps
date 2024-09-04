name = "eth-node-config-@variant"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-config-{variant}"]
suggests = []
depends=["eth-node-{variant}"]
add_files = [
    "debian/scripts/run-{variant}.sh /usr/lib/eth-node-config-{variant}/bin/",
    "debian/conf.d/{variant}-mainnet.conf /etc/eth-node-mainnet/{variant}/conf.d/",
    # "debian/conf.d/@variant-sepolia.conf /etc/eth-node-mainnet/@variant/conf.d/",
    # "debian/conf.d/@variant-holesky.conf /etc/eth-node-mainnet/@variant/conf.d/",
    # "debian/conf.d/@variant-testnet.conf /etc/eth-node-mainnet/@variant/conf.d/",
    # "debian/conf.d/@variant-ephemery.conf /etc/eth-node-mainnet/@variant/conf.d/",

]
add_links = []
add_manpages = []
summary = "Simple config and run script to ethereum clients, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-{variant}
By installing this package,
it will automatically it will install scripts to start clients and 
minimal configs for each supported network, which you can use in tandem
with to spin up clients. 
See eth-node-mainnet-service-{variant} package for how that is working. 
See eth-node-sepolia-service-{variant} package for how that is working. 
See eth-node-holesky-service-{variant} package for how that is working. 
See eth-node-ephemery-service-{variant} package for how that is working. 
See eth-node-testnet-service-{variant} package for how that is working. 
"""
