# Copyright (c) 2018-2021 Status Research & Development GmbH. Licensed under
# either of:
# - Apache License, version 2.0
# - MIT license
# at your option. This file may not be copied, modified, or distributed except
# according to those terms.

.PHONY: \
	sanity-checks \
	warn-update \
	warn-jobs \
	deps-common \
	build-nim \
	update-test \
	update-common \
	$(NIM_BINARY) \
	update-remote \
	nat-libs \
	libminiupnpc.a \
	libnatpmp.a \
	clean-cross \
	clean-common \
	mrproper \
	github-ssh \
	status \
	ntags \
	ctags \
	show-deps \
	fetch-dlls

#- when the special ".SILENT" target is present, all recipes are silenced as if they all had a "@" prefix
#- by setting SILENT_TARGET_PREFIX to a non-empty value, the name of this target becomes meaningless to `make`
#- idea stolen from http://make.mad-scientist.net/managing-recipe-echoing/
$(SILENT_TARGET_PREFIX).SILENT:

# dir
build:
	mkdir -p $@

sanity-checks:
	which $(CC) &>/dev/null || { echo "C compiler ($(CC)) not installed. Aborting."; exit 1; }

#- check if "make update" was executed
warn-update:
	if [[ -e $(UPDATE_TIMESTAMP) ]]; then \
		if [[ $$(cat $(UPDATE_TIMESTAMP)) -ne $$($(GET_CURRENT_COMMIT_TIMESTAMP)) ]]; then \
			echo -e "\nWarning: to ensure you are building in a supported repo state, please always run \"$$(basename "$(MAKE)") update\" after \"git pull\"\n(it looks like you've forgotten to do this).\nThis also applies whenever you switch to a new branch or commit, e.g.: whenever you run \"git checkout ...\".\n"; \
		fi; \
	fi

#- check if we're enabling multiple jobs - https://stackoverflow.com/a/48865939
warn-jobs:
	+ if [[ ! "${MAKEFLAGS}" =~ --jobserver[^=]+= ]]; then \
		NPROC=$$($(NPROC_CMD)); \
		if [[ $${NPROC} -gt 1 ]]; then \
			echo -e "\nTip of the day: this will probably build faster if you use \"$$(basename "$(MAKE)") -j$${NPROC} ...\".\n"; \
		fi; \
	fi

nimbus-build-system-paths:
	echo "Creating nimbus-build-system.paths"; \
	TOP_LEVEL_DIR="$(CURDIR)" "$(CURDIR)/$(BUILD_SYSTEM_DIR)/scripts/create_nbs_paths.sh"

deps-common: | sanity-checks warn-update warn-jobs $(NIMBLE_DIR)
# - don't build our Nim target if it's not going to be used
ifeq ($(USE_SYSTEM_NIM), 0)
deps-common: $(NIM_BINARY)
endif

#- conditionally re-builds the Nim compiler (not usually needed, because `make update` calls this rule; delete $(NIM_BINARY) to force it)
#- allows parallel building with the '+' prefix
#- handles the case where NIM_COMMIT was previously used to build a non-default compiler
#- forces a rebuild of csources, Nimble and a complete compiler rebuild, in case we're called after pulling a new Nim version
#- uses our Git submodules for csources and Nimble (Git doesn't let us place them in another submodule)
#- build_all.sh looks at the parent dir to decide whether to copy the resulting csources binary there,
#  but this is broken when using symlinks, so build csources separately (we get parallel compiling as a bonus)
#- Windows is a special case, as usual
#- macOS is also a special case, with its "ln" not supporting "-r"
#- the AppVeyor 32-bit build is done on a 64-bit image, so we need to override the architecture detection with ARCH_OVERRIDE
build-nim: | sanity-checks

# Check if the update might cause loss of work. Abort, if so, while allowing an override mechanism.
update-test:
	TEE_TO_TTY="cat"; if bash -c ": >/dev/tty" &>/dev/null; then TEE_TO_TTY="tee /dev/tty"; fi; \
	COMMAND="git status --short --untracked-files=no --ignore-submodules=untracked"; \
	LINES=$$({ $${COMMAND} | grep 'vendor' && echo ^---top level || true; git submodule foreach --recursive --quiet "$${COMMAND} | grep . && echo ^---\$$name || true"; } | $${TEE_TO_TTY} | wc -l); \
	if [[ "$${LINES}" -ne "0" && "$(OVERRIDE)" != "1" ]]; then echo -e "\nYou have uncommitted local changes which might be overwritten by the update. Aborting.\nIf you know better, you can use the 'update' target instead of 'update-dev'.\n"; exit 1; fi

#- for each submodule, delete checked out files (that might prevent a fresh checkout); skip dotfiles
#- in case of submodule URL changes, propagates that change in the parent repo's .git directory
#- initialises and updates the Git submodules
#- hard-resets the working copies of submodules
#- deletes "nimcache" directories
#- updates ".update.timestamp"
#- deletes the ".nimble" dir and executes the "deps" target
#- allows parallel building with the '+' prefix
#- rebuilds the Nim compiler if the corresponding submodule is updated
update-common: | sanity-checks update-test

# supposed to be used by developers, instead of "update", to avoid losing submodule work
update-dev:
	+ "$(MAKE)" OVERRIDE=0 update

#- rebuilds the Nim compiler if the corresponding submodule is updated
$(NIM_BINARY): | sanity-checks
	+ "$(MAKE)" --no-print-directory build-nim

# don't use this target, or you risk updating dependency repos that are not ready to be used in Nimbus
update-remote:
	git submodule update --remote

nat-libs: | libminiupnpc.a libnatpmp.a

libminiupnpc.a: | sanity-checks
ifeq ($(OS), Windows_NT)
	+ [ -e vendor/nim-nat-traversal/vendor/miniupnp/miniupnpc/$@ ] || \
		PATH=".;$${PATH}" "$(MAKE)" -C vendor/nim-nat-traversal/vendor/miniupnp/miniupnpc -f Makefile.mingw CC=$(CC) CFLAGS="-Os -fPIC" $@ $(HANDLE_OUTPUT)
else
	+ "$(MAKE)" -C vendor/nim-nat-traversal/vendor/miniupnp/miniupnpc CC=$(CC) CFLAGS="-Os -fPIC" build/$@ $(HANDLE_OUTPUT)
endif

libnatpmp.a: | sanity-checks
ifeq ($(OS), Windows_NT)
	+ "$(MAKE)" -C vendor/nim-nat-traversal/vendor/libnatpmp-upstream OS=mingw CC=$(CC) CFLAGS="-Wall -Wno-cpp -Os -fPIC -DWIN32 -DNATPMP_STATICLIB -DENABLE_STRNATPMPERR -DNATPMP_MAX_RETRIES=4 $(CFLAGS)" $@ $(HANDLE_OUTPUT)
else
	+ "$(MAKE)" CFLAGS="-Wall -Wno-cpp -Os -fPIC -DENABLE_STRNATPMPERR -DNATPMP_MAX_RETRIES=4 $(CFLAGS)" -C vendor/nim-nat-traversal/vendor/libnatpmp-upstream CC=$(CC) $@ $(HANDLE_OUTPUT)
endif

#- depends on Git submodules being initialised
#- fakes a Nimble package repository with the minimum info needed by the Nim compiler
#  for runtime path (i.e.: the second line in $(NIMBLE_DIR)/pkgs/*/*.nimble-link)
$(NIMBLE_DIR):
	mkdir -p $(NIMBLE_DIR)/pkgs
	NIMBLE_DIR="$(CURDIR)/$(NIMBLE_DIR)" PWD_CMD="$(PWD)" EXCLUDED_NIM_PACKAGES="$(EXCLUDED_NIM_PACKAGES)" \
		git submodule foreach --recursive --quiet '"$(CURDIR)/$(BUILD_SYSTEM_DIR)/scripts/create_nimble_link.sh" "$$sm_path"'

clean-cross:
	+ [[ -e vendor/nim-nat-traversal/vendor/miniupnp/miniupnpc ]] && "$(MAKE)" -C vendor/nim-nat-traversal/vendor/miniupnp/miniupnpc CC=$(CC) clean $(HANDLE_OUTPUT) || true
	+ [[ -e vendor/nim-nat-traversal/vendor/libnatpmp-upstream ]] && "$(MAKE)" -C vendor/nim-nat-traversal/vendor/libnatpmp-upstream CC=$(CC) clean $(HANDLE_OUTPUT) || true

clean-common: clean-cross
	rm -rf build/{*.exe,*.so,*.so.0} $(NIMBLE_DIR) $(NIM_BINARY) $(NIM_DIR)/bin/{timestamp,last_built_commit,nim_commit_*} $(NIM_DIR)/nimcache nimcache

# dangerous cleaning, because you may have not-yet-pushed branches and commits in those vendor repos you're about to delete
mrproper: clean
	rm -rf vendor

# for when you want to use SSH keys with GitHub
github-ssh:
	git config url."git@github.com:".insteadOf "https://github.com/"
	git submodule foreach --recursive 'git config url."git@github.com:".insteadOf "https://github.com/"'

# runs `git status` in all Git repos
status: | $(REPOS)
	$(eval CMD := $(GIT_STATUS))
	$(RUN_CMD_IN_ALL_REPOS)

# https://bitbucket.org/nimcontrib/ntags/ - currently fails with "out of memory"
ntags:
	ntags -R .

#- a few files need to be excluded because they trigger an infinite loop in https://github.com/universal-ctags/ctags
#- limiting it to Nim files, because there are a lot of C files we don't care about
ctags:
	ctags -R --verbose=yes \
	--langdef=nim \
	--langmap=nim:.nim \
	--regex-nim='/(\w+)\*?\s*=\s*object/\1/c,class/' \
	--regex-nim='/(\w+)\*?\s*=\s*enum/\1/e,enum/' \
	--regex-nim='/(\w+)\*?\s*=\s*tuple/\1/t,tuple/' \
	--regex-nim='/(\w+)\*?\s*=\s*range/\1/s,subrange/' \
	--regex-nim='/(\w+)\*?\s*=\s*proc/\1/p,proctype/' \
	--regex-nim='/proc\s+(\w+)/\1/f,procedure/' \
	--regex-nim='/func\s+(\w+)/\1/f,procedure/' \
	--regex-nim='/method\s+(\w+)/\1/m,method/' \
	--regex-nim='/proc\s+`([^`]+)`/\1/o,operator/' \
	--regex-nim='/template\s+(\w+)/\1/u,template/' \
	--regex-nim='/macro\s+(\w+)/\1/v,macro/' \
	--languages=nim \
	--exclude=nimcache \
	--exclude='*/Nim/tinyc' \
	--exclude='*/Nim/tests' \
	--exclude='*/Nim/csources' \
	--exclude=nimbus/genesis_alloc.nim \
	--exclude=$(REPOS_DIR)/nim-bncurve/tests/tvectors.nim \
	.

# list all Git submodule URLs and commit hashes, including the nested ones
show-deps:
	{ "$(CURDIR)/$(BUILD_SYSTEM_DIR)/scripts/git_show_deps.sh" ;\
		git submodule foreach --quiet --recursive "$(CURDIR)/$(BUILD_SYSTEM_DIR)/scripts/git_show_deps.sh"; } \
		| sort -u

############################
# Windows-specific section #
############################

ifeq ($(OS), Windows_NT)
  # no tabs allowed for indentation here

  # the AppVeyor 32-bit build is done on a 64-bit image, so we need to override the architecture detection
  ifeq ($(ARCH_OVERRIDE), x86)
    ARCH := x86
  else
    ifeq ($(PROCESSOR_ARCHITEW6432), AMD64)
      ARCH := x64
    else
      ifeq ($(PROCESSOR_ARCHITECTURE), AMD64)
        ARCH := x64
      endif
      ifeq ($(PROCESSOR_ARCHITECTURE), x86)
        ARCH := x86
      endif
    endif
  endif

  ifeq ($(ARCH), x86)
    ROCKSDB_DIR := x86
  endif
  ifeq ($(ARCH), x64)
    ROCKSDB_DIR := x64
  endif

  ROCKSDB_ARCHIVE := nimbus-deps.zip
  ROCKSDB_URL := https://github.com/status-im/nimbus-deps/releases/download/rocksdb-9.1.0/$(ROCKSDB_ARCHIVE)
  CURL := curl -O -L
  UNZIP := unzip -o

#- back to tabs
#- copied from .appveyor.yml
#- this is why we can't delete the whole "build" dir in the "clean" target
fetch-dlls: | build
	cd build && \
		$(CURL) $(ROCKSDB_URL) && \
		$(CURL) https://nim-lang.org/download/dlls.zip && \
		$(UNZIP) $(ROCKSDB_ARCHIVE) && \
		cp -a $(ROCKSDB_DIR)/*.dll . && \
		$(UNZIP) dlls.zip
endif
