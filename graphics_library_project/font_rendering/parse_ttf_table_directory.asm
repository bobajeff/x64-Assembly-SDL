; Copyright 2022 Jeffrey Brusseau
; Licensed under the MIT license. See LICENSE file in the project root for details.

        DEFAULT REL
        section .text                  ; section declaration

        global parse_table_directory
        extern printf, print_byte_array, parse_cmap
check_failed:
        mov eax, 2
        ret
find_tables:
; loop through table records to find offsets to cmap
        mov dword [loop_count], 0
find_table_loop:
; offset = index (loop_count) times 16 (bytes)
        mov eax, [loop_count]
        mov esi, 0x10                  ; 16 bytes
        mul esi                        ; multiply esi times eax
        add eax, 0x0C                  ; add offset of table records array
; get id at offset
        mov r10, rax                   ; offset
        mov rdx, 16
        lea rsi, [record]
        mov rdi, [fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall

        mov ax, 0                      ; counter
check_against_table_ids:
; get index based off counter
        lea r12, [outter_index]        ; copy 64bit address of index to rdi
        mov dil, [r12 + rax]           ; copy byte (8bit) value from index at offset in rax
        movzx r12, dil                 ; copy byte value to rdi (64bit) register

; ; get table id base off index
        lea rsi, [table_ids]
        mov esi, [rsi + r12 * 4]

; check if id matches table id
        mov edx, [record]              ; copy first 4 bytes of 'record' buffer
        cmp edx, esi                   ; compare id in 'table_ids' with id in 'record' buffer
        je found_table
        add ax, 1
; loop should run max of 3 times since only 3 tables to check currently
        cmp ax, [number_of_elements_in_index] ; loop quit when number is 3 (so 0 , 1 , 2 )
        jl check_against_table_ids
check_count:
        add dword [loop_count], 1
        mov esi, [loop_count]

        cmp esi, [numbtables]
        jl find_table_loop
end_loop:
        mov eax, 0
        ret

found_table:

; get offset address
        mov edx, [record + 8]
        bswap edx ;convert to littleendian

; copy offset to offsets array
        lea rsi, [offsets]
        mov [rsi + r12 * 4], edx
; mark off table as found
        lea rsi, [table_found]
        mov [rsi + r12], byte 1


; check if element is last in index
        mov dx, [number_of_elements_in_index]
        sub dx, 1                      ; last index would be number_of_elements -1 because zero indexing
        cmp dx, ax                     ; ax (counter) would be the current index
        je shrink_index

; if not last element copy last in its place then shrink index
        lea rdi, [outter_index]        ; copy 64bit address of index to rdi
        movzx rdx, dx                  ; copy 16 bit value to rdx (64bit) register
        mov dl, [rdi + rdx]            ; copy byte (8bit) value from last index
        mov [rdi + rax], dl            ; copy dl to address of current index

shrink_index:
        sub dword [number_of_elements_in_index], 1

; exit loop if there are no elements in index (and found all tables)

        ; mov [tmp_hold], eax
        ; mov esi, 12
        ; lea rdi, [rel offsets]
        ; mov eax, 0
        ; call print_byte_array wrt ..plt
        ; mov eax, [tmp_hold]

        cmp [number_of_elements_in_index], dword 0
        je end_loop

        jmp check_count                ; finish the loop

parse_table_directory:                 ; args file_descriptor,
        mov [fd], rdi
; verify sfntVersion is 0x00010000
        mov r10, 0
        mov rdx, 4
        lea rsi, [buf32]
        mov rdi, [fd]
        mov rax, 17                    ; syscall number (pread64)
        syscall
        mov eax, [buf32]
        bswap eax                      ; convert to littleendian
        cmp eax, 0x00010000
        jne check_failed
; get numTables
        mov r10, 4                     ; offset 4
        mov rdx, 2                     ; 2 bytes
        lea rsi, [numbtables]
        mov rax, 17                    ; syscall number (pread64)
        syscall
; - convert to littleendian
        mov ax, [numbtables]
        xchg al, ah                    ; swap lower and upper half of ax register
        mov [numbtables], eax

        call find_tables
        ;check if cmap was found
        mov al, [table_found]
        cmp al, 0
        je cmap_not_found

        mov esi, [offsets]
        mov rdi, [fd]
        call parse_cmap wrt ..plt
        mov eax, 0
cmap_not_found:

        ret

        section .data

fd:
        dq 0
buf32:
        db 0x00, 0x00, 0x00, 0x00
buf16:
        db 0x00, 0x00
record:
        dd 0x00000000, 0x00000000, 0x00000000, 0x00000000
loop_count:
        db 0x00, 0x00, 0x00, 0x00
; ------------------- data for parsing ttf file --------------------
numbtables:
        db 0x00, 0x00, 0x00, 0x00
table_ids:
        db "cmap", "loca", "glyf"
offsets:
        dd 0x00000000, 0x00000000, 0x00000000
table_found:
        db 0, 0, 0
outter_index:
        db 0x00, 0x01, 0x02
number_of_elements_in_index:
        dw 0x0003
; tmp_hold:
;         dd 0
