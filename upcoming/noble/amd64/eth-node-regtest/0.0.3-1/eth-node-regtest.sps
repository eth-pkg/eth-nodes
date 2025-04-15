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
    ## config
    "debian/regtest/regtest /var/lib/eth-node-regtest/regtest",
    "debian/regtest/config /etc/eth-node-regtest/regtest/",
    "debian/regtest/defaults /etc/eth-node-regtest/regtest/",
    ## besu
    "debian/clients/besu/scripts/* /usr/lib/eth-node-regtest/besu",
    "debian/clients/besu/eth-node-besu-regtest.service /lib/systemd/system/",
    ## lighthouse
    "debian/clients/lighthouse/scripts/* /usr/lib/eth-node-regtest/lighthouse",
    "debian/clients/lighthouse/eth-node-lighthouse-regtest.service /lib/systemd/system/",
    ## lighthouse validator
    "debian/clients/lighthouse-validator/scripts/*  /usr/lib/eth-node-regtest/lighthouse-validator",
    "debian/clients/lighthouse-validator/eth-node-lighthouse-validator-regtest.service /lib/systemd/system/",
    "debian/clients/lighthouse-validator/validator /var/lib/eth-node-regtest/lighthouse-validator",
    ## package itself
    "debian/regtest /var/lib/eth-node-regtest",
    "debian/conf /etc/eth-node-regtest",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-regtest",
]

[config."regtest.conf"]
format = "plain"
public = true

[config."regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-regtest/postprocess.sh"]
