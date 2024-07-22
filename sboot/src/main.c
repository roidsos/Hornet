#include <efi.h>

EFI_STATUS boot_entry(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{
    SystemTable->ConOut->OutputString(SystemTable->ConOut, L"Hello, World!\r\n");
    for (;;)
        ;
}