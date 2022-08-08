# Overview

~~TTF is the more popular text format (at least on my system).~~  Looks like OpenType (using TrueType outline format) and TrueType formats both use `.ttf` file extension. Also, apparently OpenType is a superset of TrueType format. Apple has documentation for TrueType at: https://developer.apple.com/fonts/TrueType-Reference-Manual/
and Microsoft has documentation for OpenType at: https://docs.microsoft.com/en-us/typography/opentype/spec/ and ISO has Open Font Format Specification (The ISO standard of OpenType) here: (ISO/IEC 14496-22:2019) here: https://standards.iso.org/ittf/PubliclyAvailableStandards/index.html
I want this to be a more basic fundamentals guide on what to do than the TTF reference manual is.

# What needs to happen

* Input character code
* Read the TTF file
* Lookup character data in TTF
* Render character
    - Take curve and line data
    - Generate raster image