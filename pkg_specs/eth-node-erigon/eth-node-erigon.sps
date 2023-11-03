name = "eth-node-erigon"
architecture = "any"
summary = "Ethereum implementation on the efficiency frontier"
conflicts = []
recommends = []
provides = ["eth-node-execution-client"]
suggests = ["eth-node"]
add_files = ["build/bin/capcli /usr/share/eth-node-erigon/bin/capcli",
"build/bin/caplin /usr/share/eth-node-erigon/bin/caplin",
"build/bin/caplin-regression /usr/share/eth-node-erigon/bin/caplin-regression",
"build/bin/devnet /usr/share/eth-node-erigon/bin/devnet",
"build/bin/downloader /usr/share/eth-node-erigon/bin/downloader",
"build/bin/erigon /usr/share/eth-node-erigon/bin/erigon",
"build/bin/evm /usr/share/eth-node-erigon/bin/evm",
"build/bin/hack /usr/share/eth-node-erigon/bin/hack",
"build/bin/integration /usr/share/eth-node-erigon/bin/integration",
"build/bin/observer /usr/share/eth-node-erigon/bin/observer",
"build/bin/pics /usr/share/eth-node-erigon/bin/pics",
"build/bin/rpcdaemon /usr/share/eth-node-erigon/bin/rpcdaemon",
"build/bin/rpctest /usr/share/eth-node-erigon/bin/rpctest",
"build/bin/sentinel /usr/share/eth-node-erigon/bin/sentinel",
"build/bin/sentry /usr/share/eth-node-erigon/bin/sentry",
"build/bin/state /usr/share/eth-node-erigon/bin/state",
"build/bin/txpool /usr/share/eth-node-erigon/bin/txpool",
"build/bin/verkle /usr/share/eth-node-erigon/bin/verkle"]
add_manpages = []
long_doc = """
Erigon is an implementation of Ethereum (execution layer with embeddable consensus layer), 
on the efficiency frontier. Archive Node by default.
"""
