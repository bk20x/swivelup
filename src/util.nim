template with*(thing, body): untyped =
  block:
    template it: untyped = thing
    body 
    


template noexn*(code): bool =
  try:
    discard code 
    true
  except CatchableError:
    false

  

  