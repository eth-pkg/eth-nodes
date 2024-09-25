name = "eth-node-config-mainnet-@variant"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-config-mainnet-{variant}"]
suggests = []
depends=["eth-node-{variant}"]
add_files = [
    "debian/scripts/run-{variant}.sh /usr/lib/eth-node-config-mainnet-{variant}/bin/",
    "debian/conf.d/{variant}-mainnet.conf /etc/eth-node-mainnet/{variant}/conf.d/",
    "debian/conf.d/{variant}-regtest.conf /etc/eth-node-regtest/{variant}/conf.d/",
    # "debian/conf.d/@variant-sepolia.conf /etc/eth-node-mainnet/@variant/conf.d/",
    # "debian/conf.d/@variant-holesky.conf /etc/eth-node-mainnet/@variant/conf.d/",
    # "debian/conf.d/@variant-regtest.conf /etc/eth-node-mainnet/@variant/conf.d/",
    # "debian/conf.d/@variant-ephemery.conf /etc/eth-node-mainnet/@variant/conf.d/",

]
add_links = []
add_manpages = []
summary = "Simple config and run script to ethereum clients, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-mainnet-{variant}
By installing this package,
it will automatically it will install scripts to start clients and 
minimal configs for each supported network, which you can use in tandem
with to spin up clients. 
See eth-node-mainnet-service-{variant} package for how that is working. 
See eth-node-sepolia-service-{variant} package for how that is working. 
See eth-node-holesky-service-{variant} package for how that is working. 
See eth-node-ephemery-service-{variant} package for how that is working. 
See eth-node-regtest-service-{variant} package for how that is working. 
"""
