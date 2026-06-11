import std/[os, strformat, tables]

const
  AssetsRelPath = "assets" / "icons" / ""

proc collectIcons(swivelDir: string): Table[string, string] {.compileTime.} = 
  let swivelIconsPath = swivelDir / AssetsRelPath
  for kind, path in walkDir(swivelIconsPath):
    if kind == pcFile: result[path.extractFilename] = staticRead(path)


const (SwivelBin*, SwivelXml*, SwivelIcons*) = static:
  let 
    swivelDir = currentSourcePath().parentDir().parentDir() / "Swivel" / "" 
    buildCmd  = &"cmd.exe /c cd {swivelDir} && haxe Swivel.hxml"
  block buildSwivel:
    echo &"[Build Swivel] Command: {buildCmd}"
    let buildOutput = staticExec(buildCmd)
    if buildOutput.len > 0:
      echo &"[Message] {buildOutput}"
  let 
    swivelBin  = staticRead(swivelDir / "bin" / "Swivel.swf")
    swivelXml  = staticRead(swivelDir / "application.xml")
    iconsTable = collectIcons(swivelDir)
  (swivelBin, swivelXml, iconsTable)
  
  
  
