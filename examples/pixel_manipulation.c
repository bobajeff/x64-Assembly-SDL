//Copyright 2022 Jeffrey Brusseau
//Licensed under the MIT license. See LICENSE file in the project root for details.

// This is the c equivalent to the 'pixel_manipulation.asm' assembly file

#include <SDL.h>
#include <stdio.h>

int main() {
  SDL_Init(SDL_INIT_VIDEO);
  SDL_Window *window =
      SDL_CreateWindow("Hello, world!", SDL_WINDOWPOS_UNDEFINED,
                       SDL_WINDOWPOS_UNDEFINED, 680, 480, SDL_WINDOW_SHOWN);
  SDL_Surface *screenSurface = SDL_GetWindowSurface(window);

  unsigned int *pixels = screenSurface->pixels;

  int x = 0, y = 0;
  for (;x < 680;) {
    for (;y < 480;) {
      unsigned int *pixel = &pixels[x + y * 680];
      if (y < 240) {
        *pixel = 0xFFFFFFu;
      } else {
        *pixel = 0x1464FAu;
      }
      y += 1;
    }
    y = 0;
    x += 1;
  }

  SDL_UpdateWindowSurface(window);
  SDL_Delay(2000);
  SDL_DestroyWindow(window);
  SDL_Quit();

  return 0;
}