; Copyright 2022 Jeffrey Brusseau
; Licensed under the MIT license. See LICENSE file in the project root for details.

        section .text                  ; section declaration

        global font_rendering_main
        extern printf, parse_table_directory

font_rendering_main:

        push rbp
        mov rbp, rsp

; get file descriptor for ttf file
        mov esi, 0
        lea rdi, [rel file_address]
        mov rax, 2                     ; syscall number (open)
        syscall
        mov [rel fd], eax

        ; call parse_table_directory
        mov rdi, [rel fd]
        call parse_table_directory wrt ..plt

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
clean_exit_message:
        db "exited cleanly", 10, 0
