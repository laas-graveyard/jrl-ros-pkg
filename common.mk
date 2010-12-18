PACKAGE_NAME=$(shell basename $(PWD))

BUILD_DIR=$(shell pwd)/build
INSTALL_DIR=$(shell pwd)/install

BOOST_ROOT=$(shell rosboost-cfg --root)

CMAKE = cmake
CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR)/ \
             -DBOOST_ROOT=$(BOOST_ROOT)\
             -DCMAKE_BUILD_TYPE="Release"

PKGCONFIGDIR=install/lib/pkgconfig

JRL_MATHTOOLS=$(shell rospack find jrl-mathtools)/$(PKGCONFIGDIR)
JRL_MAL=$(shell rospack find jrl-mal)/$(PKGCONFIGDIR)
ABSTRACT_ROBOT_DYNAMICS=\
 $(shell rospack find abstract-robot-dynamics)/$(PKGCONFIGDIR)
HRP2_DYNAMICS=\
 $(shell rospack find hrp2-dynamics)/$(PKGCONFIGDIR)
HRP2_10_OPTIMIZED=\
 $(shell rospack find hrp2-10-optimized)/$(PKGCONFIGDIR)
HRP2_14=\
 $(shell rospack find hrp2-14)/$(PKGCONFIGDIR)
HRP2_10=\
 $(shell rospack find hrp2-10)/$(PKGCONFIGDIR)
JRL_DYNAMICS=$(shell rospack find jrl-dynamics)/$(PKGCONFIGDIR)
JRL_WALKGEN=$(shell rospack find jrl-walkgen)/$(PKGCONFIGDIR)
DYNAMIC_GRAPH=$(shell rospack find dynamic-graph)/$(PKGCONFIGDIR)
DG_MIDDLEWARE=$(shell rospack find dg-middleware)/$(PKGCONFIGDIR)
SOT_CORE=$(shell rospack find sot-core)/$(PKGCONFIGDIR)
SOT_DYNAMIC=$(shell rospack find sot-dynamic)/$(PKGCONFIGDIR)
SOT_PATTERN_GENERATOR=$(shell rospack find sot-pattern-generator)/$(PKGCONFIGDIR)
SOT_OPENHRP=$(shell rospack find sot-openhrp)/$(PKGCONFIGDIR)
SOT_OPENHRP_SCRIPTS=$(shell rospack find sot-openhrp-scripts)/$(PKGCONFIGDIR)


PKG_CONFIG_PATH=$(JRL_MATHTOOLS):$(JRL_MAL):$(ABSTRACT_ROBOT_DYNAMICS):$(HRP2_14):$(HRP2_10):$(HRP2_DYNAMICS):$(HRP2_10_OPTIMIZED):$(JRL_DYNAMICS):$(JRL_WALKGEN):$(DYNAMIC_GRAPH):$(DG_MIDDLEWARE):$(SOT_CORE):$(SOT_DYNAMIC):$(SOT_PATTERN_GENERATOR):$(SOT_OPENHRP):$(SOT_OPENHRP_SCRIPTS)


all: install

$(GIT_DIR):
	git clone $(GIT_URL) $(GIT_DIR)
	cd $(GIT_DIR) && git checkout $(GIT_REVISION)
	cd $(GIT_DIR) && git submodule init && git submodule update

cmake: $(PACKAGE_NAME)
	-mkdir -p $(BUILD_DIR)
	export PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" \
	 && cd $(BUILD_DIR) \
	 && $(CMAKE) $(CMAKE_ARGS) $(CMAKE_EXTRA_ARGS) ../$(PACKAGE_NAME)

build: cmake
	export PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS)

install: build
	export PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS) $@

uninstall: cmake
	export PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS) $@

test: build
	export PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS) $@

clean:
	-export PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" \
	 && cd $(BUILD_DIR) && make $(ROS_PARALLEL_JOBS) $@

distclean: clean
	-rm -rf $(BUILD_DIR)

wipe:
	-rm -rf build install $(PACKAGE_NAME)

.PHONY: cmake build install uninstall test clean distclean
