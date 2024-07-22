BIN_DIR := bin
BOOT_DIR ?= $(TARGETBOOT)
SRC_DIR := src

BCC ?= clang

SOURCES := $(shell find $(BOOT_DIR)/$(SRC_DIR) -name '*.c')
HEADERS := $(shell find $(BOOT_DIR)/$(SRC_DIR) -name '*.h')
OBJECTS := $(patsubst %.c,%.o,$(SOURCES))

OUT := $(BOOT_DIR)/$(BIN_DIR)/$(BTARGET)

all: SETUP_BOOT $(OUT)

SETUP_BOOT:
	@mkdir -p $(BOOT_DIR)/$(BIN_DIR)

$(OUT): $(OBJECTS)
	@printf "\tOUT\t\t$@\n"
	@$(BCC) $(OBJECTS) -o $@ -target $(BCTOOLCHAIN) $(BLDFLAGS)

%.o: %.c $(HEADERS)
	@printf "\t$(BCC)\t\t$@\n"
	@$(BCC) $(CFLAGS) -c $< -o $@ -target $(BCTOOLCHAIN) $(BCFLAGS) -I$(BOOT_DIR)/$(BEFILIBPATH)

clean:
	@rm -rf $(BOOT_DIR)/$(BIN_DIR) $(OBJECTS) $(OUT)


dir: $(OUT)
	@mkdir -p test
	@mkdir -p test/EFI/BOOT
	@mkdir -p test/boot
	@cp $(OUT) test/EFI/BOOT/BOOTX64.efi

run: dir
	@qemu-system-x86_64 -m 2G -drive if=pflash,format=raw,readonly=on,file=/usr/share/ovmf/x64/OVMF.fd -drive file=fat:rw:test,media=disk,format=raw -debugcon stdio