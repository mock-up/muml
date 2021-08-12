import json, types, Palette/color

proc removeDoubleQuotation* (str: string): string =
  result = str[0..str.len-1]

proc getFloatValueProperty* (muml: mumlNode, name: string): mumlFloatRange =
  result = (start: muml["value"]["start"][name].getFloat, `end`: muml["value"]["end"][name].getFloat)

proc getFrame* (muml: mumlNode): mumlFloatRange =
  result = (start: muml["frame"]["start"].getFloat, `end`: muml["frame"]["end"].getFloat)

proc getNumberValue* (muml: mumlNode): seq[mumlValue] =
  result = @[]
  case muml.kind:
  of JInt, JFloat:
    var value = mumlValue()
    value.frame = (-INF, -INF)
    value.value = (muml.getFloat, -INF)
    result.add value
  of JArray:
    for item in muml.items:
      var value = mumlValue()
      value.frame = item.getFrame
      value.value = item.getFloatValueProperty("value")
      result.add value
  else: raise newException(Exception, "invalid value")

proc getPosition* (muml: mumlNode): seq[muml2DPosition] =
  result = @[]
  case muml.kind:
  of JObject:
    var position = muml2DPosition()
    position.frame = (-INF, -INF)
    position.x = (muml["x"].getFloat, -INF)
    position.y = (muml["y"].getFloat, -INF)
    result.add position
  of JArray:
    for item in muml.items:
      var position = muml2DPosition()
      position.frame = item.getFrame
      position.x = item.getFloatValueProperty("x")
      position.y = item.getFloatValueProperty("y")
      result.add position
  else: raise newException(Exception, "invalid value")

proc getScale* (muml: mumlNode): seq[mumlScale] =
  result = @[]
  case muml.kind:
  of JObject:
    var scale = mumlScale()
    scale.frame = (-INF, -INF)
    scale.width = (muml["width"].getFloat, -INF)
    scale.height = (muml["height"].getFloat, -INF)
    result.add scale
  of JArray:
    for item in muml:
      var scale = mumlScale()
      scale.width = item.getFloatValueProperty("width")
      scale.height = item.getFloatValueProperty("height")
      result.add scale
  else: raise newException(Exception, "invalid value")

proc getRGB* (muml: mumlNode): seq[mumlRGB] =
  result = @[]
  case muml.kind:
  of JObject:
    var color = mumlRGB()
    color.frame = (-INF, -INF)
    var
      red = muml["red"].getFloat
      green = muml["green"].getFloat
      blue = muml["blue"].getFloat
    color.color = newRGB(red.tBinaryRange, green.tBinaryRange, blue.tBinaryRange)
    result.add color
  of JArray:
    for item in muml:
      var color = mumlRGB()
      color.frame = (-INF, -INF)
      var
        red = muml["red"].getFloat
        green = muml["green"].getFloat
        blue = muml["blue"].getFloat
      color.color = newRGB(red.tBinaryRange, green.tBinaryRange, blue.tBinaryRange)
      result.add color
  else: raise newException(Exception, "invalid value")