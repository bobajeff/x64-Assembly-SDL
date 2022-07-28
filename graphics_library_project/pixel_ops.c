#include "pixel_ops.h"

void pixel_ops(pixeldata *pixel_data) {

  int x = 0, y = 0;
  for (; x < pixel_data->width;) {
    for (; y < pixel_data->height;) {
      unsigned int *pixel = &pixel_data->pixels[x + y * pixel_data->width];
      if (y < pixel_data->height * .5) {
        *pixel = 0xFFFFFFu;
      } else {
        *pixel = 0x1464FAu;
      }
      y += 1;
    }
    y = 0;
    x += 1;
  }
}