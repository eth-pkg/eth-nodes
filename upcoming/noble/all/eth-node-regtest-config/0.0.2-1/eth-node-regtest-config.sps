name = "eth-node-regtest-config"
architecture = "all"
summary = "TODO"
conflicts = []
recommends = []
provides = [""]
suggests = []
depends=["ethereum-genesis-generator (>=3.3.8-1)"]
add_files = [
    "debian/regtest /var/lib/eth-node-regtest",
    "debian/config /etc/eth-node-regtest-config",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-regtest",
    "debian/scripts/eth-node-regtest-config.yaml /etc/eth-node-regtest-config/",
    "debian/scripts/regtest.conf /etc/eth-node-regtest-config/",
]
add_links = []
add_manpages = []
long_doc = """eth-node-regtest-config
"""

# going to fill the jwt file with random hex
[config."eth-node-regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-regtest/postprocess.sh"]


[config."eth-node-regtest.conf"]
format = "plain"
public = true 