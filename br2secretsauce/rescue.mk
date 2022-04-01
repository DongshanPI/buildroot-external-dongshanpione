BUILDROOT_RESCUE_PATH=./buildroot_rescue
BUILDROOT_RESCUE_ARGS += BR2_DL_DIR=$(DLDIR) BR2_EXTERNAL="$(EXTERNALS)"

ifndef DEFCONFIG_RESCUE
	$(error DEFCONFIG_RESCUE is not set)
endif

BUILDROOT_RESCUE_ARGS += BR2_DEFCONFIG="$(DEFCONFIG_RESCUE)"

BUILDROOT_RESCUE_ARGS += BR2_CCACHE=y BR2_CCACHE_DIR="$(CCACHEDIR)"

.PHONY: buildroot-rescue

bootstrap.buildroot_rescue.stamp:
	$(MAKE) -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS) defconfig
	touch $@

ifeq ($(BRANCH), master)
buildroot-rescue: $(OUTPUTS) $(DLDIR) $(CCACHEDIR) bootstrap.buildroot_rescue.stamp
# Buildroot generates so much output drone ci can't
# handle it, so tell make to be quiet
	$(MAKE) -s -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS)
else
buildroot-rescue:
	@echo "rescue is only built for master, your branch is $(BRANCH)"
endif

# For CI caching. Download all of the source so you
# can cache it and reuse it for then next build
buildroot-rescue-dl: $(OUTPUTS) $(DLDIR) bootstrap.buildroot_rescue.stamp
	$(MAKE) -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS) source
#	$(call update_git_package,linux,buildroot_rescue)

buildroot-rescue-menuconfig: bootstrap.buildroot_rescue.stamp
	$(MAKE) -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS) menuconfig

buildroot-rescue-savedefconfig: bootstrap.buildroot_rescue.stamp
	$(MAKE) -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS) savedefconfig

buildroot-rescue-linux-menuconfig: bootstrap.buildroot_rescue.stamp
	$(MAKE) -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS) linux-menuconfig

buildroot-rescue-linux-savedefconfig: bootstrap.buildroot_rescue.stamp
	$(MAKE) -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS) linux-update-defconfig

buildroot-rescue-clean: bootstrap.buildroot_rescue.stamp
	$(MAKE) -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS) clean

buildroot-rescue-tryupdate: bootstrap.buildroot_rescue.stamp
	git -C buildroot_rescue pull --ff-only origin master
	$(MAKE) -C buildroot_rescue $(BUILDROOT_RESCUE_ARGS) savedefconfig

clean: buildroot-rescue-clean

dl: buildroot-rescue-dl
