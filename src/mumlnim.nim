import json

type
  mumlNode* = JsonNode

  mumlKind* = enum
    mumlVideo

  mumlObject* = object
    case kind: mumlKind
    of mumlVideo:
      path*: string
      frame*: tuple[start: float, `end`: float]
      video*: mumlVideo_Video
      audio*: mumlVideo_Audio

  mumlVideo_Video* = object
    frame*: tuple[start: float, `end`: float]
    position*: tuple[x: float, y: float]
    scale*: tuple[width: float, height: float]
    rotate*: float
    opacity*: float

  mumlVideo_Audio* = object
    volume*: float

proc removeDoubleQuotation (str: string): string =
  result = str[0..str.len-1]

proc muml* (path: string): mumlNode =
  let json = path.readFile().parseJson
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

proc getVideo (muml: mumlNode): mumlObject =
  result = mumlObject(kind: mumlVideo)
  for key, val in muml.pairs:
    case key:
    of "path":
      result.path = val.getStr.removeDoubleQuotation
    of "frame":
      result.frame.start = val["start"].getFloat
      result.frame.`end` = val["end"].getFloat
    of "video":
      for key2, val2 in val.pairs:
        case key2:
        of "frame":
          result.video.frame.start = val2["start"].getFloat
          result.video.frame.`end` = val2["end"].getFloat
        of "position":
          result.video.position.x = val2["x"].getFloat
          result.video.position.y = val2["y"].getFloat
        of "scale":
          result.video.scale.width = val2["width"].getFloat
          result.video.scale.height = val2["height"].getFloat
        of "rotate":
          result.video.rotate = val2.getFloat
        of "opacity":
          result.video.opacity = val2.getFloat
    of "audio":
      for key2, val2 in val.pairs:
        case key2:
        of "volume":
          result.audio.volume = val2.getFloat

proc `[]`* (muml: mumlNode, index: int): mumlObject {.inline.} =
  let target_node = muml.elems[index]
  echo target_node.type
  result = case target_node.type:
    of "video": getVideo(target_node)
    else: raise newException(Exception, "not found tag")