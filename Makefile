.PHONY: all

# Define allowed client packages
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

ifeq ($(filter $(PACKAGE),$(ALLOWED_PACKAGES)),)
    $(error Invalid PACKAGE. Please use 'make PACKAGE=eth-node-lighthouse VERSION=4.5.0' or 'make PACKAGE=eth-node-erigon VERSION=4.5.0')
endif

# If VERSION is not set, find the maximum version
ifeq ($(VERSION),)
    AVAILABLE_VERSIONS := $(shell ls -d pkg_specs/$(DISTRIBUTION)/$(PACKAGE)/*/ 2>/dev/null)
    $(info Available Versions: $(AVAILABLE_VERSIONS))

    # Ensure there are versions available
    ifeq ($(strip $(AVAILABLE_VERSIONS)),)
        $(error No versions available for PACKAGE=$(PACKAGE))
    endif

    LAST_VERSION := $(shell echo $(AVAILABLE_VERSIONS) | xargs basename | sort -V | tail -n 1)
    $(info Last Version: $(LAST_VERSION))

    VERSION := $(LAST_VERSION)
    $(info Selected Version: $(VERSION))
endif

PACKAGE_DIR := pkg_specs/$(DISTRIBUTION)/$(PACKAGE)/$(VERSION)

# Check if the directory exists
ifeq ($(wildcard $(PACKAGE_DIR)),)
    $(error Directory $(dir $(PACKAGE_DIR)) does not exist or Makefile is missing)
endif

all:
	cd $(PACKAGE_DIR) && $(MAKE) -f Makefile
