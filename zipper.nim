import std/[os, tables, sets]
import zippy/ziparchives

proc collectEntries(): Table[string, string] = 
  const swivelPath = "Swivel"
  let assetsBase = swivelPath / "assets"
  
  for path in walkDirRec(assetsBase):
    let relPath = relativePath(path, assetsBase)
    if relPath.parentDir notin ["icons", "audio", "inject_swfs"].toHashSet:
      continue
    result["assets" / relPath] = readFile(path)
  result["application.xml"]             = readFile(swivelPath / "application.xml")
  result["bin/Swivel.swf"]              = readFile(swivelPath / "bin" / "Swivel.swf")
  result["ffmpeg/win32/ffmpeg.exe"]     = readFile(swivelPath / "ffmpeg/win32/ffmpeg.exe")
  result["ffmpeg/win32/redirecter.exe"] = readFile(swivelPath / "ffmpeg/win32/redirecter.exe")

let 
  entries = collectEntries()
  zipped  = createZipArchive(entries)
 
writeFile("Swivel.zip", zipped)
