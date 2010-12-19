PACKAGE_NAME=$(shell basename $(PWD))

GIT_DIR = $(PACKAGE_NAME)
GIT_URL = git://github.com/laas/$(PACKAGE_NAME).git
GIT_REVISION = master

SRC_DIR=$(shell pwd)/$(GIT_DIR)
INSTALL_DIR=$(shell pwd)/install

all: install

$(GIT_DIR):
	git clone $(GIT_URL) $(GIT_DIR)
	cd $(GIT_DIR) && git checkout $(GIT_REVISION)
	cd $(GIT_DIR) && git submodule init && git submodule update

build: $(GIT_DIR)
	 cd $(SRC_DIR) && python $(SRC_DIR)/setup.py build

install: build
	 cd $(SRC_DIR) && python $(SRC_DIR)/setup.py install --prefix=$(INSTALL_DIR)

distclean:
	-rm -rf $(SRC_DIR)

wipe:
	-rm -rf install $(PACKAGE_NAME)

.PHONY: build install distclean
