name = "ethereum-genesis-generator"
architecture = "any"
summary = "Create a ethereum execution and consensus layer testnet genesis"
conflicts = []
recommends = []
provides = []
suggests = []
add_files = [
    "dist/genesis_besu /usr/lib/ethereum-genesis-generator/bin",
    "dist/genesis_chainspec /usr/lib/ethereum-genesis-generator/bin",
    "dist/genesis_geth /usr/lib/ethereum-genesis-generator/bin",
    # "el-gen /usr/lib/el-gen/bin",
]
add_links = ["/usr/lib/ethereum-genesis-generator/bin/ethereum-genesis-generator /usr/bin/ethereum-genesis-generator"]
add_manpages = []
long_doc = """
Create a ethereum execution and consensus layer testnet genesis 
"""