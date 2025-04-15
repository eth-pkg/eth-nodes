name = "eth-node-regtest"
architecture = "all"
summary = "TODO"
conflicts = []
recommends = []
provides = []
suggests = []
depends = []
add_files = []
add_links = []
add_manpages = []
long_doc = """eth-node-regtest
Package that install two random Ethereum consensus and execution client and
starts them running.
This package comes without validator. If you would like to have validator running
please install eth-node-regtest-with-validator instead.
"""
add_files = [
    "debian/regtest /var/lib/eth-node-regtest",
    "debian/config /etc/eth-node-regtest",
    "debian/defaults /etc/eth-node-regtest",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-regtest",
    ## config
    "debian/regtest /var/lib/eth-node-regtest/regtest",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-regtest",
    ## besu
    "debian/clients/besu/scripts /usr/lib/eth-node-regtest/besu",
    "debian/clients/besu/eth-node-besu-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-besu-regtest",
    ## lighthouse
    "debian/clients/lighthouse/scripts /usr/lib/eth-node-regtest/lighthouse",
    "debian/clients/lighthouse/eth-node-lighthouse-regtest.service /lib/systemd/system/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lighthouse-regtest",
    ## lighthouse validator
    "debian/clients/lighthouse-validator/scripts  /usr/lib/eth-node-regtest/lighthouse-validator",
    "debian/clients/lighthouse/eth-node-lighthouse-validator-regtest.service /lib/systemd/system/",
    "debian/validator /var/lib/eth-node-regtest/lighthouse-validator",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-lighthouse-validator-regtest",
]
