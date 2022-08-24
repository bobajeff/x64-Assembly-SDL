;Copyright 2022 Jeffrey Brusseau
;Licensed under the MIT license. See LICENSE file in the project root for details.

        section .text                  ; section declaration

        global main                    ; c compilers expect main as entry point

        extern sdl_main, font_rendering_main

main:
        push rbp
        mov rbp, rsp
        ; call sdl_main wrt ..plt
        call font_rendering_main wrt ..plt
        mov eax, 0
        leave
        ret
