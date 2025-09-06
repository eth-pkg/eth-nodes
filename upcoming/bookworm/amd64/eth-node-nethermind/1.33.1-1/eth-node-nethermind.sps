name = "eth-node-nethermind"
architecture = "any"
summary = "Nethermind Ethereum client"
conflicts = []
recommends = []
provides = ["eth-node-execution-client (= 1)"]
suggests = ["eth-node (= 1)"]
# TODO can't add depends, piuparts are failing 
#depends = ["aspnetcore-runtime-7.0", "ca-certificates"]
depends = []
add_files = [
    "src/Nethermind/artifacts/bin /usr/lib/eth-node-nethermind",
    "src/Nethermind/artifacts/obj /usr/lib/eth-node-nethermind"
    ]
add_links = ["/usr/lib/eth-node-nethermind/bin/Nethermind.Runner/release/nethermind /usr/bin/nethermind"]
add_manpages = []
long_doc = """
Nethermind is a high-performance, highly configurable full Ethereum protocol execution client built on .NET that runs on Linux, Windows, and macOS, and supports Clique, Aura, and Ethash. Nethermind offers very fast sync speeds and support for external plugins. Enjoy reliable access to rich on-chain data thanks to high-performance JSON-RPC based on the Kestrel web server. Healthy node monitoring is secured with Grafana analytics and Seq logging.
"""
