name = "eth-node-erigon"
architecture = "any"
summary = "Ethereum implementation on the efficiency frontier"
conflicts = []
recommends = []
provides = ["eth-node-execution-client"]
suggests = ["eth-node"]
add_files = ["build/bin/capcli /usr/share/eth-node-erigon/bin",
"build/bin/caplin /usr/share/eth-node-erigon/bin",
"build/bin/caplin-regression /usr/share/eth-node-erigon/bin",
"build/bin/devnet /usr/share/eth-node-erigon/bin",
"build/bin/downloader /usr/share/eth-node-erigon/bin",
"build/bin/erigon /usr/share/eth-node-erigon/bin",
"build/bin/evm /usr/share/eth-node-erigon/bin",
"build/bin/hack /usr/share/eth-node-erigon/bin",
"build/bin/integration /usr/share/eth-node-erigon/bin",
"build/bin/observer /usr/share/eth-node-erigon/bin",
"build/bin/pics /usr/share/eth-node-erigon/bin",
"build/bin/rpcdaemon /usr/share/eth-node-erigon/bin",
"build/bin/rpctest /usr/share/eth-node-erigon/bin",
"build/bin/sentinel /usr/share/eth-node-erigon/bin",
"build/bin/sentry /usr/share/eth-node-erigon/bin",
"build/bin/state /usr/share/eth-node-erigon/bin",
"build/bin/txpool /usr/share/eth-node-erigon/bin",
"build/bin/verkle /usr/share/eth-node-erigon/bin"]
add_manpages = []
long_doc = """
Erigon is an implementation of Ethereum (execution layer with embeddable consensus layer), 
on the efficiency frontier. Archive Node by default.
"""
