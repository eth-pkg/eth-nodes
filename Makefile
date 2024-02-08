.PHONY: all

# Check if CLIENT is set
ifeq ($(CLIENT),)
    $(error CLIENT is not set. Please use 'make CLIENT=lighthouse VERSION=4.5.0' or 'make CLIENT=erigon VERSION=4.5.0')
endif

# If VERSION is not set, find the maximum version
ifeq ($(VERSION),)
    AVAILABLE_VERSIONS := $(shell ls -d pkg_specs/debian-12/eth-node-$(CLIENT)/*/ 2>/dev/null)
    $(info Available Versions: $(AVAILABLE_VERSIONS))
    
    # Ensure there are versions available
    ifeq ($(strip $(AVAILABLE_VERSIONS)),)
        $(error No versions available for CLIENT=$(CLIENT))
    endif

    LAST_VERSION := $(shell echo $(AVAILABLE_VERSIONS) | xargs basename | sort -V | tail -n 1)
    $(info Last Version: $(LAST_VERSION))

    VERSION := $(LAST_VERSION)
    $(info Selected Version: $(VERSION))
endif


CLIENT_DIR:= pkg_specs/debian-12/eth-node-$(CLIENT)/$(VERSION) 

# Check if the directory exists
ifeq ($(wildcard $(CLIENT_DIR)),)
    $(error Directory $(dir $(CLIENT_DIR)) does not exist or Makefile is missing)
endif

all:
	cd $(CLIENT_DIR) && $(MAKE) -f Makefile

include $(MAKEFILE)

