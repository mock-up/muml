import json

type
  mumlVideo* = object
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

proc muml* (path: string): JsonNode = discard
proc content* (muml: JsonNode): JsonNode = discard

proc getVideo* (muml: JsonNode): mumlVideo =
  if not muml.hasKey("muml"):
    raise newException(Exception, "no muml")
  if not muml["muml"].hasKey("content"):
    raise newException(Exception, "no content")

  result = mumlVideo()
  for tag in muml["muml"]["content"].items:
    if not tag.hasKey("type"):
      raise newException(Exception, "no type tag")
    case tag["type"].getStr.removeDoubleQuotation:
    of "video":
      for key, val in tag.pairs:
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