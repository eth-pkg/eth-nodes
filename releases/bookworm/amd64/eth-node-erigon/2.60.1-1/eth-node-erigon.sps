name = "eth-node-erigon"
architecture = "any"
summary = "Ethereum implementation on the efficiency frontier"
conflicts = []
recommends = []
provides = ["eth-node-execution-client (= 1)"]
suggests = ["eth-node (= 1)"]
add_files = [
# not copying, buildid is included, and remove is non-determistic, sometimes works, sometimes not
#"build/bin/capcli /usr/lib/eth-node-erigon/bin",
#"build/bin/caplin /usr/lib/eth-node-erigon/bin",
#"build/bin/devnet /usr/lib/eth-node-erigon/bin",
# # Same, build id cannot be removed
# "build/bin/downloader /usr/lib/eth-node-erigon/bin",
"build/bin/erigon /usr/lib/eth-node-erigon/bin",
#"build/bin/evm /usr/lib/eth-node-erigon/bin",
#"build/bin/hack /usr/lib/eth-node-erigon/bin",
#"build/bin/integration /usr/lib/eth-node-erigon/bin",
#"build/bin/observer /usr/lib/eth-node-erigon/bin",
#"build/bin/pics /usr/lib/eth-node-erigon/bin",
#"build/bin/rpcdaemon /usr/lib/eth-node-erigon/bin",
#"build/bin/rpctest /usr/lib/eth-node-erigon/bin",
#"build/bin/sentinel /usr/lib/eth-node-erigon/bin",
#"build/bin/sentry /usr/lib/eth-node-erigon/bin",
# Same, build id cannot be removed
# "build/bin/snapshots /usr/lib/eth-node-erigon/bin",
#"build/bin/state /usr/lib/eth-node-erigon/bin",
#"build/bin/txpool /usr/lib/eth-node-erigon/bin",
#"build/bin/verkle /usr/lib/eth-node-erigon/bin",
#"build/bin/diag /usr/lib/eth-node-erigon/bin",
]
add_links = ["/usr/lib/eth-node-erigon/bin/erigon /usr/bin/erigon"]
add_manpages = []
long_doc = """
Erigon is an implementation of Ethereum (execution layer with embeddable consensus layer), 
on the efficiency frontier. Archive Node by default.
"""
