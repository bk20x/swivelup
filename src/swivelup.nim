import nigui
import util, env
import std/strformat
from build import SwivelBin



let 
  (isSwivelInstalled, pathToSwivel) = checkSwivelInstalled()
  (isAdlSetup, pathToAdl) = checkADLSetup()


init app


var
  window = newWindow("swivelup")
  root = newLayoutContainer(Layout_Vertical)
  bodyText = newTextArea()

with root:
  it.xAlign = XAlign_Center
  it.widthMode  = WidthMode_Expand
  it.heightMode = HeightMode_Expand
  it.add newLabel("Swivel Installer")
  
  with bodyText:
    it.text = &"Is Swivel Installed: {isSwivelInstalled}\r\n" &
              &"Is ADL path set: {isAdlSetup}"
    it.editable = false
    it.heightMode = HeightMode_Expand
    root.add(it)
  
  var swivelPathBar = newLayoutContainer(Layout_Horizontal)
  with swivelPathBar:
    it.add newLabel("Swivel Path: ")
    var inputBox = newTextBox()
    with inputBox:
      it.text = pathToSwivel
      it.widthMode = WidthMode_Expand
      it.widthMode = WidthMode_Expand
    it.add(inputBox) 
    var
      browseBtn = newButton("Browse")
      setBtn = newButton("Set")
    it.add(browseBtn)
    it.add(setBtn)
    root.add(it)

  var navBar = newLayoutContainer(Layout_Horizontal)
  with navBar:
    it.xAlign = XAlign_Right
    if not isSwivelInstalled:
      var installButton = newButton("Install")
      it.add(installButton)
    root.add(it)


with window:
  let size = 400.scaleToDpi
  it.width     = size
  it.height    = size
  it.resizable = false
  it.add(root)
  show it

run app
