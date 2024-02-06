HOME := /home/debian
WORK_DIR := $(HOME)/eth-packages
PKG_DIR := $(HOME)/eth-deb
SHELL := /bin/bash
CODENAME := bookworm

# Client-specific variables
CLIENT := lighthouse
VERSION_NUMBER := $(shell dpkg-parsechangelog -l eth-node-lighthouse.changelog -S Version 2>/dev/null | sed 's/-.*//')
PACKAGING_DIR := $(WORK_DIR)/eth-node-$(CLIENT)/$(VERSION_NUMBER)/eth-node-$(CLIENT)_$(VERSION_NUMBER)
DEPS := $(SOURCE_DIR)/debian

# Git source
GIT_SOURCE := https://github.com/sigp/lighthouse.git

# Targets and rules
all: lighthouse_setup

lighthouse_build: $(DEPS)
	echo "Building debian packages for lighthouse"
	cd $(PACKAGIND_DIR) && dpkg-buildpackage -us -uc

$(DEPS): $(PACKAGING_DIR)
	echo "Copying source $(DEPS)"
	cp -R $(PKG_DIR)/debian_specs/eth-node-$(CLIENT)/eth-node-$(CLIENT).sss $(SOURCE_DIR)
	cp -R $(PKG_DIR)/debian_specs/eth-node-$(CLIENT)/src/* $(SOURCE_DIR)
	echo "Dependencies for $(DEPS): $(SOURCE_DIR)"

$(PACKAGING_DIR):
	echo "Creating packaging directory $(PACKAGING_DIR)"
	debcrafter eth-node-$(CLIENT).sss $(PKG_DIR)/debian_specs/eth-node-$(CLIENT) --split-source


# Git checkout
patch-checkout:
	echo "Checking out source code for $(CLIENT)"
	git clone --depth 1 $(GIT_SOURCE) $(PACKAGING_DIR) --branch=v$(VERSION_NUMBER)

# Clean
clean:
	echo "Cleaning lighthouse directory"
	rm -rf $(PACKAGING_DIR)

