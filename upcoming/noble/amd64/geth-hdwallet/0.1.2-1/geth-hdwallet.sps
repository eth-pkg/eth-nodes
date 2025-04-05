name = "geth-hdwallet"
architecture = "any"
summary = "Ethereum HD Wallet derivations"
conflicts = []
recommends = []
provides = []
suggests = []
add_files = ["geth-hdwallet /usr/lib/geth-hdwallet/bin"]
add_links = ["/usr/lib/geth-hdwallet/bin/geth-hdwallet /usr/bin/geth-hdwallet"]
add_manpages = []
long_doc = """
Ethereum HD Wallet derivations from [mnemonic] seed in Go (golang). Implements the go-ethereum accounts.Wallet interface.
"""