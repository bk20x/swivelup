import std/[os, strformat]


const SwivelArchive* = static:
  let 
    swivelDir = currentSourcePath().parentDir().parentDir() / "Swivel" / "" 
    buildCmd  = &"cmd.exe /c cd {swivelDir} && haxe Swivel.hxml"
  block buildSwivel:
    echo &"[Build Swivel] Command: {buildCmd}"
    let buildOutput = staticExec(buildCmd)
    if buildOutput.len > 0:
      echo &"[Message] {buildOutput}"
  block bakeSwivelZip:
    let projectDir = swivelDir.parentDir()
    discard staticExec(&"cmd.exe /c cd {projectDir} && zipper.exe")
    staticRead(projectDir/"Swivel.zip")
    
  
