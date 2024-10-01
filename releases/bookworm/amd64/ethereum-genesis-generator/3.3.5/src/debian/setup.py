import cx_Freeze
from cx_Freeze import Executable

# Dependencies can be automatically detected, but it might need fine-tuning.
build_options = {
    "packages": ["web3", "ruamel.yaml",],
    "excludes": [],
    "includes": ["os", "sys", "encodings", "web3", "ruamel.yaml"],
}

executables = [
    Executable("genesis_besu.py", target_name="genesis_besu"),
    Executable("genesis_chainspec.py", target_name="genesis_chainspec"),
    Executable("genesis_geth.py", target_name="genesis_geth"),
]

cx_Freeze.setup(
    name="Genesis Tools",
    version="3.3.5",
    description="Genesis tools for blockchain configuration",
    options={"build_exe": build_options},
    executables=executables,
)
