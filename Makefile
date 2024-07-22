include .config

TARGETS ?= targets
TARGET ?= x86_64-dev

# TODO: choose a better place for config.h
KERNEL_CONFIG_PATH := config.h

all: TARGET_CHECK boot

.config:
	@utils/kconfiglib/alldefconfig.py
	@$(MAKE) $(KERNEL_CONFIG_PATH)

$(KERNEL_CONFIG_PATH): Kconfig .config
	@utils/kconfiglib/genconfig.py --header-path $@

.PHONY: menuconfig
menuconfig:
	@utils/kconfiglib/menuconfig.py
	@$(MAKE) $(KERNEL_CONFIG_PATH)

.PHONY: guiconfig
guiconfig:
	@utils/kconfiglib/guiconfig.py
	@$(MAKE) $(KERNEL_CONFIG_PATH)

TARGET_CHECK:
	@if [ ! -f $(TARGETS)/$(TARGET).mk ]; then \
		echo "Error: Target file $(TARGETS)/$(TARGET).mk does not exist."; \
		exit 1; \
	fi

include $(TARGETS)/$(TARGET).mk
boot: BOOT_CHECK

BOOT_CHECK:
	@if [ ! -f $(TARGETBOOT)/boot.mk ]; then \
		echo "Error: TARGETBOOT file $(TARGETBOOT)/boot.mk does not exist."; \
		exit 1; \
	fi

include $(TARGETBOOT)/boot.mk

.PHONY: cleandist
cleandist:
	@rm -f $(KERNEL_CONFIG_PATH) .config