## Ethereum Node Packaging

This initiative streamlines the process of packaging diverse Ethereum nodes for Debian-based systems. It offers a systematic approach to generate Debian packages for various Ethereum clients.

### Usage

#### Prerequisites

Begin by installing `pkg-builder`. Refer to the README for installation instructions: [https://github.com/eth-pkg/pkg-builder](https://github.com/eth-pkg/pkg-builder)

#### Building Debian Packages

```bash
# Change into the directoy which you want to package
cd debian-12/amd64/eth-node-nimbus-eth2/24.3.0-1
# Create an environment once for each distribution/architecture pairing
pkg-builder env create pkg-builder-verify.toml

# This command installs dependencies, downloads source code, builds the client, and conducts tests against it
# Note: Autopkgtests and piuparts may require elevated permissions
pkg-builder package pkg-builder.toml

# To verify a successful build without running tests, you can use this command
pkg-builder verify --config-file pkg-builder.toml --verfiy-config-file pkg-builder-verify.toml 
```

If you're not building but simply ensuring the built client matches a specific hash:

```bash
debian-12/amd64/eth-node-nimbus-eth2/24.3.0-1
# Create an environment once for each distribution/architecture pairing
pkg-builder env create pkg-builder-verify.toml

# Verify the successful build without running tests
pkg-builder verify --config-file pkg-builder.toml --verfiy-config-file pkg-builder-verify.toml 
```

### Verifying packages 

```bash
mkdir /tmp/tempdir | cd -
sudo apt-get download <package_name>
sha1sum  <package_name>*.deb
```

### How It Works

This process leverages `debcrafter` and `pkg-builder` to establish reproducible environments. Debcrafter aids in creating reproducible Debian directories based on detailed specification files ending with `.sss` and `.sps`. Meanwhile, pkg-builder utilizes debcrafter, and extends it to setup minimal environments to build and adheres to Debian's best practices, including `sbuild`, `piuparts`, `lintian`, and `autopkgtest`, to build the packages and test them thoroughly, ensuring they are not merely packages but functional ones.

Currently, a significant obstacle in Debian packaging is the requirement for a separate git repository per package, which might hinder the support for numerous applications. Despite Debian packaging already facilitating reproducible builds, this aspect is still in its infancy. This project aims to adhere to distribution best practices to the fullest extent possible, only deviating when necessary or when certain support structures are not yet in place.
