import std/strformat
# Package

version       = "0.1.1"
author        = "bk20x"
description   = "Tool for [un]installing/updating Swivel SWF Converter"
license       = "GPL-3.0-or-later"
srcDir        = "src"
bin           = @["swivelup"]
namedBin      = {
  "swivelup": 
    when defined(windows):
      &"Swivelup_Windows{version}.exe"
    else:
      assert false, "Can Only build on windows for now"

}.toTable
# Dependencies

requires "nim >= 2.2.0"
requires "nigui"
requires "zippy"
