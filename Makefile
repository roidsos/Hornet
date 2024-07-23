include .config

TARGETS ?= targets
TARGET ?= x86_64-dev

KERNEL_CONFIG_PATH := sboot/src/config.h
KCONFIGLIB_URL := https://github.com/ulfalizer/Kconfiglib/archive/refs/heads/master.zip
KCONFIGLIB_ZIP := kconfiglib.zip
KCONFIGLIB_DIR := kconfiglib

# Target to download and extract Kconfiglib if needed
$(KCONFIGLIB_DIR):
	@if [ ! -d "$(KCONFIGLIB_DIR)" ]; then \
		echo "Kconfiglib not found. Downloading..."; \
		curl -L -o $(KCONFIGLIB_ARCHIVE) $(KCONFIGLIB_ZIP); \
		unzip $(KCONFIGLIB_ARCHIVE); \
		mv $(KCONFIGLIB_EXTRACTED_DIR) $(KCONFIGLIB_DIR); \
		rm $(KCONFIGLIB_ARCHIVE); \
	fi

all: TARGET_CHECK boot

.config: $(KCONFIGLIB_DIR)
	@$(KCONFIGLIB_DIR)/Kconfiglib-master/alldefconfig.py
	@$(MAKE) $(KERNEL_CONFIG_PATH)

$(KERNEL_CONFIG_PATH): Kconfig .config
	@$(KCONFIGLIB_DIR)/Kconfiglib-master/genconfig.py --header-path $@

.PHONY: menuconfig
menuconfig: $(KCONFIGLIB_DIR)
	@$(KCONFIGLIB_DIR)/Kconfiglib-master/menuconfig.py
	@$(MAKE) $(KERNEL_CONFIG_PATH)

.PHONY: guiconfig
guiconfig: $(KCONFIGLIB_DIR)
	@$(KCONFIGLIB_DIR)/guiconfig.py
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