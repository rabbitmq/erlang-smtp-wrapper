APP_NAME:=erlang_smtp

UPSTREAM_GIT:=http://github.com/tonyg/erlang-smtp.git

EBIN_DIR:=$(PACKAGE_DIR)/ebin
CHECKOUT_DIR:=$(PACKAGE_DIR)/erlang-smtp-git
SOURCE_DIR:=$(CHECKOUT_DIR)/src
INCLUDE_DIR:=$(CHECKOUT_DIR)/include

$(CHECKOUT_DIR)_UPSTREAM_GIT:=$(UPSTREAM_GIT)
$(CHECKOUT_DIR):
	git clone $($@_UPSTREAM_GIT) $@

$(CHECKOUT_DIR)/stamp: | $(CHECKOUT_DIR)
	rm -f $@
	cd $(@D) && echo COMMIT_SHORT_HASH:=$$(git log -n 1 --format=format:"%h" HEAD) > $@

$(PACKAGE_DIR)/clean_RM:=$(CHECKOUT_DIR) $(CHECKOUT_DIR)/stamp $(EBIN_DIR)/$(APP_NAME).app
$(PACKAGE_DIR)/clean::
	rm -rf $($@_RM)

ifneq "$(strip $(patsubst clean%,,$(patsubst %clean,,$(TESTABLEGOALS))))" ""
include $(CHECKOUT_DIR)/stamp

VERSION:=rmq$(GLOBAL_VERSION)-git$(COMMIT_SHORT_HASH)

$(EBIN_DIR)/$(APP_NAME).app.$(VERSION)_VERSION:=$(VERSION)
$(EBIN_DIR)/$(APP_NAME).app.$(VERSION): $(SOURCE_DIR)/$(APP_NAME).app | $(EBIN_DIR)
	sed -e 's/{vsn, *\"[^\"]\+\"/{vsn,\"$($@_VERSION)\"/' < $< > $@

$(PACKAGE_DIR)_APP:=true
endif
