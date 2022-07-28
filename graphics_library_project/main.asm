        section .text                  ; section declaration

        global main                    ; c compilers expect main as entry point

        extern SDL_Init, SDL_CreateWindow, SDL_DestroyWindow, SDL_GetWindowSurface
        extern SDL_UpdateWindowSurface, SDL_Delay, SDL_Quit
        extern exit
        extern pixel_ops
; constants
        SDL_WINDOWPOS_UNDEFINED equ 0x1fff0000
        SDL_INIT_VIDEO equ 0x4
        WIDTH equ 680
        HEIGHT equ 480
; variables
        %define _window [rbp-8]
        %define _sdl_surface [rbp-16]
        %define _pixel_data [rbp-32]

main:

        push rbp
        mov rbp, rsp
        sub rsp, 32
        mov edi, 32
        call SDL_Init wrt ..plt
        mov r9d, SDL_INIT_VIDEO
        mov r8d, HEIGHT
        mov ecx, WIDTH
        mov edx, SDL_WINDOWPOS_UNDEFINED
        mov esi, SDL_WINDOWPOS_UNDEFINED
        lea rdi, [rel window_name]
        call SDL_CreateWindow wrt ..plt
        mov _window, rax
        mov rax, _window
        mov rdi, rax
        call SDL_GetWindowSurface wrt ..plt
        mov _sdl_surface, rax
        mov dword [rbp-32], WIDTH      ; pixel_data->width
        mov dword [rbp-28], HEIGHT     ; pixel_data->height
        mov rax, _sdl_surface
        mov rax, [rax+32]              ; _sdl_surface->pixels
        mov [rbp-24], rax              ; _pixel_data->pixels
        lea rax, [rbp-32]
        mov rdi, rax
        call pixel_ops wrt ..plt
        mov rax, _window
        mov rdi, rax
        call SDL_UpdateWindowSurface wrt ..plt
        mov edi, 2000
        call SDL_Delay wrt ..plt
        mov rax, _window
        mov rdi, rax
        call SDL_DestroyWindow wrt ..plt
        call SDL_Quit wrt ..plt
        mov eax, 0
        leave
        ret
        section .data                  ; section declaration
window_name:
        db "Hello, world!", 0
