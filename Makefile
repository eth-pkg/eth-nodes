EXECUTION_CLIENTS = geth nethermind besu erigon
CONSENSUS_CLIENTS = lighthouse lodestar nimbus_eth2 prysm teku
WORK_DIR = /tmp/eth-packages
PKG_DIR := /home/debian/workspace/eth-deb

# Define the clients that you want to build
CLIENTS = $(EXECUTION_CLIENTS) $(CONSENSUS_CLIENTS)

VERSION_NUMBER_geth=1.13.4
SOURCE_URL_geth := https://github.com/ethereum/go-ethereum/archive/refs/tags/v$(VERSION_NUMBER_geth).tar.gz

VERSION_NUMBER_nethermind=1.21.1
SOURCE_URL_nethermind :=https://github.com/NethermindEth/nethermind/archive/refs/tags/$(VERSION_NUMBER_nethermind).tar.gz

VERSION_NUMBER_besu=23.10.1
SOURCE_URL_besu := https://github.com/hyperledger/besu/archive/refs/tags/$(VERSION_NUMBER_besu).tar.gz

VERSION_NUMBER_erigon=2.53.2
SOURCE_URL_erigon := https://github.com/ledgerwatch/erigon/archive/refs/tags/v$(VERSION_NUMBER_erigon).tar.gz

VERSION_NUMBER_lighthouse=4.5.0
SOURCE_URL_lighthouse := https://github.com/sigp/lighthouse/archive/refs/tags/v$(VERSION_NUMBER_lighthouse).tar.gz

VERSION_NUMBER_lodestar=1.11.3
SOURCE_URL_lodestar :=https://github.com/ChainSafe/lodestar/archive/refs/tags/v$(VERSION_NUMBER_lodestar).tar.gz

VERSION_NUMBER_nimbus_eth2=23.10.0
SOURCE_URL_nimbus := https://github.com/status-im/nimbus-eth2/archive/refs/tags/v$(VERSION_NUMBER_nimbus_eth2).tar.gz

VERSION_NUMBER_prysm=4.1.1
SOURCE_URL_prysm := https://github.com/prysmaticlabs/prysm/archive/refs/tags/v$(VERSION_NUMBER_prysm).tar.gz

VERSION_NUMBER_teku=23.10.0
SOURCE_URL_teku := https://github.com/Consensys/teku/archive/refs/tags/$(VERSION_NUMBER_teku).tar.gz

# Define a template for client-specific variables
define CLIENT_VARIABLE_template
SOURCE_DIR_$(1) := $$(WORK_DIR)/eth-node-$(1)/$$(VERSION_NUMBER_$(1))/eth-node-$(1)-$$(VERSION_NUMBER_$(1))
SOURCE_DIR_PARENT_$(1) := $$(dir $$(SOURCE_DIR_$(1)))
DEBCRAFTER_PKG_DIR_$(1) := $$(PKG_DIR)/pkg_specs/eth-node-$(1)
DEBIAN_DIR_$(1) := $$(PKG_DIR)/eth-node-$(1)/eth-node-$(1)-$$(VERSION_NUMBER_$(1))/debian
DEPS_$(1) := $$(SOURCE_DIR_$(1))/debian
endef

# Expand the template for each client
$(foreach client, $(CLIENTS), $(eval $(call CLIENT_VARIABLE_template,$(client))))

# 5. Copy the debcrafter directory from pkg_config
define COPY_DEBCRAFTER_DIR_template
$(DEPS_$1): $$(DEBIAN_DIR_$1) $$(SOURCE_DIR_$1)
	@echo "Dependencies for $$@: $$^"
	@echo "Copying source $$@"
	@cp -R $$(DEBIAN_DIR_$1) $$(SOURCE_DIR_$1)
endef

define EXTRACT_SOURCE_template
# 4. Extract the source
$(SOURCE_DIR_$1): $$(SOURCE_DIR_$1).tar.gz
	@echo "Dependencies for $$@: $$^"
	@echo "Extracting source $$@"
	@mkdir -p $$@ && tar -zxvf $$(SOURCE_DIR_$1).tar.gz -C $$@ --strip-components=1 >/dev/null 2>&1

endef 

define DOWNLOAD_SOURCE_template
# 3. Download the source .tar.gz
$(SOURCE_DIR_$1).tar.gz: $$(SOURCE_DIR_PARENT_$1)
	@echo "Dependencies for $$@: $$^"
	@echo "Downloading source $$@"
	@cd $$< && wget -O $$@ $${SOURCE_URL_$1}
endef

define CREATE_DEBIAN_DIR_template
# 2. Create debian dir for client based on version number
$(DEBIAN_DIR_$1): $$(DEBCRAFTER_PKG_DIR_$1) 
	@echo "Dependencies for $$@: $$^"
	@echo "Creating debian folder with debcrafter $$@"
	@echo "folder: $$<"
	@debcrafter $$</eth-node-$1.sss $${PKG_DIR}/eth-node-$1 --split-source

endef

define CHECK_REQUIREMENTS_template
# 1. Check if the packaging directory exist, throw an error if not
# This will be expanded into multiple target, based on the content of the PKG_SPEC_DIRS
$(DEBCRAFTER_PKG_DIR_$1):
	@echo "Dependencies for $$@: $$^"
	@if [ ! -d "$$@" ]; then \
	echo "Error: $$@ directory does not exist. You cannot create packages without it." && exit 1; \
	fi

endef

define CREATE_PACKAGING_DIR_template
#Create empty folder for packaging per client 
$(SOURCE_DIR_PARENT_$1): 
	@echo "Dependencies for $$@: $$^"
	@mkdir -p $$@

endef

all: $(CLIENTS)
$(CLIENTS): %: %_setup
# 6. Build the source 
$(foreach client, $(CLIENTS), $(eval $(client)_setup: $(DEPS_$(client))))
%_setup: 
	@echo "Client $@ $*"
	@echo "Dependencies for $@: $^"
	@echo "Building debian packages $@"
	@cd ${SOURCE_DIR_$*} &&  dpkg-buildpackage -us -uc

# create directory if not exists
$(foreach client, $(CLIENTS), $(eval $(call CREATE_PACKAGING_DIR_template,$(client))))

# Checks if .sss and .sps files exist for packing to start
$(foreach client, $(CLIENTS), $(eval $(call CHECK_REQUIREMENTS_template,$(client))))

# Create $(DEBIAN_DIR_client).tar.gz targets for each client
$(foreach client, $(CLIENTS), $(eval $(call CREATE_DEBIAN_DIR_template,$(client))))

# Create $(SOURCE_DIR_client).tar.gz targets for each client
$(foreach client, $(CLIENTS), $(eval $(call DOWNLOAD_SOURCE_template,$(client))))

# Create $(SOURCE_DIR_client) targets for each client
$(foreach client, $(CLIENTS), $(eval $(call EXTRACT_SOURCE_template,$(client))))

# Create $(DEPS_client) targets for each client
$(foreach client, $(CLIENTS), $(eval $(call COPY_DEBCRAFTER_DIR_template,$(client))))

PHONIES:= all $(CLIENTS) list

list: 
	@echo "$(PHONIES)"
#list the client defined variabls

PHONY: $(PHONIES) 
