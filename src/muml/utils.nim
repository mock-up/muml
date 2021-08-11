import json, types

proc removeDoubleQuotation* (str: string): string =
  result = str[0..str.len-1]

proc getFloatValueProperty* (muml: mumlNode, name: string): mumlFloatRange =
  result = (start: muml["value"]["start"][name].getFloat, `end`: muml["value"]["end"][name].getFloat)

proc getFrame* (muml: mumlNode): mumlFloatRange =
  result = (start: muml["frame"]["start"].getFloat, `end`: muml["frame"]["end"].getFloat)

proc getPosition* (muml: mumlNode): seq[muml2DPosition] =
  result = @[]
  case muml.kind:
  of JObject:
    var position = muml2DPosition()
    position.frame = (-1.0, -1.0)
    position.x = (muml["x"].getFloat, muml["x"].getFloat)
    position.y = (muml["y"].getFloat, muml["y"].getFloat)
    result.add position
  of JArray:
    for item in muml.items:
      var position = muml2DPosition()
      position.frame = item.getFrame
      position.x = item.getFloatValueProperty("x")
      position.y = item.getFloatValueProperty("y")
      result.add position
  else: raise newException(Exception, "invalid value")
