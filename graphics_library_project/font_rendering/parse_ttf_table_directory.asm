; Copyright 2022 Jeffrey Brusseau
; Licensed under the MIT license. See LICENSE file in the project root for details.

        section .text                  ; section declaration

        global parse_table_directory
        extern printf, parse_cmap
check_failed:
        mov eax, 2
        ret
find_table:
        mov [rel table_id], rdi
; loop through table records to find offsets to cmap
        mov dword [rel loop_count], 0
find_table_loop:
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

; check if id matches table id
        mov esi, [rel buf32]
        cmp esi, [rel table_id]
        je found_offset

        add dword [rel loop_count], 1
        mov esi, [rel loop_count]
        cmp esi, [rel numbtables]
        jl find_table_loop
        mov eax, 0
        ret

parse_table_directory: ;args file_descriptor, 
        mov [rel fd], rdi
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
        jne check_failed
; get numTables
        mov r10, 4                     ; offset 4
        mov rdx, 2                     ; 2 bytes
        lea rsi, [rel numbtables]
        mov rax, 17                    ; syscall number (pread64)
        syscall
; - convert to littleendian
        mov ax, [rel numbtables]
        xchg al, ah                    ; swap lower and upper half of ax register
        mov [rel numbtables], ax

        mov rdi, [rel cmap_id]
        call find_table
        ; set cmap to 1 if found
        mov [rel cmap], al
        ; set cmap_offset
        mov eax, [rel offset]
        mov [rel cmap_offset], eax

        mov rdi, [rel loca_id]
        call find_table
        ; set loca to 1 if found
        mov [rel loca], al
        ; set loca_offset
        mov eax, [rel offset]
        mov [rel loca_offset], eax

        mov rdi, [rel glyf_id]
        call find_table
        ; set glyf to 1 if found
        mov [rel glyf], al
        ; set glyf_offset
        mov eax, [rel offset]
        mov [rel glyf_offset], eax

        ;skip parsing cmap if table/offset not found
        mov al, [rel cmap]
        cmp al, 1
        jne no_cmap
        mov esi, [rel cmap_offset]
        lea rdi, [rel found_cmap_msg]
        bswap esi
        mov eax, 0
        call printf wrt ..plt
        ; call parse_cmap wrt ..plt
no_cmap:

        ret


found_offset:
        mov [rel offset], esi
        lea rdi, [rel found_table_msg]
        bswap esi
        mov eax, 0
        call printf wrt ..plt
        mov eax, 1
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
found_table_msg:
        db "table offset is %X", 10, 0
found_cmap_msg:
        db "cmap offset is %X", 10, 0
loop_count:
        db 0x00, 0x00, 0x00, 0x00
; ------------------- data for parsing ttf file --------------------
numbtables:
        db 0x00, 0x00
cmap_offset:
        db 0x00, 0x00, 0x00, 0x00
loca_offset:
db 0x00, 0x00, 0x00, 0x00
glyf_offset:
db 0x00, 0x00, 0x00, 0x00
table_id:
        db 0x00, 0x00, 0x00, 0x00
offset:
        db 0x00, 0x00, 0x00, 0x00
cmap_id:
        db "cmap"
loca_id:
        db "loca"
glyf_id:
        db "glyf"
offset_data_address:
        db 0x00, 0x00, 0x00, 0x00
cmap:
    db 0
loca:
    db 0
glyf:
    db 0
