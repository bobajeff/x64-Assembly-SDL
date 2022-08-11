//Copyright 2022 Jeffrey Brusseau
//Licensed under the MIT license. See LICENSE file in the project root for details.

// This is the c equivalent to the 'pixel_manipulation.asm' assembly file

#include "SDL_stdinc.h"
#include <SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "pixel_ops.h"

#define WIDTH 680
#define HEIGHT 480

int main() {
  SDL_Init(SDL_INIT_VIDEO);
  SDL_Window *window = SDL_CreateWindow(
      "Hello, world!", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WIDTH,
      HEIGHT, SDL_WINDOW_SHOWN);
  SDL_Surface *screenSurface = SDL_GetWindowSurface(window);
  pixeldata pixel_data = {WIDTH, HEIGHT, screenSurface->pixels};
  // pixel_data.width = WIDTH;
  // pixel_data.height = HEIGHT;
  // pixel_data.pixels = screenSurface->pixels;
  pixel_ops(&pixel_data);

  SDL_UpdateWindowSurface(window);
  SDL_Delay(2000);

  SDL_DestroyWindow(window);
  SDL_Quit();

  return 0;
}