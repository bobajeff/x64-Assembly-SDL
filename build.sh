# Copyright 2022 Jeffrey Brusseau
# Licensed under the MIT license. See LICENSE file in the project root for details.

echo "builing graphics_library_project"
nasm -F dwarf -felf64 graphics_library_project/main.asm
nasm -F dwarf -felf64 graphics_library_project/font_rendering/font_rendering_main.asm
nasm -F dwarf -felf64 graphics_library_project/font_rendering/parse_cmap.asm
nasm -F dwarf -felf64 graphics_library_project/font_rendering/parse_ttf_table_directory.asm
nasm -F dwarf -felf64 graphics_library_project/debug/print_byte_array.asm

gcc -g \
graphics_library_project/main.o \
graphics_library_project/font_rendering/font_rendering_main.o \
graphics_library_project/font_rendering/parse_ttf_table_directory.o \
graphics_library_project/font_rendering/parse_cmap.o \
graphics_library_project/debug/print_byte_array.o \
-o graphics_program -L/usr/lib/x86_64-linux-gnu -lc -lm -lpthread -lrt

