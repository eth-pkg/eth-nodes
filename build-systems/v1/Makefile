include Makefile.variables

PACKAGING_DIR := $(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME)
SBUILD_ENV := /tmp/sbuild/$(PACKAGE_NAME)
SBUILD_TARBALL := /srv/chroot/$(CODENAME)-$(ARCH).tar.gz
PACKAGE_NAME := $(CLIENT_FULL_NAME)-$(VERSION_NUMBER)

$(info HOME: $(HOME))
$(info WORK_DIR: $(WORK_DIR))
$(info SHELL: $(SHELL))
$(info CODENAME: $(CODENAME))
$(info CLIENT: $(CLIENT))
$(info CLIENT_FULL_NAME: $(CLIENT_FULL_NAME))
$(info VERSION_NUMBER: $(VERSION_NUMBER))
$(info TARBALL_URL: $(TARBALL_URL))
$(info IS_VIRTUAL_PACKAGE: $(IS_VIRTUAL_PACKAGE))
$(info GIT_SOURCE: $(GIT_SOURCE))

HOST_HOME := /home/debian

.PHONY: setup-quilt build debcrafter
# Targets and rules
all: build 


build: 
	echo "Working in $(CURDIR)"
	echo -e "Building Client:$(CLIENT) VERSION:$(VERSION_NUMBER)\n"
	$(MAKE) build-sbuild

# simple build
build-dpkg: $(PACKAGING_DIR)/debian $(PACKAGING_DIR)/debian/src setup-quilt
	echo -e "Building debian packages for $(PACKAGE_NAME)\n"
	cd $(PACKAGING_DIR) && dpkg-buildpackage -us -uc -nc

# whole reproducible build
build-sbuild: $(PACKAGING_DIR)/debian $(PACKAGING_DIR)/debian/src  setup-quilt
	echo -e "Building debian packages for $(PACKAGE_NAME)\n"
	cd ${PACKAGING_DIR} && chmod +x debian/rules && sbuild -d $(CODENAME)

# 1. Create packaging folder
$(WORK_DIR)/$(PACKAGE_NAME):
	echo -e "Creating package folder $(WORK_DIR)/$(PACKAGE_NAME)\n"
	mkdir -p $@

# 2. Download the source .orig.tar.gz
ifndef IS_VIRTUAL_PACKAGE
$(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME).orig.tar.gz: $(WORK_DIR)/$(PACKAGE_NAME)
	echo -e "Downloading source $@\n"
	cd $< && wget -O $@ ${TARBALL_URL}
else
$(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME).orig.tar.gz:
	echo "Creating empty .tar.gz for virtual package"
	cd $(WORK_DIR)/$(PACKAGE_NAME) && tar czvf $(PACKAGE_NAME).orig.tar.gz --files-from /dev/null
endif

# 3. Extract the source .orig.tar.gz
ifndef IS_VIRTUAL_PACKAGE
$(PACKAGING_DIR): $(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME).orig.tar.gz
	echo -e "Extracting source $@\n"
	mkdir -p $@ && tar -zxvf $(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME).orig.tar.gz -C $@ --strip-components=1 >/dev/null 2>&1
else
$(PACKAGING_DIR): $(WORK_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME).orig.tar.gz
	echo "Skipping source extraction as IS_VIRTUAL_PACKAGE is defined"
	mkdir -p $@
endif

# 4. Create debian dir if not exist 
$(PACKAGING_DIR)/debian: $(PACKAGING_DIR) debcrafter
	echo -e "Creating debian directory $(PACKAGING_DIR)/debian\n"
	debcrafter $(CLIENT_FULL_NAME).sss /tmp 
	cp -R /tmp/$(CLIENT_FULL_NAME)-$(VERSION_NUMBER)/debian $(PACKAGING_DIR)

# 4.a Patch quilt 
$(PACKAGING_DIR)/debian/source/format: $(PACKAGING_DIR)/debian
	echo -e "Setting up quilt format for patching\n"
	mkdir -p $(PACKAGING_DIR)/debian/source
	echo "3.0 (quilt)" > $(PACKAGING_DIR)/debian/source/format

# 4.b Patch .pc dir setup 
$(PACKAGING_DIR)/.pc/.version: $(PACKAGING_DIR)/debian
	echo -e "Creating necessary directories for patching \n"
	mkdir -p $(PACKAGING_DIR)/.pc
	touch $(PACKAGING_DIR)/.pc/.version
	echo "2" > $(PACKAGING_DIR)/.pc/.version

# 4.c Patch .pc patch version number 
$(PACKAGING_DIR)/debian/control: $(PACKAGING_DIR)/debian/source/format $(PACKAGING_DIR)/.pc/.version
	echo -e "Adding Standards-Version to the control file\n"
	#cd $(PACKAGING_DIR)/debian && \
  	# head -n 3 control; echo "Standards-Version: 4.5.1"; tail -n +4 control;  > control.new 
	#cd $(PACKAGING_DIR)/debian && mv control.new control

# 4.d Copy source dir override if exist
# This step allows to override generated debian files, or save patched config between versions
ifeq ($(wildcard src),)
$(PACKAGING_DIR)/debian/src: $(PACKAGING_DIR)/debian/control
	echo "Source directory 'src' not found. Skipping copy."
else
$(PACKAGING_DIR)/debian/src: $(PACKAGING_DIR)/debian/control | src
	echo -e "Copying source $@\n"
	cp -R src/* $(PACKAGING_DIR)
endif


# sbuild setup

# sbuild 1. copy config  
$(HOST_HOME)/.sbuildrc: 
	echo "Copying .sbuildrc"
	cp .sbuildrc-$(CODENAME) /tmp/.sbuildrc

# sbuild 2. create env dir  
$(SBUILD_ENV): 
	echo "Creating SBUILD dir $@"
	sudo mkdir -p $@ 

# sbuild 3. create env, extract tarball  
$(SBUILD_TARBALL): $(HOST_HOME)/.sbuildrc $(SBUILD_ENV)
	echo "Creating sbuild env $@"
	#TODO sudo sbuild-adduser debian > /dev/null 2>&1 || true
	#newgrp sbuild
	#sudo sbuild-createchroot --merged-usr --make-sbuild-tarball=$(SBUILD_TARBALL) $(CODENAME) $(SBUILD_ENV) http://deb.debian.org/debian 


# setup-quilt for patching
setup-quilt: $(PACKAGING_DIR)
	echo -e "Setting up $@\n"
	cp .quiltrc-dpkg /tmp
	cd ${PACKAGING_DIR} && (quilt --quiltrc=/tmp/.quiltrc-dpkg upgrade 2> /dev/null || true)
	rm -f ${PACKAGING_DIR}/.pc/applied-patches
	cd ${PACKAGING_DIR} && (quilt --quiltrc=/tmp/.quiltrc-dpkg push || true)




# Git checkout
patch-checkout:
	echo "Checking out source code for $(PACKAGE_NAME)"
	git clone --depth 1 $(GIT_SOURCE) $(PACKAGING_DIR) --branch=v$(VERSION_NUMBER)

debcrafter: 
	echo "TODO: check if debcrafter is installed"

# Clean
clean:
	echo "Cleaning $(WORK_DIR)/$(PACKAGE_NAME) directory"
	rm -rf $(WORK_DIR)/$(PACKAGE_NAME)

