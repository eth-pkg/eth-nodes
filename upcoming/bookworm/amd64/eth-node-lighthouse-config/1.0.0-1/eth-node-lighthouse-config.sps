name = "eth-node-ligthhouse-config"
architecture = "any"
summary = "TODO"
conflicts = []
recommends = []
provides = ["eth-node-cl-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-lighthouse.sh /usr/lib/eth-node-besu-config/bin/",
    "debian/conf.d /etc/eth-node-lighthouse-config"
]
add_links = ["/usr/lib/eth-node-besu-config/bin/run-besu.sh /usr/bin/run-lighthouse.sh"]
add_manpages = []
long_doc = """eth-node-ligthhouse-config
TODO 
"""
