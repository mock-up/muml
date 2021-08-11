import json, muml/[types, utils, video]

proc muml* (path: string): mumlNode =
  let json = path.readFile().parseJson
  if not json.hasKey("muml"):
    raise newException(Exception, "no muml")
  result = json["muml"]

proc muml* (json: JsonNode): mumlNode =
  if not json.hasKey("muml"):
    raise newException(Exception, "no muml")
  result = json["muml"]

proc content* (muml: mumlNode): mumlNode =
  if not muml.hasKey("content"):
    raise newException(Exception, "no content")
  result = muml["content"]

proc type (muml: mumlNode): string =
  if not muml.hasKey("type"):
    raise newException(Exception, "no type tag")
  result = muml["type"].getStr.removeDoubleQuotation

proc `[]`* (muml: mumlNode, index: int): mumlObject {.inline.} =
  let target_node = muml.elems[index]
  result = case target_node.type:
    of "video": getVideo(target_node)
    else: raise newException(Exception, "not found tag")

iterator element* (muml: mumlNode): mumlObject =
  for elem in muml.items:
    yield case elem.type:
      of "vudeo": getVideo(elem)
      else: mumlObject()
      # else: raise newException(Exception, "not found tag")