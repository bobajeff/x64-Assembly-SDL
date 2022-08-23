# Normal Compiling

**hello_sdl.c**
```
gcc examples/SDL/hello_sdl.c -o hello_sdl -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2
```

**pixel_ops.c** and **main.c**
```
gcc examples/multiple_source_files/pixel_ops.c -c -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2

gcc examples/multiple_source_files/main.c -o sdl_demo ./pixel_ops.o -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2
```

**hello_sdl.asm**
```
nasm -felf64 examples/SDL/hello_sdl.asm
#using c compiler for the linking with c libraries
gcc examples/SDL/hello_sdl.o -o hello_sdl -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2
```
**pixel_ops.asm** and **main.asm**

```
#assemble sources
nasm -felf64 examples/multiple_source_files/pixel_ops.asm
nasm -felf64 examples/multiple_source_files/main.asm

#link via c compiler
gcc examples/multiple_source_files/main.o examples/multiple_source_files/pixel_ops.o -o sdl_demo -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2

```


# Generate assembly from the c example

Generate assembly gcc from **hello_sdl.c**
```
gcc examples/SDL/hello_sdl.c -S -masm=intel -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2
```

Generate NASM formatted assembly from the executable
```
ndisasm -b 64 hello_sdl > hello_sdl_dis.asm
```
It helps to search the file for a register that should show up rarely. Even better search for the hex value of some plain data that's likely passed directly to register.

# Debugging
```
# assemble to dwarf format
nasm -F dwarf -felf64

# create executable with debug symbols
gcc -g examples/SDL/hello_sdl.o -o hello_sdl -L/usr/lib/x86_64-linux-gnu  -lSDL2 -lc -lm -lpthread -lrt -I/usr/include/x86_64-linux-gnu/SDL2

# run gdb 
# the following assumes:
# SDL2's debugging symbols are installed
# SDL2's source code (matching the installed library) is downloaded somewhere
gdb ./hello_sdl --directory <path to SDL2 source directroy>
```
### GDB commands
Print contents of register
```
p $<register>
```
Ex:
```
p $ecx
```
Print top 1000 elements of stack frame
```
x/1000x $rsp
```
Print out the values in all the registers
```
info registers
```
https://sourceware.org/gdb/current/onlinedocs/gdb/Registers.html