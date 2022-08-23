;Copyright 2022 Jeffrey Brusseau
;Licensed under the MIT license. See LICENSE file in the project root for details.

        section .text                  ; section declaration

        global pixel_ops               ; expose pixel_ops to rest of program

; constants
        WHITE equ 0xffffff
        BLUE equ 0x1464fa
; variables
        %define _x [rbp-4]
        %define _y [rbp-8]
        %define _pixel_data [rbp-24]
        %define _pixel_address [rbp-16]

pixel_ops:

        push rbp
        mov rbp, rsp
        mov _pixel_data, rdi

        mov dword _x, 0
        mov dword _y, 0
        jmp run_x_loop
y_loop:
        mov rax, _pixel_data
        mov rdx, [rax+8]               ; pixel_data->pixels
        mov rax, _pixel_data
        mov eax, [rax]                 ; pixel_data->width
        imul eax, _y                   ; width * y
        mov ecx, eax
        mov eax, _x
        add eax, ecx                   ; add x to (width * y)
        cdqe
        shl rax, 2
        add rax, rdx                   ; add pixels to (x+(width*y))
        mov _pixel_address, rax
        cvtsi2sd xmm1, dword _y
        mov rax, _pixel_data
        mov eax, [rax+4]               ; pixel_data->height
        cvtsi2sd xmm2, eax             ; mov height to double floating point precision whatever register
        movsd xmm0, qword [rel half]
        mulsd xmm0, xmm2               ; .5 * height
        comisd xmm0, xmm1              ; compare y with (height *.5)
        jna branch_2                   ; jump if not met
        mov rax, _pixel_address
        mov dword [rax], WHITE
        jmp end_y_loop
branch_2:
        mov rax, _pixel_address
        mov dword [rax], BLUE
end_y_loop:
        add dword _y, 1
x_loop:
        mov rax, _pixel_data
        mov eax, [rax+4]               ; pixel_data->height
        cmp _y, eax
        jl y_loop
        mov dword _y, 0
        add dword _x, 1
run_x_loop:
        mov rax, _pixel_data
        mov eax, [rax]                 ; pixel_data->width
        cmp _x, eax
        jl x_loop
        nop
        pop rbp
        ret
        section .data                  ; section declaration
half:
        dq 0.5
