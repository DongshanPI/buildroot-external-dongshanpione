################################################################################
#
# SANDer
#
################################################################################

SNANDER_VERSION = 1d2442a94d71ddd0b73764317f775774aa2f9a8c
SNANDER_SITE = https://github.com/fifteenhex/SNANDer.git
SNANDER_SITE_METHOD = git
HOST_SNANDER_DEPENDENCIES = host-pkgconf host-libusb host-libusb-compat

define HOST_SNANDER_BUILD_CMDS
	$(MAKE) PKG_CONFIG=$(HOST_DIR)/bin/pkgconf -C $(@D)/src
endef

$(eval $(host-generic-package))
