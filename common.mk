PACKAGE_NAME=$(shell basename $(PWD))

BUILD_DIR=$(shell pwd)/build
INSTALL_DIR=$(shell pwd)/install

BOOST_ROOT=$(shell rosboost-cfg --root)

CMAKE = cmake
CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR)/ \
             -DBOOST_ROOT=$(BOOST_ROOT)\
             -DCMAKE_BUILD_TYPE="Release"


DYNAMIC_GRAPH=$(shell rospack find dynamic-graph)/install/lib/pkgconfig
DG_MIDDLEWARE=$(shell rospack find dg-middleware)/install/lib/pkgconfig
JRL_MATHTOOLS=$(shell rospack find jrl-mathtools)/install/lib/pkgconfig
JRL_MAL=$(shell rospack find jrl-mal)/install/lib/pkgconfig

PKG_CONFIG_PATH=$(DG_MIDDLEWARE):$(DYNAMIC_GRAPH):$(JRL_MAL):$(JRL_MATHTOOLS)


all: install

$(GIT_DIR):
	git clone $(GIT_URL) $(GIT_DIR)
	cd $(GIT_DIR) && git checkout $(GIT_REVISION)
	cd $(GIT_DIR) && git submodule init && git submodule update

cmake: $(PACKAGE_NAME)
	-mkdir -p $(BUILD_DIR)
	export PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	 && cd $(BUILD_DIR) \
	 && $(CMAKE) $(CMAKE_ARGS) $(CMAKE_EXTRA_ARGS) ../$(PACKAGE_NAME)

build: cmake
	export PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS)

install: build
	export PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS) $@

uninstall: cmake
	export PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS) $@

test: build
	export PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS) $@

clean:
	-export PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS) $@

distclean: clean
	-rm -rf $(BUILD_DIR)

wipe:
	-rm -rf build install $(PACKAGE_NAME)

.PHONY: cmake build install uninstall test clean distclean
