        section .text                  ; section declaration

        global main                    ; c compilers expect main as entry point

        extern SDL_Init, SDL_CreateWindow, SDL_DestroyWindow, SDL_GetWindowSurface
        extern SDL_MapRGB, SDL_FillRect, SDL_UpdateWindowSurface, SDL_Delay, exit

main:

        push rbp                       ; push value of base pointer (rbp) on stack; setting stack pointer (rsp) to top of new stack
        mov rbp, rsp                   ; set value of base pointer to stack pointer
        sub rsp, byte +0x10            ; allocate 16 bytes (size of int) to the stack frame (space above stack pointer and below base pointer)

        mov	edi, 0x20                  ; 1st arg (SDL_INIT_VIDEO)
        call SDL_Init wrt ..plt        ; call function

        mov	r9d, 0x4                   ; last arg (SDL_WINDOW_SHOWN)
        mov	r8d, 480                   ; 5th arg
        mov	ecx, 640                   ; 4th arg
        mov	edx, 0x1fff0000            ; 3rd arg (SDL_WINDOWPOS_UNDEFINED)
        mov	esi, 0x1fff0000            ; 2nd arg (SDL_WINDOWPOS_UNDEFINED)
        lea	rdi, [rel window_name]     ; 1st arg pointer to window_name ("Hello, world!")
        call SDL_CreateWindow wrt ..plt ; call function
        mov [rbp-8], rax               ; copy return value to new $address_1 (from rax)
        mov rax, [rbp-8]               ; copy value of that $address_1 to back to rax

        mov	rdi, rax                   ; 1st arg (value returned from last function)
        call SDL_GetWindowSurface wrt ..plt ; call function
        mov [rbp-16], rax              ; copy return value to new $address_2 (from rax)
        mov rax, [rbp-16]              ; copy value of that $address_2 to back to rax

        mov	ecx, 255                   ; 4th arg
        mov	edx, 255                   ; 3rd arg
        mov	esi, 255                   ; 2nd arg
        mov	rdi, [rax+8]               ; 1st arg (8 bytes inside value returned from last function (SDL_Surface::format))
        call SDL_MapRGB wrt ..plt      ; call function

        mov	edx, eax                   ; 3rd arg (value returned from last function (uint32 color returned from SDL_MapRGB))
        mov	esi, 0                     ; 2rd arg (NULL)
        mov	rdi, [rbp-16]              ; 1st arg (value of $address_2 (SDL_Surface))
        call SDL_FillRect wrt ..plt    ; call function

        mov rdi, [rbp-8]               ; 1st arg (value of $address_1)
        call SDL_UpdateWindowSurface wrt ..plt ; call function

        mov	edi, 2000                  ; 1st arg
        call SDL_Delay wrt ..plt       ; call function

        mov rdi, [rbp-8]               ; copy value of $address_1 to firt arg register (rdi)
        call SDL_DestroyWindow wrt ..plt ; call function

        mov	eax, 0
        leave
        ret

        section .data                  ; section declaration

window_name:
        db "Hello, world!", 0
