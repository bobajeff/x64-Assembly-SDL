;Copyright 2022 Jeffrey Brusseau
;Licensed under the MIT license. See LICENSE file in the project root for details.

        section .text                  ; section declaration

        global main                    ; c compilers expect main as entry point

        extern SDL_Init, SDL_CreateWindow, SDL_DestroyWindow, SDL_GetWindowSurface
        extern SDL_MapRGB, SDL_FillRect, SDL_UpdateWindowSurface, SDL_Delay
        extern SDL_RWFromFile, SDL_LoadBMP_RW, SDL_UpperBlit
        extern exit

main:

        push rbp                       ; push value of base pointer (rbp) on stack; setting stack pointer (rsp) to top of new stack
        mov rbp, rsp                   ; set value of base pointer to stack pointer
        sub rsp, byte +0x10            ; allocate 16 bytes (size of int) to the stack frame (space above stack pointer and below base pointer)

        mov edi, 0x20                  ; 1st arg (SDL_INIT_VIDEO)
        call SDL_Init wrt ..plt        ; call function

        mov r9d, 0x4                   ; last arg (SDL_WINDOW_SHOWN)
        mov r8d, 480                   ; 5th arg
        mov ecx, 640                   ; 4th arg
        mov edx, 0x1fff0000            ; 3rd arg (SDL_WINDOWPOS_UNDEFINED)
        mov esi, 0x1fff0000            ; 2nd arg (SDL_WINDOWPOS_UNDEFINED)
        lea rdi, [rel window_name]     ; 1st arg pointer to window_name ("Hello, world!")
        call SDL_CreateWindow wrt ..plt ; call function
        mov [rbp-8], rax               ; copy return value to new $address_1 (from rax)
        mov rax, [rbp-8]               ; copy value of that $address_1 to back to rax

        mov rdi, rax                   ; 1st arg (value returned from last function)
        call SDL_GetWindowSurface wrt ..plt ; call function
        mov [rbp-16], rax              ; copy return value (SDL_Surface) to new $address_2 (from rax)
        mov rax, [rbp-16]              ; copy value of that $address_2 to back to rax

        lea rsi, [rel mode]            ; 2nd arg pointer mode string ("rb")
        lea rdi, [rel image_location]  ; 1st arg pointer to image_location ("./examples/res/doge.bmp")
        call SDL_RWFromFile wrt ..plt  ; call function

        mov esi, 1                     ; 2nd arg
        mov rdi, rax                   ; 1st arg return value from last function
        call SDL_LoadBMP_RW wrt ..plt  ; call function

        mov ecx, 0                     ; 4th arg (NULL)
        mov rdx, [rbp-16]              ; 3rd arg $address_2 (SDL_Surface)
        mov esi, 0                     ; 2nd arg (NULL)
        mov rdi, rax                   ; 1st arg (value returned from last function)
        call SDL_UpperBlit wrt ..plt   ; call function

        mov rdi, [rbp-8]               ; 1st arg (value of $address_1)
        call SDL_UpdateWindowSurface wrt ..plt ; call function

        mov edi, 2000                  ; 1st arg
        call SDL_Delay wrt ..plt       ; call function

        mov rdi, [rbp-8]               ; copy value of $address_1 to firt arg register (rdi)
        call SDL_DestroyWindow wrt ..plt ; call function

        mov eax, 0
        leave
        ret

        section .data                  ; section declaration

window_name:
        db "Hello, world!", 0
image_location:
        db "./examples/res/doge.bmp", 0
mode:
        db "rb", 0
