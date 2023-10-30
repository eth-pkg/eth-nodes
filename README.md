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
**List Clients**: You can list all available targets with the list target:

   ```bash

    make clients
   ```

## TODO Adding new clients

   ```bash
   make create-new-execution-client <name>
   make create-new-consensus-client <name>
   ```
## TODO building a specific version of a client

   ```bash
   make erigon VERSION_NUMBER_erigon=3.2.2
   ```
## Patch source

   Setup dquilt if not done before
   ```bash 
   make dquilt-setup
   ```
   Checkout source that you need to modify, you specify version number if needed 
   ```bash
   make patch-checkout CLIENT=erigon
   cd /tmp/source-override/erigon
   dquilt new your_patch_name.patch
   dquilt add modified_file
   dquilt refresh
   ```

   Copy the patched source. 
   ```bash
   make patch-commit CLIENT=erigon
   ```
   Now you can run `make erigon` to package the client with the patch. 
