# Ethereum Node Packaging

This project is designed to simplify the process of packaging different Ethereum nodes for Debian-based systems. It provides a structured way to create Debian packages for multiple Ethereum clients. 

## Usage


### Prerequisities

Please install pkg-builder first. 
See the Readme for installation instruction: https://github.com/eth-pkg/pkg-builder


### Build debian packages



**Build the Debian Packages**: 

   ```bash
   # You only need to create env once per distribution/arch pair
   pkg-builder env create debian-12/x86_64/eth-node-nimbus-eth2/24.3.0-1/pkg-builder-verify.toml
   # This will install all deps, downloads source, builds the client, and run tests again it
   pkg-builder package debian-12/x86_64/eth-node-nimbus-eth2/24.3.0-1/pkg-builder.toml
   # Then you can verify if you have successful build, you can verify it
   pkg-builder verify debian-12/x86_64/eth-node-nimbus-eth2/24.3.0-1/pkg-builder-verify.toml --no-package=true
   ```

   If you are not a builder just want to make sure the built client has the same hash then 
   equalevent options without running the tests, but package still will be built to check against of
   hashes.
   
   ```bash
   # You only need to create env once per distribution/arch pair
   pkg-builder env create debian-12/x86_64/eth-node-nimbus-eth2/24.3.0-1/pkg-builder-verify.toml
   # Then you can verify if you have successful build, you can verify it
   pkg-builder verify debian-12/x86_64/eth-node-nimbus-eth2/24.3.0-1/pkg-builder-verify.toml 
   ```



