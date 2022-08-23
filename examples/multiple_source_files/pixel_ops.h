//Copyright 2022 Jeffrey Brusseau
//Licensed under the MIT license. See LICENSE file in the project root for details.

typedef struct pixeldata
{
    int width, height;
    unsigned int *pixels;
} pixeldata;

void pixel_ops(pixeldata * pixel_data);