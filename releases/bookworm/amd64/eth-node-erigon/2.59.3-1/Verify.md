# Verify

Verification is a straightforward process, currently supported on Bookworm (Debian 12), Ubuntu (22.04), and Ubuntu (24.04). You can either have a locally installed version of these distributions or run a VM in the cloud. If you prefer, you can also use qemu or virtualized VMs locally. However, please note that verification through docker is not possible due to permission problems in nested containers. 
For your convenience, there are multiple ways to verify. One option is to use Github Actions after cloning the main repository and submitting a verification branch on your fork. This flexibility allows you to choose the method that suits your workflow best.


## Ways to verify 

    0. Obtaining a source to verify
    1. Running verification locally/cloud vm
    2. Verifying on CI
    3. Verifying Debian hashes through download

Rest assured, the first two options are interchangeable, or you can choose to do both for added assurance. The third option is to verify the distributed built .deb files, which don't create the package but only verify the hashes. This process is designed to ensure the integrity of the software versions.

### 0. Obtaining a source to verify 

You can either use the release output pkg_specs.tar.gz untar and work with it or 
Check out the main repo and navigate to the release you want to verify. 

From git 

```bash
git clone --branch releases/bookworm/amd64/eth-node-erigon/2.59.3-1 https://github.com/eth-pkg/eth-nodes.git 
cd eth-nodes
cd releases/bookworm/amd64/eth-node-erigon/2.59.3-1
```

From the release source on GitHub 

```bash
wget https://github.com/eth-pkg/eth-nodes/releases/download/<path_to_release>/pkg_specs.tar.gz
tar -tvf pkg_specs.tar.gz
cd pkg_specs
cd releases/bookworm/amd64/eth-node-erigon/2.59.3-1
```

### 1. Running verification locally/cloud vm


#### Install sbuild if you don't have it yet
```bash 
sudo apt update
sudo apt -y remove sbuild # remove old sbuild if you had installed it
# Note this is an older version of sbuild; there is no need to patch it yet
sudo apt install -y debhelper schroot ubuntu-dev-tools piuparts autopkgtest vmdb2 qemu-system-x86 pkg-config libssl-dev uidmap lifeless-df-perl libmime-lite-perl
 # change this into the built version and cache it
sudo apt install dh-python dh-sequence-python3 libyaml-tiny-perl python3-all            
```

If you are on *Ubuntu* clone 

```bash
git clone https://github.com/eth-pkg/sbuild-ubuntu.git
```

If you are on *Debian clone 

```bash 
git clone https://github.com/eth-pkg/sbuild-ubuntu.git
```

Install forked sbuild
```bash
cd sbuild 
# Build the package
dpkg-build package -us -uc  
# Install the newly built package 
cd .. && sudo dpkg -i sbuild_0.85.6_all.deb libsbuild-perl_0.85.6_all.deb            
```

#### Install pkg-builder if you don't have it
Install pkg-builder prerequisites

```bash
# install prerequisites
sudo apt install libssl-dev pkg-config quilt debhelper tar wget autopkgtest vmdb2 qemu-system-x86 git-lfs
sudo sbuild-adduser `whoami`
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # rust if you don't have it
```

```bash 
git clone --branch v0.2.2 https://github.com/eth-pkg/pkg-builder.git
cd pkg-builder 
cargo build --release && cargo install --path .
pkg-builder --version # should be available in PATH
```


#### Verify 

Inside the directory of pkg_specs (either untarred or git source), see obtaining source.

```bash 
pkg-builder verify
```

Please wait until the above packaging process is completed; this will take quite a lot of time, as it does 
    - obtain the source tar.gz
    - setups local directory structure
    - unpacks isolated env
    - run package build
    - run client tests
    - and then verifies the hash    

The verification might throw an error that you don't need the required env to verify; in that case, please
run `pkg-builder env create`.

### 2. Verifying on GitHub Actions CI

Fork the `eth-pkg/eth-nodes` repository and create a branch called `verify/bookworm/amd64/eth-node-erigon/2.59.3-1`. Create an empty markdown file in the project outside the `src` directories. Push and wait for GitHub Actions to run.
Please note that this will not run on `eth-pkg/eth-nodes`; to avoid too many runs, it will run `<your_github_account>/eth-nodes`.

### 3. Verifying Debian hashes through download

Obtain the `.deb` package. 

```bash 
sha1sum eth-node-erigon_2.59.3-1_amd64.deb 
```

Check the hash of the '.deb' package against the hash specified in the `pkg-builder-verify.toml` file. This file contains the expected hash values for the software package, and comparing the actual hash with the expected hash is a crucial step in the verification process.