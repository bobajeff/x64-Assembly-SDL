; Copyright 2022 Jeffrey Brusseau
; Licensed under the MIT license. See LICENSE file in the project root for details.

        DEFAULT REL
        section .text                  ; section declaration

        global parse_cmap
        extern printf, print_byte_array
        HAS_FORMAT_4_TABLE equ 1
cant_parse:
        mov esi, 0
        lea rdi, [cant_parse_msg]
        mov eax, 0
        call printf wrt ..plt
        jmp end_subroutine

look_for_unicode_encoding:
        mov r12d, 0
        ret

parse_cmap:
        mov [cmap_offset], rsi ;this has to be 64 bit value before passing to cmap_offset and then r10 (r10 will change the offset valuwe otherwise)
        mov [fd], rdi

; check version
        mov r10, [cmap_offset]
        mov rdx, 2
        lea rsi, [buf16]
        mov rdi, [fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall

        mov ax, [buf16]
        cmp ax, 0                      ; version should be 0
        jne cant_parse

; check that numbtables=1 since the structure of this cmap table is the only one to understand for now
; get numTables
        mov r10, [cmap_offset]
        add r10, byte 2  ;move address up 2 bytes
        mov rdx, 2
        lea rsi, [buf16]
        mov rdi, [fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall
        ; validate numTables 
        mov ax, [buf16]
        xchg al, ah ;littleendian
        cmp ax, [valid_numtables]
        jne cant_parse

; check that platform and encoding id = 0x00030001 since that's the only encoding to understand for now
        mov r10, [cmap_offset]
        add r10, 4 ;move address up 4 bytes
        mov rdx, 8 ;read 8 bytes
        lea rsi, [record]
        mov rdi, [fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall
        ; validate platformID and encodingID
        mov eax, [record] ;copy first 4 bytes of record to eax
        bswap eax;littleendian
        cmp eax, [valid_platform_and_encoding_id]
        jne cant_parse

        ;get subtable offset
        mov eax, [record + 4]
        bswap eax
        add rax, [cmap_offset]
        mov [subtable_offset], rax

        ;check that subtable format = 0x0004 (Format 4) the only format to understand for now
        mov r10, rax
        mov rdx, 2 ;read 2 bytes
        lea rsi, [buf16]
        mov rdi, [fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall
        ; validate format 
        mov ax, [buf16]
        xchg al, ah ;littleendian
        cmp ax, [valid_format]
        jne cant_parse

        

; ; DEBUG
;         mov [tmp_hold], eax
;         mov esi, 2
;         lea rdi, [buf16]
;         mov eax, 0
;         call print_byte_array wrt ..plt
;         mov eax, [tmp_hold]
end_subroutine:
        lea rdi, [rel found_format_4_msg]
        mov eax, 0
        call printf wrt ..plt

        mov dx, HAS_FORMAT_4_TABLE
        mov rax, [subtable_offset]
        ret
        section .data
cant_parse_msg:
        db "Can't parse cmap table.", 10, 0
fd:
        dq 0
buf32:
        db 0x00, 0x00, 0x00, 0x00
buf16:
        dw 0x0000
cmap_offset:
        dq 0
tmp_hold:
        dd 0
valid_numtables:
        dw 0x0001
valid_platform_and_encoding_id:
        dd 0x00030001                  ; only one to check. for now.
valid_format:
        dw 0x0004
subtable_offset:
        dd 0x00000000                  ; only one to get. for now.
record:
        dq 0
found_format_4_msg:
        db "found 'Format 4' in .ttf file", 10, 0
