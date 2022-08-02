import json, muml/[types, utils, video, rectangle, header, text, triangle, builder], uuids
export types, utils, video, rectangle, header, text, uuids, triangle, builder

type
  Muml* = object
    header: JsonNode
    contents: JsonNode

proc muml* (json: JsonNode): Muml =
  if not json.hasKey("muml"):
    raise newException(Exception, "no muml")
  if not json["muml"].hasKey("header"):
    raise newException(Exception, "no header")
  if not json["muml"].hasKey("contents"):
    raise newException(Exception, "no contents")

  result.header = json["muml"]["header"]
  result.contents = json["muml"]["contents"]

proc type (muml: mumlNode): string =
  if not muml.hasKey("type"):
    raise newException(Exception, "no type tag")
  result = muml["type"].getStr.removeDoubleQuotation

iterator default_content* (muml: Muml): mumlRootObj =
  for element in muml.contents:
    var mumlObj = case element.type:
      

iterator element* (muml: mumlNode): mumlObject =
  for elem in muml.items:
    var mumlObj = case elem.type:
      of "video": getVideo(elem)
      of "triangle": getTriangle(elem)
      of "rectangle": getRectangle(elem)
      of "text": getText(elem)
      else: raise newException(Exception, "not found tag")
    mumlObj.uuid = genUuid()
    yield mumlObj