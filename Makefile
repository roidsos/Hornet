TARGETS ?= targets
TARGET ?= x86_64-dev

all: TARGET_CHECK setup

TARGET_CHECK:
	@if [ ! -f $(TARGETS)/$(TARGET).mk ]; then \
		echo "Error: Target file $(TARGETS)/$(TARGET).mk does not exist."; \
    	exit 1; \
	fi

include $(TARGETS)/$(TARGET).mk
setup:
	@echo $(CTOOLCHAIN)