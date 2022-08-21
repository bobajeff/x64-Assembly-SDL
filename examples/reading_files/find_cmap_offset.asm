; Copyright 2022 Jeffrey Brusseau
; Licensed under the MIT license. See LICENSE file in the project root for details.

        section .text                  ; section declaration

        global main                    ; c compilers expect main as entry point
        extern printf
force_exit:
; print value in byte format
        mov esi, 0
        lea rdi, [rel force_exit_message]
        mov eax, 0
        call printf wrt ..plt
        jmp exit
parse_table_directory:
; set table info
; verify sfntVersion is 0x00010000
        mov r10, 0
        mov rdx, 4
        lea rsi, [rel buf32]
        mov rdi, [rel fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall
        mov eax, [rel buf32]
        bswap eax                      ; convert to littleendian
        cmp eax, 0x00010000
        jne force_exit
; get numTables
        mov r10, 4                     ; offset 4
        mov rdx, 2                     ; 2 bytes
        lea rsi, [rel numbtables]
; not sure if these need to be set again (they would if overwritten)
        mov rdi, [rel fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall
; - convert to littleendian
        mov ax, [rel numbtables]
        xchg al, ah                    ; swap lower and upper half of ax register
        mov [rel numbtables], ax
; loop through table records to find offsets to cmap
; mov edx, [rel cmap_id]
        mov dword [rel loop_count], 0
; DEBUG
; lea rdi, [rel byte_value_msg]
; mov esi, [rel cmap_id]
; mov eax, 0
; call printf wrt ..plt
find_cmap_loop:
; DEBUG
; lea rdi, [rel loop_msg]
; mov esi, [rel loop_count]
; mov eax, 0
; call printf wrt ..plt
; print numbtables

; offset = index (loop_count) times 16 (bytes)
        mov eax, [rel loop_count]
        mov esi, 0x10                  ; 16 bytes
        mul esi                        ; multiply esi times eax
        add eax, 0x0C                  ; add offset of table records array
; get id at offset
        mov r10, rax                   ; offset
        mov rdx, 4
        lea rsi, [rel buf32]
        mov rdi, [rel fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall

; DEBUG
; mov esi, [rel buf32]
; bswap esi
; lea rdi, [rel byte_value_msg]
; mov eax, 0
; call printf wrt ..plt

; check if id matches cmap id
        mov esi, [rel buf32]
        cmp esi, [rel cmap_id]
        je found_offset

        add dword [rel loop_count], 1
        mov esi, [rel loop_count]
        cmp esi, [rel numbtables]
        jl find_cmap_loop
        ret

found_offset:
; call parse_cmap_table then return from parse_table_directory()
        mov [rel cmap_offset], esi
        lea rdi, [rel found_cmap_msg]
        mov esi, [rel cmap_offset]
        bswap esi
        mov eax, 0
        call printf wrt ..plt
        ret

main:

        push rbp
        mov rbp, rsp

; get file descriptor for ttf file
        mov esi, 0
        lea rdi, [rel file_address]
        mov rax, 2                     ; syscall number (open)
        syscall
        mov [rel fd], eax

        call parse_table_directory

; print clean exit message
        lea rdi, [rel clean_exit_message]
        mov eax, 0
        call printf wrt ..plt
exit:
        mov eax, 0
        leave
        ret

        section .data

file_address:
        db "test_files/fonts/Noto_Sans/NotoSans-Bold.ttf", 0
fd:
        dq 0
buf32:
        db 0x00, 0x00, 0x00, 0x00
buf16:
        db 0x00, 0x00
; format:
; db "%X ", 10, 0
force_exit_message:
        db "Can't parse ttf file. Forcing exit", 10, 0
clean_exit_message:
        db "exited cleanly", 10, 0
; loop_msg:
; db "loop %d", 10, 0
; byte_value_msg:
; db "bytes value %X", 10, 0
found_cmap_msg:
        db "cmap table offset is %X", 10, 0
loop_count:
        db 0x00, 0x00, 0x00, 0x00
; ------------------- data for parsing ttf file --------------------
numbtables:
        db 0x00, 0x00
cmap_offset:
        db 0x00, 0x00, 0x00, 0x00
cmap_id:
        db "cmap"
