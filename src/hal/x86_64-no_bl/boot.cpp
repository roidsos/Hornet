#include <efi/efi.h>

extern "C" EFI_STATUS boot_entry(__attribute__((unused)) EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{
    SystemTable->ConOut->ClearScreen(SystemTable->ConOut);
    SystemTable->ConOut->OutputString(SystemTable->ConOut, (CHAR16*)L"Hello from C++!\r\n"); 
    for (;;)
        ;
}