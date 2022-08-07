# Overview

TTF is the more popular text format (at least on my system). Apple has documentation for it at: https://developer.apple.com/fonts/TrueType-Reference-Manual/
I want this to be a more basic fundamentals guide on what to do than the TTF reference manual is.

# What needs to happen

* Input character code
* Read the TTF file
* Lookup character data in TTF
* Render character
    - Take curve and line data
    - Generate raster image