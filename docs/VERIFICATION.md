# Package Verification Guide

## Verification Methods

### 1. Local Machine Verification
1. Install pkg-builder (see [pkg-builder README](https://github.com/eth-pkg/pkg-builder))
2. Navigate to package directory:
```bash
cd debian-12/amd64/eth-node-nimbus-eth2/24.3.0-1
```
3. Create environment and build:
```bash
pkg-builder env create
pkg-builder package
pkg-builder verify --no-package true
```

### 2. GitHub Actions Verification
1. Fork repository
2. Select release (e.g., `releases/bookworm/amd64/eth-node-erigon/2.60.0-1`)
3. Create branch `verify/bookworm/amd64/eth-node-erigon/2.60.0-1`
4. Push branch and create PR
5. Wait for action completion

### 3. Hash Verification
Verify distributed package hashes:
```bash
# Download package
mkdir /tmp/tempdir && cd /tmp/tempdir
sudo apt download <package_name>

# Check hash
sha1sum <package_name>*.deb

# Compare with verified hash
cat releases/bookworm/amd64/<package_name>/pkg-builder-verify.toml
```

Example:
```bash
sudo apt download eth-node-teku
sha1sum eth-node-teku_24.4.0-1_amd64.deb
cat releases/bookworm/amd64/eth-node-teku/24.4.0-1/pkg-builder-verify.toml
```

Note: Docker verification is not supported due to sbuild kernel namespace limitations.