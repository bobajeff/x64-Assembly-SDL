#...So linux syscalls use `r10` instead `rcx`

>User-level applications use as integer registers for passing the sequence
>%rdi, %rsi, %rdx, %rcx, %r8 and %r9. **The kernel interface uses %rdi,
>%rsi, %rdx, %r10, %r8 and %r9.**
- [System V Application Binary Interface: AMD64 Architecture Processor Supplement: Draft Version 0.99.6](https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf)