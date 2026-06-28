import nigui
import util, env
import std/[strformat, osproc]
import install
from std/os import `/`

var 
  (isSwivelPathSet, pathToInstallation) = checkSwivelPathSet()
  (isAdlPathSet, pathToAdl) = checkADLSetup()
  (isSwivelInstalled, pathToSwivel) = checkSwivelInstalled()

init app
 

var
  window = newWindow("swivelup")
  root = newLayoutContainer(Layout_Vertical)
  bodyText = newTextArea()



with root:
  it.xAlign     = XAlign_Center
  it.widthMode  = WidthMode_Expand
  it.heightMode = HeightMode_Expand
  it.add newLabel("Swivel Setup & Launcher")
  
  
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
    it.add newLabel("Target Path:")

    with swivelPathBox:
      it.text      = pathToInstallation
      it.widthMode = WidthMode_Expand
      it.widthMode = WidthMode_Expand
      it.editable  = false # maybe later but this stops my overthinking for now. later i want to allow input here and make sure its a valid directory
    it.add(swivelPathBox)

    var browseBtn = newButton("Browse")
    with browseBtn:
      it.onClick = proc (ev: auto) =
        let dialog = newSelectDirectoryDialog()
        dialog.run()
        let dir = dialog.selectedDirectory
        pathToInstallation = dir
        swivelPathBox.text = dir
        if dir.len > 0:
          isSwivelPathSet = true 
          let success = setUserEnvironmentVariable(SwivelupEnvKey, dir)
          if not success:
            window.alert(
              title   = "Error!",
              message = "Could not set environment variable"
            )
        updateBodyText()
    it.add(browseBtn)       
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
      
    with browseBtn:
      it.onClick = proc (ev: auto) =
        let dialog = newOpenFileDialog()
        dialog.run()
        let path = dialog.files[0]
        pathToAdl       = path
        adlPathBox.text = path
        if path.len > 0:
          isAdlPathSet = true 
          let success = setUserEnvironmentVariable(AdlEnvKey, path)
          if not success:
            window.alert(
              title   = "Error!",
              message = "Could not set environment variable"
            )
        updateBodyText()
    it.add(browseBtn)
  it.add(adlPathBar)

  ## Iface Stuff
  var navBar = newLayoutContainer(Layout_Horizontal)
  with navBar:
    it.xAlign = XAlign_Right
    var 
      installBtn: Button
      uninstBtn:  Button
      launchBtn:  Button
    installBtn = newButton("Install")
    with installBtn:
      it.onClick= proc (ev: auto) =
        if not isSwivelPathSet:
          window.alert(title = "oops!", message = "Before you can install you need to select a destination path")
        else:
          let (success, err) = tryInstallSwivelTo(pathToInstallation/"Swivel")
          if success:
            isSwivelInstalled = true 
            pathToSwivel = pathToInstallation / "Swivel"
            updateBodyText()
            navBar.remove(installBtn)
            navBar.add(launchBtn)
            navBar.add(uninstBtn)
          else:
            window.alert(title    = "oh noes!",
                          message = &"Error installing files to {pathToInstallation}. Message: {err.msg}")
    

    uninstBtn = newButton("Uninstall and remove environment variables")
    with uninstBtn:
      it.onClick = proc (ev: auto) =
        let (success, msg) = performUninstall(pathToSwivel)
        if not success:
          window.alert(title = "Uh Oh", message = fmt"Error uninstalling: {msg}")
        else:
          isSwivelInstalled = false 
          isSwivelPathSet   = false
          isAdlPathSet      = false
          adlPathBox.text    = ""
          swivelPathBox.text = ""
          updateBodyText()
          navBar.remove(uninstBtn)
          navBar.remove(launchBtn)
          navBar.add(installBtn)

    launchBtn = newButton("Launch Swivel")
    with launchBtn:
      it.onClick = proc (ev: auto) =
        discard startProcess(
          command     = "cmd.exe",
          args        = @["/c", pathToAdl, "application.xml"],
          workingDir  = pathToSwivel,
          options     = {poUsePath, poDaemon}
        )

    if isSwivelInstalled: 
      it.add(launchBtn)
      it.add(uninstBtn) 
    else: 
      it.add(installBtn)  
    
    
    
  it.add(navBar)


with window:
  it.width     = 600.scaleToDpi
  it.height    = 400.scaleToDpi
  it.resizable = false
  it.add(root)
  show it

run app
