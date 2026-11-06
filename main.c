// runs PCMPESTRI xmm0, xmm1, 0 with EAX = EDX = 0x80000000 in unicorn.
// real hardware runs this fine.
// on the vulnerable build this exits with 0xC0000005 in pcmpxstrx() (ops_sse.h).
#include <stdio.h>
#include <stdint.h>
#include <unicorn/unicorn.h>

static const uint8_t code[] = { 0x66, 0x0F, 0x3A, 0x61, 0xC1, 0x00 };

int main() {
    uc_engine *uc;
    uint64_t eax = 0x80000000, edx = 0x80000000;
    uc_err err;

    setvbuf(stdout, NULL, _IONBF, 0);

    uc_open(UC_ARCH_X86, UC_MODE_64, &uc);
    uc_mem_map(uc, 0x1000, 0x1000, UC_PROT_ALL);
    uc_mem_write(uc, 0x1000, code, sizeof(code));
    uc_reg_write(uc, UC_X86_REG_RAX, &eax);
    uc_reg_write(uc, UC_X86_REG_RDX, &edx);

    printf("[+] instruction: 66 0f 3a 61 c1 00, eax = edx = 0x80000000\n");
    printf("[!] emu_start(count=1)...\n");

    // on the vulnerable build this exits with 0xC0000005
    err = uc_emu_start(uc, 0x1000, 0, 0, 1);

    printf("[?] emu_start returned %d (%s)\n", err, err ? uc_strerror(err) : "OK");
    uc_close(uc);
    return 0;
}
