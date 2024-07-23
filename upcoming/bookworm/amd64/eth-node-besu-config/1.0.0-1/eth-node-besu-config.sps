name = "eth-node-besu-config"
architecture = "any"
summary = "Simplified Ethereum node installation for testnet, supporting clients: besu and lighthouse."
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
long_doc = """eth-node-besu-conf
By installing this package,
it will automatically set up a besu and lighthouse client pair (consensus and execution client) for connecting
to the Ethereum testnet engine.
"""
