# Building Packages

## Prerequisites
1. Install pkg-builder from [pkg-builder README](https://github.com/eth-pkg/pkg-builder)
2. Ensure system dependencies are installed for your target client

## Building Steps

### Example: Building Nimbus-eth2
```bash
# Navigate to package directory
cd debian-12/amd64/eth-node-nimbus-eth2/24.3.0-1

# Create build environment
pkg-builder env create

# Build package
pkg-builder package

# Verify build
pkg-builder verify --no-package true
```

### Package Organization
```
debian-12/
└── amd64/
    └── eth-node-client-name/
        └── version-number/
            ├── debian/
            ├── pkg-builder.toml
            └── pkg-builder-verify.toml
```

## Verification
After building, verify your package hash matches the one in pkg-builder-verify.toml:
```bash
sha1sum *.deb
cat pkg-builder-verify.toml
```

## Notes
- Docker builds are not supported due to sbuild kernel namespace limitations
- Each client may have unique build dependencies
- Build environments are isolated to ensure reproducibility