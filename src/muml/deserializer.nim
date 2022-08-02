import std/macros

const BuiltInElements* = [
  "video", "image", "audio",
  "triangle", "rectangle", "text"
]

macro mumlDeserializer* (elements: varargs[untyped]): untyped =
  var elements = elements
  for builtInElement in BuiltInElements:
    elements.add newIdentNode(builtInElement)
  echo elements.astGenRepr

  let
    procName = newIdentNode("muml")
  result = quote do:
    import std/[json]
    proc `procName`* (json: JsonNode): Muml =
      for elem in muml.items:
        var mumlObj = case elem.type:
          of "video": getVideo(elem)
          of "triangle": getTriangle(elem)
          of "rectangle": getRectangle(elem)
          of "text": getText(elem)
          else: raise newException(Exception, "not found tag")
      mumlObj.uuid = genUuid()

mumlDeserializer(myElement1, myElement2)
