;Copyright 2022 Jeffrey Brusseau
;Licensed under the MIT license. See LICENSE file in the project root for details.

        section .text                  ; section declaration

        global main                    ; c compilers expect main as entry point

        extern SDL_Init, SDL_CreateWindow, SDL_DestroyWindow, SDL_GetWindowSurface
        extern SDL_UpdateWindowSurface, SDL_Delay, SDL_Quit
        extern exit

main:
; set up stack frame
        push rbp
        mov rbp, rsp
        sub rsp, 48
; Initialize SDL
        mov edi, 0x20                  ; SDL_INIT_VIDEO
        call SDL_Init wrt ..plt
        mov r9d, 0x4                   ; SDL_WINDOW_SHOWN
        mov r8d, 480
        mov ecx, 680
        mov edx, 0x1fff0000            ; SDL_WINDOWPOS_UNDEFINED
        mov esi, 0x1fff0000            ; SDL_WINDOWPOS_UNDEFINED
        lea rdi, [rel window_name]
        call SDL_CreateWindow wrt ..plt
        mov [rbp-16], rax
        mov rax, [rbp-16]
        mov rdi, rax
        call SDL_GetWindowSurface wrt ..plt
        mov rax, [rax+32]              ; get **pixels** address from SDL_Surface->pixels returned from function
        mov [rbp-32], rax              ; save **pixels** address in stack
; initialize x and y and start loop
        mov dword [rbp-4], 0           ; x
        mov dword [rbp-8], 0           ; y
        jmp begin_x_loop
y_loop:
        mov eax, [rbp-8]
        imul edx, eax, 680             ; y * 680
        mov eax, [rbp-4]
        add eax, edx                   ; x + y(680)
        cdqe
        lea rdx, [rax*4]               ; calculate relative pixel address = (x+y(680))*4  (4 bytes in int)
        mov rax, [rbp-32]              ; get **pixels** address
        add rax, rdx                   ; add relative pixel address to **pixels** address
        cmp dword [rbp-8], 239         ; compare y with 239
        jg branch_2                    ; if y is greater than 239 jump
        mov dword [rax], 0xffffff      ; make pixel white
        jmp end_y_loop
branch_2:
        mov dword [rax], 0x1464fa      ; make pixel blue
end_y_loop:
        add dword [rbp-8], 1           ; add 1 to y
x_loop:
        cmp dword [rbp-8], 479         ; compare y with 479
        jng y_loop                     ; if y is not greater than 479 jump
        mov dword [rbp-8], 0           ; assign 0 to y
        add dword [rbp-4], 1           ; add 1 to x
begin_x_loop:
        cmp dword [rbp-4], 679         ; compare x with 679
        jng x_loop                     ; if x is not greater than 679 jump
; close SDL
        mov rax, [rbp-16]
        mov rdi, rax
        call SDL_UpdateWindowSurface wrt ..plt
        mov edi, 2000
        call SDL_Delay wrt ..plt
        mov rax, [rbp-16]
        mov rdi, rax
        call SDL_DestroyWindow wrt ..plt
        call SDL_Quit wrt ..plt
; cleanup function
        mov eax, 0
        leave
        ret

        section .data                  ; section declaration
window_name:
        db "Hello, world!", 0
