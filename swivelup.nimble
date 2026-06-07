# Package

version       = "0.1.0"
author        = "bk20x"
description   = "Tool for [un]installing/updating Swivel SWF Converter"
license       = "GPL-3.0-or-later"
srcDir        = "src"
bin           = @["swivelup"]


# Dependencies

requires "nim >= 2.2.0"
requires "naylib"
requires "https://github.com/planetis-m/naygui"
