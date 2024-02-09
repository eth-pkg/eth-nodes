.PHONY: build all 

# Define allowed packages
ALLOWED_PACKAGES := \
	eth-node \
	eth-node-besu \
	eth-node-erigon \
	eth-node-geth \
	eth-node-lighthouse \
	eth-node-lodestar \
	eth-node-nethermind \
	eth-node-nimbus-eth2 \
	eth-node-prysm \
	eth-node-service \
	eth-node-teku 

DISTRIBUTION := debian-12
ARCH := amd64

all: build

build: PACKAGE:=
build: VERSION:=
build: BUILD_SYSTEM:=v1
build: 
	[ -n "$(PACKAGE)" ] || (echo "Please specify a package to build" && exit 1)
	[ -d "$(CURDIR)/pkg_specs/$(DISTRIBUTION)/$(PACKAGE)/$(VERSION)" ] || (echo "Directory does not exist: $(CURDIR)/pkg_specs/$(DISTRIBUTION)/$(PACKAGE)/$(VERSION)" && exit 1)
	mkdir -p /tmp/pkg_specs/$(PACKAGE)_$(VERSION)
	cp -R pkg_specs/$(DISTRIBUTION)/$(PACKAGE)/$(VERSION)/* /tmp/pkg_specs/$(PACKAGE)_$(VERSION)
	cp -R build-systems/$(BUILD_SYSTEM)/* /tmp/pkg_specs/$(PACKAGE)_$(VERSION)
	cd /tmp/pkg_specs/$(PACKAGE)_$(VERSION) && $(MAKE) -f Makefile

available-arch: 
	echo "Only $(ARCH) is supported at the moment"

available-distributions: 
	echo "Currently only debian-12 is supported"

available-packages: 
	echo "Available packages are $(ALLOWED_PACKAGES)"
