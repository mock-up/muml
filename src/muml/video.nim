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
        of "rotate":
          case val2.kind:
          of JInt, JFloat:
            var rotate = mumlValue()
            rotate.frame = (-1.0, -1.0)
            rotate.value = (val2.getFloat, val2.getFloat)
            result.video.rotate.add rotate
          of JArray:
            for rtt in val2.items:
              var rotate = mumlValue()
              rotate.frame = rtt.getFrame
              rotate.value = rtt.getFloatValueProperty("value")
              result.video.rotate.add rotate
          else: raise newException(Exception, "invalid value")
        of "opacity":
          case val2.kind:
          of JInt, JFloat:
            var opacity = mumlValue()
            opacity.frame = (-1.0, -1.0)
            opacity.value = (val2.getFloat, val2.getFloat)
            result.video.opacity.add opacity
          of JArray:
            for opc in val2.items:
              var opacity = mumlValue()
              opacity.frame = opc.getFrame
              opacity.value = opc.getFloatValueProperty("value")
              result.video.opacity.add opacity
          else: raise newException(Exception, "invalid value")
    of "audio":
      for key2, val2 in val.pairs:
        case key2:
        of "volume":
          case val2.kind:
          of JInt, JFloat:
            var volume = mumlValue()
            volume.frame = (-1.0, -1.0)
            volume.value = (val2.getFloat, val2.getFloat)
            result.audio.volume.add volume
          of JArray:
            for vol in val2.items:
              var volume = mumlValue()
              volume.frame = vol.getFrame
              volume.value = vol.getFloatValueProperty("value")
              result.audio.volume.add volume
          else: raise newException(Exception, "invalid value")