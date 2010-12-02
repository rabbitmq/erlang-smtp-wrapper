APP_NAME:=erlang_smtp

UPSTREAM_GIT:=http://github.com/tonyg/erlang-smtp.git

CHECKOUT_DIR:=$(PACKAGE_DIR)/erlang-smtp-git
SOURCE_DIR:=$(CHECKOUT_DIR)/src
INCLUDE_DIR:=$(CHECKOUT_DIR)/include

$(eval $(call safe_include,$(PACKAGE_DIR)/version.mk))

VERSION:=rmq$(GLOBAL_VERSION)-git$(COMMIT_SHORT_HASH)

define package_targets

$(CHECKOUT_DIR)/.done:
	rm -rf $(CHECKOUT_DIR)
	git clone $(UPSTREAM_GIT) $(CHECKOUT_DIR)
	touch $$@

$(PACKAGE_DIR)/version.mk: $(CHECKOUT_DIR)/.done
	echo COMMIT_SHORT_HASH:=`git --git-dir=$(CHECKOUT_DIR)/.git log -n 1 --format=format:"%h" HEAD` >$$@

$(EBIN_DIR)/$(APP_NAME).app: $(SOURCE_DIR)/$(APP_NAME).app $(PACKAGE_DIR)/version.mk
	@mkdir -p $$(@D)
	sed -e 's|{vsn, *\"[^\"]*\"|{vsn,\"$(VERSION)\"|' <$$< >$$@

$(PACKAGE_DIR)+clean::
	rm -rf $(CHECKOUT_DIR) $(EBIN_DIR)/$(APP_NAME).app $(PACKAGE_DIR)/version.mk

endef
