import std/[os, tables]
from build import SwivelBin, SwivelXml, SwivelIcons
from env   import setUserEnvironmentVariable, SwivelupSuccessfulInstallKey

proc tryInstallSwivelTo*(path: string): tuple[success: bool, err: ref Exception] {.raises: [].} = 
  try:
    block writeAppMetadata:
      writeFile(path/"application.xml", SwivelXml)
    block writeSwf:
      let 
        swfDir = path / "bin"
        swfBin = swfDir / "Swivel.swf"
      createDir(swfDir) 
      writeFile(swfBin, SwivelBin)
    block writeAssets:
      let
        assetsDir = path / "assets" # in case we need to package more later
        iconsDir  = assetsDir / "icons" / ""
      createDir(iconsDir) 
      for filename, imgData in SwivelIcons:
        writeFile(iconsDir/filename, imgData)
    discard setUserEnvironmentVariable(SwivelupSuccessfulInstallKey, path)
    return (success: true, err: nil)
  except OSError, IOError:
    return (success: false, err: getCurrentException())
