import std/[registry, os, winlean]
type
  InstallationStatus* = tuple
    success: bool
    pathToInstallation: string
  UninstallationStatus* = tuple
    success: bool 
    reason:  string 

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

proc RegOpenKeyExW(hKey: HKEY, lpSubKey: WideCString, ulOptions: int32, samDesired: int32, phkResult: pointer): int32
  {.stdcall, dynlib: "advapi32", importc: "RegOpenKeyExW".}
proc RegDeleteValueW(hKey: HKEY, lpValueName: WideCString): int32
  {.stdcall, dynlib: "advapi32", importc: "RegDeleteValueW".}
proc RegCloseKey(hKey: HKEY): int32
  {.stdcall, dynlib: "advapi32", importc: "RegCloseKey".}

# refresh Windows env???
proc SendMessageTimeoutW(hWnd: pointer, Msg: uint32, wParam: int, lParam: WideCString,
                        fuFlags: uint32, uTimeout: uint32, lpdwResult: pointer): int32
  {.stdcall, dynlib: "user32", importc: "SendMessageTimeoutW".}

const KEY_SET_VALUE: int = 0x0002
proc deleteUserEnvVariable(varName: string) =
  let
    subKey: WideCStringObj      = newWideCString("Environment")
    targetValue: WideCStringObj = newWideCString(varName)
  var hKey: HKEY
  if RegOpenKeyExW(HKEY_CURRENT_USER, subKey, 0, KEY_SET_VALUE.int32, addr hKey) == 0:
    discard RegDeleteValueW(hKey, targetValue)
    discard RegCloseKey(hKey)


proc performUninstall*(pathToInstallation: string): UninstallationStatus {.raises: [].} =
  try:
    deleteUserEnvVariable(AdlEnvKey)
    deleteUserEnvVariable(SwivelupEnvKey)
    deleteUserEnvVariable(SwivelupSuccessfulInstallKey)
    removeDir(pathToInstallation)

    let envStr: WideCStringObj = newWideCString("Environment")
    discard SendMessageTimeoutW(cast[pointer](0xFFFF), 0x001A, 0, envStr, KEY_SET_VALUE.uint32, 5000, nil)

    result = (success: true, reason: "")
  except CatchableError as e:
    result = (success: false, reason: e.msg)
