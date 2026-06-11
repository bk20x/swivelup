import std/registry 
type
  InstallationStatus* = tuple
    success: bool
    pathToInstallation: string

const 
  SwivelupEnvKey* = "Swivelup"
  SwivelupSuccessfulInstallKey* = "SwivelupX"
  AdlEnvKey*      = "SwivelupADL"

template setUserEnvironmentVariable*(k, v: string): bool =
  try:
    setUnicodeValue(
      path   = "Environment",
      key    = k,
      val    = v,
      handle = HKEY_CURRENT_USER
    )
    true
  except OSError:
    false

template getUserEnvironmentVariable*(key: string): string =
  getUnicodeValue("Environment", key, HKEY_CURRENT_USER)

proc checkSwivelPathSet*: InstallationStatus {.raises: [].} =
  try:
    result.pathToInstallation = getUserEnvironmentVariable(SwivelupEnvKey)
    result.success = true
  except OSError:
    result.success = false 

proc checkADLSetup*: InstallationStatus {.raises: [].} = 
  try:
    result.pathToInstallation = getUserEnvironmentVariable(AdlEnvKey)
    result.success = true
  except OSError:
    result.success = false