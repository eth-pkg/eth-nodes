# Ethereum Node Packaging

This project is designed to simplify the process of packaging different Ethereum nodes for Debian-based systems. It provides a structured way to create Debian packages for multiple Ethereum node clients. 

## Usage

**Build the Debian Packages**: Build Debian packages for each client using the generated variables.
   ```bash
   make erigon
   ```
  This will generate the appropiate .deb files for erigon.

**List Targets**: You can list all available targets with the list target:

   ```bash

    make list
   ```
## TODO Adding new clients

   ```bash
   make create-new-execution-client <name>
   make create-new-consensus-client <name>
   ```
## TODO building a specific version of a client

   ```bash
   make erigon <version_number>
   ```

