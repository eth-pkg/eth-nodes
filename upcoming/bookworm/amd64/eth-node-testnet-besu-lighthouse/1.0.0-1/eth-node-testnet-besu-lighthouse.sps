name = "eth-node-testnet-besu-lighthouse"
architecture = "any"
summary = "Simplified Ethereum node installation for testnet, supporting clients: besu and lighthouse."
conflicts = ["eth-node-testnet"]
recommends = []
provides = ["eth-node-testnet"]
suggests = []
depends = [
    "debian/lib/systemd/system/eth-node-testnet-besu.service /lib/system.d/system/"
    "debian/lib/systemd/system/eth-node-testnet-lighthouse.service /lib/system.d/system/"
    "debian/scripts/run-besu.sh /usr/lib/eth-node-testnet-besu-lighthouse/bin/"
    "debian/scripts/run-lighthouse.sh /usr/lib/eth-node-testnet-besu-lighthouse/bin/"
    "debian/conf.d /etc/eth-node-testnet-besu-lighthouse/"
]
add_manpages = []
long_doc = """eth-node-testnet-besu-lighthouse
By installing this package,
it will automatically set up a besu and lighthouse client pair (consensus and execution client) for connecting
to the Ethereum testnet engine.
"""
