name = "ethereum-genesis-generator"
architecture = "any"
summary = "Create a ethereum execution and consensus layer testnet genesis"
conflicts = []
recommends = []
provides = []
suggests = []
depends = ["eth-beacon-genesis", "eth2-val-tools", "geth-hdwallet"]
add_files = [
  "config /etc/ethereum-genesis-generator/",
  "apps/el-gen /usr/lib/ethereum-genesis-generator/apps/",
  "defaults /etc/ethereum-genesis-generator/",
  "entrypoint.sh /usr/lib/ethereum-genesis-generator/bin",

]
add_links = [
  "/usr/lib/ethereum-genesis-generator/bin/entrypoint.sh /usr/bin/ethereum-genesis-generator"
]
add_manpages = []
long_doc = """
Create a ethereum execution and consensus layer testnet genesis and expose it via a webserver for testing purposes 
"""
