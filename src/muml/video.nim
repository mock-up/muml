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
    of "video":
      for key2, val2 in val.pairs:
        case key2:
        of "frame":
          result.video.frame.start = val2["start"].getFloat
          result.video.frame.`end` = val2["end"].getFloat
        of "position": result.video.position = val2.getPosition
        of "scale":
          case val2.kind:
          of JObject:
            var scale = mumlScale()
            scale.frame = (-1.0, -1.0)
            scale.width = (val2["width"].getFloat, val2["width"].getFloat)
            scale.height = (val2["height"].getFloat, val2["height"].getFloat)
            result.video.scale.add scale
          of JArray:
            for scl in val2.items:
              var scale = mumlScale()
              scale.frame = scl.getFrame
              scale.width = scl.getFloatValueProperty("width")
              scale.height = scl.getFloatValueProperty("height")
              result.video.scale.add scale
          else: raise newException(Exception, "invalid value")
        of "rotate": result.video.rotate = val2.getNumberValue
        of "opacity": result.video.opacity = val2.getNumberValue
    of "audio":
      for key2, val2 in val.pairs:
        case key2:
        of "volume": result.audio.volume = val2.getNumberValue