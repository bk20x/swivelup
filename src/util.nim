template with*(thing, body): untyped =
  ## For setting up gui elements, this only works as intended if thing is a ref/ptr type
  block:
    var it {.inject.} = thing
    body 
    


  

  