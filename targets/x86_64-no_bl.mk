BIN_DIR := bin
SRC_DIR := src

CXX ?= clang++
ASM ?= nasm

HAL_SOURCES  := $(shell find src/hal/$(TARGET) -name '*.cpp')
HAL_HEADERS  := $(shell find src/hal/$(TARGET) -name '*.h')
CORE_SOURCES := $(shell find src/core/         -name '*.cpp')
CORE_HEADERS := $(shell find src/core/         -name '*.h')
NASM_SOURCES := $(shell find src/              -name '*.asm')
OBJECTS := $(patsubst src/%,bin/%, $(patsubst %.cpp,%.cpp.o,$(HAL_SOURCES) $(CORE_SOURCES)) $(patsubst %.asm,%.asm.o,$(NASM_SOURCES))) 

CXXFLAGS := -ffreestanding \
-Wall \
-Wextra \
-Werror \
-std=c++17 \
-fno-exceptions \
-fno-stack-protector \
-fno-stack-check \
-fno-rtti \
-fno-lto \
-fno-pic \
-mcmodel=kernel \
-mabi=sysv \
-mno-80387 \
-mno-mmx \
-mno-3dnow \
-mno-sse \
-mno-sse2 \
-mno-red-zone \
-Isrc \
-Ilib
ASMFLAGS := -f elf64 -g
LDFLAGS := -nostdlib -Wl,-entry:boot_entry -Wl,-subsystem:efi_application -fuse-ld=lld-link

CLANG_TARGET = x86_64-unknown-windows

OUT := $(BIN_DIR)/hornet.efi

all: $(OUT)

setup:
	@if [ ! -d "lib/efi" ]; then \
		mkdir -p lib; \
		cd lib && git clone https://github.com/aurixos/efi && cd ..; \
	fi
	@mkdir -p $(BIN_DIR)

$(OUT): $(OBJECTS)
	@printf "\tLINK\t\t$@\n"
	@$(CXX) $(OBJECTS) -o $@ -target $(CLANG_TARGET) $(LDFLAGS)

bin/%.cpp.o: src/%.cpp $(HEADERS)
	@printf "\t$(CXX)\t\t$@\n"
	@mkdir -p $(@D)
	@$(CXX) $(CFLAGS) -c $< -o $@ -target $(CLANG_TARGET) $(CXXFLAGS)
bin/%.asm.o: src/%.asm $(HEADERS)
	@printf "\t$(CXX)\t\t$@\n"
	@mkdir -p $(@D)
	@$(ASM) $(ASMFLAGS) $< -o $@

clean:
	@rm -rf $(BIN_DIR)