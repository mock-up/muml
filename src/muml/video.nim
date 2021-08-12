import json, types, utils

proc getVideo* (muml: mumlNode): mumlObject =
  result = mumlObject(kind: mumlKindVideo)
  for key, val in muml.pairs:
    case key:
    of "path":
      result.path = val.getStr.removeDoubleQuotation
    of "frame":
      result.frame.start = val["start"].getFloat
      result.frame.`end` = val["end"].getFloat
    of "layer":
      result.layer = val.getInt
    of "video":
      for key2, val2 in val.pairs:
        case key2:
        of "frame":
          result.video.frame.start = val2["start"].getFloat
          result.video.frame.`end` = val2["end"].getFloat
        of "position": result.video.position = val2.getPosition
        of "scale": result.video.scale = val2.getScale
        of "rotate": result.video.rotate = val2.getNumberValue
        of "opacity": result.video.opacity = val2.getNumberValue
    of "audio":
      for key2, val2 in val.pairs:
        case key2:
        of "volume": result.audio.volume = val2.getNumberValue