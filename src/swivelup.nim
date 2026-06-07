import raylib, raygui
import util, env
from build import SwivelBin

let (isInstalled, pathToInstallation) = checkInstallation()

proc main =
  initWindow(400, 400, "Swivelup"); defer: closeWindow()
  setTargetFps(60)
  while not windowShouldClose():
    drawing:
      clearBackground(Lightgray)


main()