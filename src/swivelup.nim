import nigui
import util, env
import std/strformat
import install


var 
  (isSwivelPathSet, pathToSwivel) = checkSwivelPathSet()
  (isAdlPathSet, pathToAdl) = checkADLSetup()
  isSwivelInstalled = noexn getUserEnvironmentVariable(SwivelupSuccessfulInstallKey) # need to clean all this dirty stuff up later

init app
 

var
  window = newWindow("swivelup")
  root = newLayoutContainer(Layout_Vertical)
  bodyText = newTextArea()

with root:
  it.xAlign     = XAlign_Center
  it.widthMode  = WidthMode_Expand
  it.heightMode = HeightMode_Expand
  it.add newLabel("Swivel Setup")
  
  
  proc updateBodyText  =
    bodyText.text = &"Is Swivel path set: {isSwivelPathSet}\r\n" &
                    &"Is ADL path set: {isAdlPathSet}\r\n" &
                    &"Is Swivel Installed: {isSwivelInstalled}"
    
  with bodyText:
    updateBodyText()
    it.editable = false
    it.heightMode = HeightMode_Expand
  it.add(bodyText)
  
  ## Swivel Stuff
  var 
    swivelPathBar = newLayoutContainer(Layout_Horizontal)
    swivelPathBox = newTextBox()
  with swivelPathBar:
    it.add newLabel("Swivel Path:")

    with swivelPathBox:
      it.text      = pathToSwivel
      it.widthMode = WidthMode_Expand
      it.widthMode = WidthMode_Expand
      it.editable  = false # maybe later but this stops my overthinking for now. later i want to allow input here and make sure its a valid directory
    it.add(swivelPathBox)

    var
      browseBtn = newButton("Browse")
      setBtn = newButton("Set")
    with browseBtn:
      it.onClick = proc (ev: auto) =
        let dialog = newSelectDirectoryDialog()
        dialog.run()
        pathToSwivel       = dialog.selectedDirectory
        swivelPathBox.text = dialog.selectedDirectory
    it.add(browseBtn)

    with setBtn:
      it.onClick = proc (ev: auto) =
        if pathToSwivel.len == 0:
          window.alert(title   = "oops!", 
                       message = "Select the directory you would like Swivel to be installed. You can with the 'Browse' button")
        else:
          if not setUserEnvironmentVariable(SwivelupEnvKey, pathToSwivel): ## later when we support input ill validate the path, but since its selected it will be valid.
            window.alert(title   = "oh noes!",
                         message = &"Error setting Environment variable: {SwivelupEnvKey} with value: {pathToSwivel} for current User") # duplication, but its not a big deal and if it is later it can be moved away                
          else:
            isSwivelPathSet = true 
            updateBodyText()
    it.add(setBtn)
  it.add(swivelPathBar)

  ## ADL Stuff
  var 
    adlPathBar = newLayoutContainer(Layout_Horizontal)
    adlPathBox = newTextBox()

  with adlPathBar:
    it.add newLabel("ADL Path:")
    with adlPathBox:
      it.text      = pathToAdl
      it.widthMode = WidthMode_Expand
      it.widthMode = WidthMode_Expand
      it.editable  = false # maybe later but this stops my overthinking for now. later i want to allow input here and make sure its a valid executable
    it.add(adlPathBox)

    var
      browseBtn = newButton("Browse")
      setBtn    = newButton("Set")

    with browseBtn:
      it.onClick = proc (ev: auto) =
        let dialog = newOpenFileDialog()
        dialog.run()
        pathToAdl       = dialog.files[0]
        adlPathBox.text = dialog.files[0]
    it.add(browseBtn)

    with setBtn:
      it.onClick = proc (ev: auto) =
        if pathToAdl.len == 0:
          window.alert(title   = "oops!", 
                       message = "Select the path to your adl executable (AIR debug launcher). You can with the 'Browse' button")
        else:
          if not setUserEnvironmentVariable(AdlEnvKey, pathToAdl):  ## This shouldn't happen bc setting user env vars doesn't require admin perms. 
            window.alert(title   = "oh noes!",
                         message = &"Error setting Environment variable: {AdlEnvKey} with value: {pathToAdl} for current User")
          else:
            isAdlPathSet   = true
            updateBodyText()
    it.add(setBtn)
  it.add(adlPathBar)

  ## Iface Stuff
  var navBar = newLayoutContainer(Layout_Horizontal)
  with navBar:
    it.xAlign = XAlign_Right
    if not isSwivelInstalled:
      var installBtn = newButton("Install")
      with installBtn:
        it.onClick= proc (ev: auto) =
          if not isSwivelPathSet:
            window.alert("oops!", "Before you can install you need to select a destination path")
          else:
            let (success, err) = tryInstallSwivelTo(pathToSwivel)
            if success:
              isSwivelInstalled = true 
              updateBodyText()
            else:
              window.alert(title   = "oh noes!",
                           message = &"Error installing files to {pathToSwivel}. Message: {err.msg}")
      it.add(installBtn)

    var launchBtn = newButton("Launch Swivel")
    with launchBtn:
      it.onClick = proc (ev: auto) =
        if not isSwivelInstalled:
          window.alert(title = "Sorry :(", message = "Swivel is not yet installed!")
    it.add(launchBtn)
  it.add(navBar)


with window:
  it.width     = 600.scaleToDpi
  it.height    = 400.scaleToDpi
  it.resizable = false
  it.add(root)
  show it

run app
