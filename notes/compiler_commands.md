**hello_sdl.c**
```
gcc examples/hello_sdl.c -o hello_sdl -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2
```

**hello_sdl.asm**
```
nasm -felf64 examples/hello_sdl.asm
#using c compiler for the linking with c libraries
gcc examples/hello_sdl.o -o hello_sdl -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2
```

# Generate assembly from the c example

Generate assembly gcc from **hello_sdl.c**
```
gcc examples/hello_sdl.c -S -masm=intel -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2
```

Generate NASM formmated assembly from the executable
```
ndisasm -b 64 hello_sdl > hello_sdl_dis.asm
```
It helps to search the file for a register that should show up rarly. Even better search for the hex value of some plain data that's likely passed directly to register.

# Debugging
```
# assemble to dwarf format
nasm -F dwarf -felf64

# create executable with debug symbols
gcc -g examples/hello_sdl.o -o hello_sdl -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2

# run gdb 
# the following assumes:
# SDL2's debugging symbols are installed
# SDL2's source code (matching the installed library) is downloaded somewhere
gdb ./hello_sdl --directory <path to SDL2 source directroy>
```
