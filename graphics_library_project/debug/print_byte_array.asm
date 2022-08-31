; Copyright 2022 Jeffrey Brusseau
; Licensed under the MIT license. See LICENSE file in the project root for details.

        DEFAULT REL
        section .text                  ; section declaration

        global print_byte_array
        extern printf
print_byte_array:
        mov r15, rsi
; start counter at 0
        mov r14, 0
print_next_four_bytes:
        mov rax, 0
        lea r12, [output_string]
convert_nibbles_to_charaqcters:
        lea r13, [character_codes]
; covert bytes to string
; get left nibble (4 bits)
        mov dl, [rdi + r14]
        shr dl, 4

; get character code
        movzx rdx, dl
        mov bl, [r13 + rdx]
        mov [r12 + rax * 2], bl

; get right nibble
        mov dl, [rdi + r14]
        shl dl, 4
        shr dl, 4

; get character code
        movzx rdx, dl
        mov bl, [r13 + rdx]
        mov [r12 + rax * 2 + 1], bl

        add rax, 1
        add r14, 1
        cmp r14, r15
        je print_remainder
        cmp rax, 4
        jl convert_nibbles_to_charaqcters
print_remainder:
; print the string
        mov [tmp_1], rdi
        mov esi, 0
        lea rdi, [output_string]
        mov eax, 0
        call printf wrt ..plt
        mov rdi, [tmp_1]

        cmp r14, r15
        jl print_next_four_bytes
; print newline
        mov [tmp_1], rdi
        mov esi, 0
        lea rdi, [newline]
        mov eax, 0
        call printf wrt ..plt
        mov rdi, [tmp_1]

        ret

        section .data

character_codes:
        db "0123456789ABCDEF"
test_bytes:
        db 0x21, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x0E, 0x0E
output_string:
        ; db "00000000 ", 0
        ; db "........ ", 0
        db "         ", 0
newline:
    db 10, 0
tmp_1:
        dq 0

