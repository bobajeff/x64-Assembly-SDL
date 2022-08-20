; Copyright 2022 Jeffrey Brusseau
; Licensed under the MIT license. See LICENSE file in the project root for details.

        section .text                  ; section declaration

        global main                    ; c compilers expect main as entry point
        extern printf
main:

        push rbp
        mov rbp, rsp

; get file descriptor for ttf file
        mov esi, 0
        lea rdi, [rel file_address]
        mov rax, 2                     ; syscall number (open)
        syscall
        mov [rel fd], eax

; read 4 bytes at offset 0
        mov r10, 0
        mov rdx, 4
        lea rsi, [rel buf]
        mov rdi, [rel fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall

; convert to littleendian
        mov eax, [rel buf]
        bswap eax
        mov [rel buf], eax

; print value in byte format
        mov esi, [rel buf]
        lea rdi, [rel format]
        mov eax, 0
        call printf wrt ..plt

        mov eax, 0
        leave
        ret
        section .data                  ; section declaration
file_address:
        db "test_files/fonts/Noto_Sans/NotoSans-Bold.ttf", 0
fd:
        dq 0
buf:
        db 0x00, 0x00, 0x00, 0x00
format:
        db "%X ", 0
