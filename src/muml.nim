import json, muml/[types, utils, video, rectangle, header, text, triangle], uuids
export types, utils, video, rectangle, header, text, uuids, triangle

proc muml* (path: string): mumlNode =
  let json = path.readFile().parseJson
  if not json.hasKey("muml"):
    raise newException(Exception, "no muml")
  result = json["muml"]

proc muml* (json: JsonNode): mumlNode =
  if not json.hasKey("muml"):
    raise newException(Exception, "no muml")
  result = json["muml"]

proc header* (muml: mumlNode): mumlNode =
  if not muml.hasKey("header"):
    raise newException(Exception, "no header")
  result = muml["header"]

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
    var mumlObj = case elem.type:
      of "video": getVideo(elem)
      of "rectangle": getRectangle(elem)
      of "text": getText(elem)
      else: raise newException(Exception, "not found tag")
    mumlObj.uuid = genUuid()
    yield mumlObj

iterator deserialize* (muml: JSONNode): mumlRootObj =
  for element in muml.items:
    discard