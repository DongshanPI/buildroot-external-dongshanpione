AUTOSSHKEY_VERSION = 0.1
AUTOSSHKEY_SITE = $(BR2_EXTERNAL_AUTOSSHKEY_PATH)/package/autosshkey
AUTOSSHKEY_SITE_METHOD = local


define AUTOSSHKEY_GENERATEKEYS
	mkdir -p $(BASE_DIR)/sshkeys
	for user in $(BR2_PACKAGE_AUTOSSHKEY_USERS); do \
		if [ ! -e $(BASE_DIR)/sshkeys/$$user ]; then \
			ssh-keygen -t rsa -f $(BASE_DIR)/sshkeys/$$user -P ""; \
	 	fi; \
		mkdir -p $(TARGET_DIR)/home/$$user/.ssh/; \
		cp $(BASE_DIR)/sshkeys/$$user.pub $(TARGET_DIR)/home/$$user/.ssh/authorized_keys; \
	done

	mkdir -p $(TARGET_DIR)/etc/sudoers.d/
	for user in $(BR2_PACKAGE_AUTOSSHKEY_SUDOUSERS); do \
		echo "$$user ALL=(ALL) NOPASSWD:ALL" >> $(TARGET_DIR)/etc/sudoers.d/sudousers; \
	done
endef

AUTOSSHKEY_TARGET_FINALIZE_HOOKS += AUTOSSHKEY_GENERATEKEYS

$(eval $(generic-package))
