typedef struct pixeldata
{
    int width, height;
    unsigned int *pixels;
} pixeldata;

void pixel_ops(pixeldata * pixel_data);