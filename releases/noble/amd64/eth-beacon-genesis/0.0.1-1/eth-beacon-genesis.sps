name = "eth-beacon-genesis"
architecture = "any"
summary = "A tool for generating genesis state"
conflicts = []
recommends = []
provides = []
suggests = []
add_files = ["bin/eth-beacon-genesis /usr/lib/eth-beacon-genesis/bin"]
add_links = ["/usr/lib/eth-beacon-genesis/bin/eth-beacon-genesis /usr/bin/eth-beacon-genesis"]
add_manpages = []
long_doc = """
eth-beacon-genesis tool for generating Ethereum consensus layer (beacon chain) 
genesis states for development and testing networks.
"""