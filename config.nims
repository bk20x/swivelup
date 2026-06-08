# begin Nimble config (version 2)
## This next line is why i couldnt see anything i was printing!!! i thought this was a bug with Nim on Windows because i tested it in smaller programs,
## But funnily enough, its because i was testing in this directory and nim was using this config.nims.... 
## UNCOMMENT FOR RELEASE --app:gui

when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config
