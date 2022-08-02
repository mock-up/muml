import json, muml/[types, utils, video, rectangle, header, text], uuids
import muml/builtin/[triangle]
export types, utils, video, rectangle, header, text, uuids, triangle

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

proc type (muml: JsonNode): string =
  if not muml.hasKey("type"):
    raise newException(Exception, "no type tag")
  result = muml["type"].getStr.removeDoubleQuotation
