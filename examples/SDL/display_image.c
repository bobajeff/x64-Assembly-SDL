//Copyright 2022 Jeffrey Brusseau
//Licensed under the MIT license. See LICENSE file in the project root for details.

// This is the c equivalent to the 'display_image.asm' assembly file

#include <SDL.h>
#include <stdio.h>

int main() {
  SDL_Init(SDL_INIT_VIDEO);
  SDL_Window *window = SDL_CreateWindow("Hello, world!", SDL_WINDOWPOS_UNDEFINED,
                                        SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN);
  SDL_Surface *screenSurface = SDL_GetWindowSurface(window);
  SDL_RWops *src = SDL_RWFromFile("./examples/SDL/res/doge.bmp", "rb");
  SDL_Surface *image = SDL_LoadBMP_RW(src, 1);
  SDL_UpperBlit(image, NULL, screenSurface, NULL);
  SDL_UpdateWindowSurface(window);
  SDL_Delay(2000);
  SDL_DestroyWindow(window);
  SDL_Quit();

  return 0;
}