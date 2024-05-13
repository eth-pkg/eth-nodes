# Release Notes

## eth-node-teku

**version**: 24.4.0-1 <br/>
**arch**: amd64 <br/>
**distribution**: bookworm (Debian-12) <br/>

This release is a Debian package for [teku](https://github.com/Consensys/teku). The source is taken from the release tarball, which has been modified minimally through patches to ensure reproducibility. 

*Note*: The built binary has not yet been run against any network but has been packaged against official sources; this is the first release meant to create working, reproducible binary-to-binary builds. Please note that bugs can be expected as this is the first release meant to be working, but more emphasis was placed on reproducibility as the following milestones will be around node running. While the source is minimally modified, the toolchain and distribution could introduce unintended, unintentional bugs. 

### Added
- Reproducible build environment with sbuild through pkg-builder
- binary to binary reproducible packages through pkg-builder
- testing through autopkgtest, lintian and piuparts
- added pkg-builder-verify.toml to ensure the built package hashes match against the built output

### Changed compared to upstream
- Pinned dependencies in `pkg-builder.toml`, there might be incompatible dependency, please check to make sure.

Please see the patches folder for the complete source code modification list.

### Known issues

- Sbuild has been forked from Ubuntu with the following changes:
    - Network access enabled to fetch sources.
    - Disabled temporary folder creation for isolated env, as temporary folder creation makes it unreproducible 
- Lintian errors are a lower priority; it is expected to find areas that need to be improved.
- Debcrafter does not yet support versioning.
- Prebuilt sbuild and debcrafter were used for packaging. However, this is fine as you can repackage them (the source is on GitHub under this organization) and verify, ensuring that hashes are the same, locally and CI.
- It was built using two machines, and the hashes have been checked. However, both machines have AMD64 architecture and the hashes still need to be tested on other architectures. Sbuild, the isolated environment, should not impose hash changes, but incorrectly used build flags can interfere with reproducibility. 

For instructions on verifying, see the Verify.md.
