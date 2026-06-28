import std/os
import zippy/ziparchives
from build import SwivelArchive
from env   import setUserEnvironmentVariable, SwivelupSuccessfulInstallKey

proc tryInstallSwivelTo*(path: string): tuple[success: bool, err: ref Exception] {.raises: [].} = 
  try:
    let tmpname = "tmp.zip"
    writeFile(tmpname,  SwivelArchive)
    extractAll(tmpname, dest = path)
    removeFile(tmpname)
    discard setUserEnvironmentVariable(SwivelupSuccessfulInstallKey, path)
    return (success: true, err: nil)
  except OSError, IOError, ZippyError:
    return (success: false, err: getCurrentException())


