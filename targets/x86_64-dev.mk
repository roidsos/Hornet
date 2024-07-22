# Bootloader Config
TARGETBOOT := sboot
BCTOOLCHAIN := x86_64-unknown-windows
BEFILIBPATH := efi

BCFLAGS := -ffreestanding -fshort-wchar -Wno-unused-command-line-argument -Wno-void-pointer-to-int-cast -Wno-int-to-void-pointer-cast -Wno-int-to-pointer-cast
BLDFLAGS := -nostdlib -Wl,-entry:boot_entry -Wl,-subsystem:efi_application -fuse-ld=lld-link

BTARGET := boot.efi

# Kernel Config
KCTOOLCHAIN := x86_64-pc-none-elf
