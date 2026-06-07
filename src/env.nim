import std/registry 
const 
  SwivelupEnvKey* = "Swivelup"

template setUserEnvironmentVariable*(key, val: string): untyped =
  setUnicodeValue(
    path   = "Environment",
    key    = key,
    val    = val,
    handle = HKEY_CURRENT_USER
  )

template getUserEnvironmentVariable(key: string): string =
  getUnicodeValue("Environment", key, HKEY_CURRENT_USER)

proc checkInstallation*: tuple[success: bool, pathToInstallation: string] =
  try:
    result.pathToInstallation = getUserEnvironmentVariable(SwivelupEnvKey)
    result.success = true
  except OSError:
    result.success = false 

