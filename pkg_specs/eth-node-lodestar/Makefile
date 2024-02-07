HOME := /home/debian
WORK_DIR := $(HOME)/eth-pkg
ETH_DEB_DIR := $(HOME)/eth-deb
SHELL := /bin/bash
CODENAME := bookworm

.SILENT:

# Client-specific variables

CLIENT := lodestar
VERSION_NUMBER := $(shell dpkg-parsechangelog -l eth-node-$(CLIENT).changelog -S Version 2>/dev/null | sed 's/-.*//')
PACKAGE_NAME := eth-node-$(CLIENT)_$(VERSION_NUMBER)
# double dir, as first dir contains debian tarballs
PACKAGING_DIR := $(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME)
TARBALL_URL := https://github.com/ChainSafe/lodestar/archive/refs/tags/v$(VERSION_NUMBER_lodestar).tar.gz

# Git source
GIT_SOURCE := https://github.com/ChainSafe/lodestar.git

.PHONY: setup-quilt build debcrafter
# Targets and rules
all: build-dpkg

# simple build
build-dpkg: $(PACKAGING_DIR)/debian $(PACKAGING_DIR)/debian/src setup-quilt
	echo -e "Building debian packages for $(PACKAGE_NAME)\n"
	cd $(PACKAGING_DIR) && dpkg-buildpackage -us -uc -nc

# whole reproducible build
build-sbuild: $(PACKAGING_DIR) setup-quilt
	echo -e "Building debian packages for $(PACKAGE_NAME)\n"
	cd ${PACKAGING_DIR} && chmod +x debian/rules && sbuild -d $(CODENAME)

# 1. Create packaging folder
$(WORK_DIR)/$(PACKAGE_NAME):
	echo -e "Creating package folder $(WORK_DIR)/$(PACKAGE_NAME)\n"
	mkdir -p $@

# 2. Download the source .orig.tar.gz
$(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME).orig.tar.gz: $(WORK_DIR)/$(PACKAGE_NAME) 
	echo -e "Downloading source $@\n"
	cd $< && wget -O $@ ${TARBALL_URL}

# 3. Extract the source .orig.tar.gz
$(PACKAGING_DIR): $(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME).orig.tar.gz 
	echo -e "Extracting source $@\n"
	mkdir -p $@ && tar -zxvf $(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME).orig.tar.gz -C $@ --strip-components=1 >/dev/null 2>&1

# 4. Create debian dir if not exist 
$(PACKAGING_DIR)/debian: $(PACKAGING_DIR) debcrafter
	echo -e "Creating packaging directory $(PACKAGING_DIR)\n"
	debcrafter eth-node-$(CLIENT).sss /tmp 
	cp -R /tmp/eth-node-$(CLIENT)-$(VERSION_NUMBER)/debian $(PACKAGING_DIR)

# 4.a Patch quilt 
$(PACKAGING_DIR)/debian/source/format: $(PACKAGING_DIR)/debian
	echo -e "Setting up quilt format for patching\n"
	mkdir -p $(PACKAGING_DIR)/debian/source
	echo "3.0 (quilt)" > $(PACKAGING_DIR)/debian/source/format

# 4.b Patch .pc dir setup 
$(PACKAGING_DIR)/debian/.pc/.version: $(PACKAGING_DIR)/debian
	echo -e "Creating necessary directories for patching \n"
	mkdir -p $(PACKAGING_DIR)/.pc
	touch $(PACKAGING_DIR)/.pc/.version
	echo "2" > $(PACKAGING_DIR)/.pc/.version

# 4.c Patch .pc patch version number 
$(PACKAGING_DIR)/debian/control: $(PACKAGING_DIR)/debian/source/format $(PACKAGING_DIR)/.pc/.version
	echo -e "Adding Standards-Version to the control file\n"
	cd $(PACKAGING_DIR)/debian && \
  	{ head -n 3 control; echo "Standards-Version: 4.5.1"; tail -n +4 control; } > control.new && \
  	mv control.new control

# 4.d Copy source dir override if exist 
# This step allows to override generated debian files, or save patched config between versions
$(PACKAGING_DIR)/debian/src: src
	echo -e "Copying source $@\n"
	cp -R src/* $(PACKAGING_DIR)

# setup-quilt for patching
setup-quilt: $(PACKAGING_DIR)
	echo -e "Setting up $@\n"
	echo 'alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"' >> ${HOME}/.bashrc
	cd ${PACKAGING_DIR} && (quilt --quiltrc=$(ETH_DEB_DIR)/tools/.quiltrc-dpkg upgrade 2> /dev/null || true)
	cd ${PACKAGING_DIR} && (quilt --quiltrc=$(ETH_DEB_DIR)/tools/.quiltrc-dpkg push 2> /dev/null || true)


# Git checkout
patch-checkout:
	echo "Checking out source code for $(CLIENT)"
	git clone --depth 1 $(GIT_SOURCE) $(PACKAGING_DIR) --branch=v$(VERSION_NUMBER)

debcrafter: 
	echo "TODO: check if debcrafter is installed"

# Clean
clean:
	echo "Cleaning lighthouse directory"
	rm -rf $(PACKAGING_DIR)

