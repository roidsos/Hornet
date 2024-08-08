
extern "C" void _start()
{
    asm volatile("outb %%al, %1" : : "a" ('E'), "Nd" (0xe9) : "memory");
    while(1);
}