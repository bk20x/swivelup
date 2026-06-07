import std/[os, strformat]

const SwivelBin* = static:
  let 
    swivelDir = currentSourcePath().parentDir().parentDir() / r"Swivel\" 
    buildCmd = &"cmd.exe /c cd {swivelDir} && haxe Swivel.hxml"
  block buildSwivel:
    echo &"[Build Swivel] Command: {buildCmd}"
    let buildOutput = staticExec(buildCmd)
    if buildOutput.len > 0:
      echo &"[Message] {buildOutput}"
  let swivelBin = swivelDir / "bin" / "Swivel.swf"
  staticRead(swivelBin)
  
  
