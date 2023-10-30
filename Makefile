EXECUTION_CLIENTS = geth nethermind besu erigon
CONSENSUS_CLIENTS = lighthouse lodestar nimbus-eth2 prysm teku
WORK_DIR = /tmp/eth-packages
HOME:= /home/debian
PKG_DIR := $(HOME)/workspace/eth-deb

# Define the clients that you want to build
CLIENTS = $(EXECUTION_CLIENTS) $(CONSENSUS_CLIENTS)


define VERSION_NUMBER_template
VERSION_NUMBER_$(1) := $$(shell dpkg-parsechangelog -l $$(PKG_DIR)/pkg_specs/eth-node-$(1)/eth-node-$(1).changelog -S Version 2>/dev/null | sed 's/-.*//')
endef

$(foreach client, $(CLIENTS), $(eval $(call VERSION_NUMBER_template,$(client))))


SOURCE_URL_geth := https://github.com/ethereum/go-ethereum/archive/refs/tags/v$(VERSION_NUMBER_geth).tar.gz
SOURCE_URL_nethermind :=https://github.com/NethermindEth/nethermind/archive/refs/tags/$(VERSION_NUMBER_nethermind).tar.gz
SOURCE_URL_besu := https://github.com/hyperledger/besu/archive/refs/tags/$(VERSION_NUMBER_besu).tar.gz
SOURCE_URL_erigon := https://github.com/ledgerwatch/erigon/archive/refs/tags/v$(VERSION_NUMBER_erigon).tar.gz
SOURCE_URL_lighthouse := https://github.com/sigp/lighthouse/archive/refs/tags/v$(VERSION_NUMBER_lighthouse).tar.gz
SOURCE_URL_lodestar :=https://github.com/ChainSafe/lodestar/archive/refs/tags/v$(VERSION_NUMBER_lodestar).tar.gz
SOURCE_URL_nimbus-eth2 := https://github.com/status-im/nimbus-eth2/archive/refs/tags/v$(VERSION_NUMBER_nimbus-eth2).tar.gz
SOURCE_URL_prysm := https://github.com/prysmaticlabs/prysm/archive/refs/tags/v$(VERSION_NUMBER_prysm).tar.gz
SOURCE_URL_teku := https://github.com/Consensys/teku/archive/refs/tags/$(VERSION_NUMBER_teku).tar.gz

# Define a template for client-specific variables
define CLIENT_VARIABLE_template
SOURCE_DIR_$(1) := $$(WORK_DIR)/eth-node-$(1)/$$(VERSION_NUMBER_$(1))/eth-node-$(1)-$$(VERSION_NUMBER_$(1))
SOURCE_DIR_PARENT_$(1) := $$(dir $$(SOURCE_DIR_$(1)))
DEBCRAFTER_PKG_DIR_$(1) := $$(PKG_DIR)/pkg_specs/eth-node-$(1)
DEBIAN_DIR_$(1) := $$(PKG_DIR)/eth-node-$(1)/eth-node-$(1)-$$(VERSION_NUMBER_$(1))/debian
# Holds patches, not always exists
PC_DIR_$(1) := $$(PKG_DIR)/eth-node-$(1)/eth-node-$(1)-$$(VERSION_NUMBER_$(1))/.pc
DEPS_$(1) := $$(SOURCE_DIR_$(1))/debian
endef

$(foreach client, $(CLIENTS), $(eval $(call CLIENT_VARIABLE_template,$(client))))

# Meta package
VERSION_NUMBER_eth-node := $(shell dpkg-parsechangelog -l $(PKG_DIR)/pkg_specs/eth-node/eth-node.changelog -S Version 2>/dev/null | sed 's/-.*//')
SOURCE_DIR_eth-node := $(WORK_DIR)/eth-node/$(VERSION_NUMBER_eth-node)/eth-node-$(VERSION_NUMBER_eth-node)
SOURCE_DIR_PARENT_eth-node := $(dir $(SOURCE_DIR_eth-node))
DEBCRAFTER_PKG_DIR_eth-node := $(PKG_DIR)/pkg_specs/eth-node
DEBIAN_DIR_eth-node := $(PKG_DIR)/eth-node/eth-node-$(VERSION_NUMBER_eth-node)/debian
DEPS_eth-node := $(SOURCE_DIR_eth-node)/debian

# 5. Copy the debcrafter directory from pkg_config
define COPY_DEBCRAFTER_DIR_template
$(DEPS_$1): $$(DEBIAN_DIR_$1) $$(SOURCE_DIR_$1)
	@echo "Dependencies for $$@: $$^"
	@echo "Copying source $$@"
	@cp -R $$(DEBIAN_DIR_$1) $$(SOURCE_DIR_$1)
	@cp -R $$(PC_DIR_$1) $$(SOURCE_DIR_$1)
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
# 6. Build the source, add dependencies for $_setup 
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


# syntax doesn't have to be the same as template, but kept it for sake of being the same
eth-node: $(DEPS_eth-node) 
	@echo "Client eth-node $*"
	@echo "Building debian packages $@"
	@cd ${SOURCE_DIR_eth-node} &&  dpkg-buildpackage -us -uc

# we need source dir, but that dir will be empty
$(DEPS_eth-node): $(DEBIAN_DIR_eth-node) $(SOURCE_DIR_eth-node)
	@echo "Dependencies for $@: $^"
	@echo "Copying source $@"
	@cp -R $(DEBIAN_DIR_eth-node) $(SOURCE_DIR_eth-node)

# empty source dir, as eth-node is virtual package
$(SOURCE_DIR_eth-node): 
	@echo "Dependencies for $@: $^"
	@mkdir -p $@ 

$(DEBIAN_DIR_eth-node): $(DEBCRAFTER_PKG_DIR_eth-node) 
	@echo "Dependencies for $@: $^"
	@echo "Creating debian folder with debcrafter $@"
	@echo "folder: $<"
	@debcrafter $</eth-node.sss ${PKG_DIR}/eth-node --split-source

$(DEBCRAFTER_PKG_DIR_eth-node):
	@echo "Dependencies for $@: $^"
	@if [ ! -d "$@" ]; then \
	echo "Error: $@ directory does not exist. You cannot create packages without it." && exit 1; \
	fi


PHONIES:= all $(CLIENTS) list eth-node

#HELPERS
list: 
	@echo "$(PHONIES)"
clients: 
	@echo "$(CLIENTS)"


patch-setup: 
	@cp $(PKG_DIR)/tools/.quiltrc-dpkg $(HOME) 
	@echo 'alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"' >> ${HOME}/.bashrc
	@echo '. /usr/share/bash-completion/completions/quilt' >> ${HOME}/.bashrc
	@echo 'complete -F _quilt_completion $$_quilt_complete_opt dquilt' >> ${HOME}/.bashrc
	@echo "Please source your basrc: source ~/.bashrc" 

GIT_SOURCE_erigon=https://github.com/ledgerwatch/erigon.git
patch-checkout: 
	@if [ -z "$(CLIENT)" ]; then \
		echo "ERROR: CLIENT is not defined. Please run make patch-commit CLIENT=client_name. See make clients for possible list."; \
		exit 1; \
	fi
	
	@mkdir -p /tmp/source-override/
	@cd /tmp/source-override && git clone --depth 1 $(GIT_SOURCE_$(CLIENT)) $(CLIENT) --branch=v$(VERSION_NUMBER_$(CLIENT))
	@cp -R $(DEBIAN_DIR_$(CLIENT)) /tmp/source-override/$(CLIENT)
	@cd /tmp/source-override/$(CLIENT) && mkdir debian/source && touch debian/source/format
	@echo "3.0 (quilt)" > /tmp/source-override/$(CLIENT)/debian/source/format
	@echo "You can enter dir to make changes to code /tmp/source-override/$(CLIENT)"	
	@echo "Upon making changes, you can reenter cd $(PKG_DIR) and execute make patch-commit CLIENT=$(CLIENT)"	
patch-commit: 
	@if [ -z "$(CLIENT)" ]; then \
		echo "ERROR: CLIENT is not defined. Please run make patch-commit CLIENT=client_name. See make clients for possible list."; \
		exit 1; \
	fi
	@# Copy back source-format, currently debcrafter doesn't support quilt 3, might as well add it 
	@cp -R /tmp/source-override/$(CLIENT)/debian/source $(DEBIAN_DIR_$(CLIENT))/debian 
	@cp -R /tmp/source-override/$(CLIENT)/.pc $(DEBIAN_DIR_$(CLIENT)) 
	@cd /tmp/source-override/$(CLIENT) && cp -R $(SOURCE_DIR_erigon)/debian/patches $(DEBIAN_DIR_erigon)

#list the client defined variabls

PHONY: $(PHONIES) 
