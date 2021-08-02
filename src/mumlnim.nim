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
    position*: seq[muml2DPosition]
    scale*: seq[mumlScale]
    rotate*: seq[mumlValue]
    opacity*: seq[mumlValue]

  mumlVideo_Audio* = object
    volume*: seq[mumlValue]

  mumlFloatRange* = tuple[start: float, `end`: float]

  muml2DPosition* = object
    frame*: mumlFloatRange
    x*: mumlFloatRange
    y*: mumlFloatRange
  
  mumlScale* = object
    frame*: mumlFloatRange
    width*: mumlFloatRange
    height*: mumlFloatRange
  
  mumlValue* = object
    frame*: mumlFloatRange
    value*: mumlFloatRange

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

proc getFrame (muml: mumlNode): mumlFloatRange =
  result = (start: muml["frame"]["start"].getFloat, `end`: muml["frame"]["end"].getFloat)

proc getFloatValueProperty (muml: mumlNode, name: string): mumlFloatRange =
  result = (start: muml["value"]["start"][name].getFloat, `end`: muml["value"]["end"][name].getFloat)

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
          case val2.kind:
          of JObject:
            var position: muml2DPosition
            position.frame = (-1.0, -1.0)
            position.x = (val2["x"].getFloat, val2["x"].getFloat)
            position.y = (val2["y"].getFloat, val2["y"].getFloat)
            result.video.position.add position
          of JArray:
            for pos in val2.items:
              var position: muml2DPosition
              position.frame = pos.getFrame
              position.x = pos.getFloatValueProperty("x")
              position.y = pos.getFloatValueProperty("y")
              result.video.position.add position
          else: raise newException(Exception, "invalid value")
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

proc `[]`* (muml: mumlNode, index: int): mumlObject {.inline.} =
  let target_node = muml.elems[index]
  result = case target_node.type:
    of "video": getVideo(target_node)
    else: raise newException(Exception, "not found tag")