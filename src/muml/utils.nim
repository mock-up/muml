import json, types

proc removeDoubleQuotation* (str: string): string =
  result = str[0..str.len-1]

proc getFloatValueProperty* (muml: mumlNode, name: string): mumlFloatRange =
  result = (start: muml["value"]["start"][name].getFloat, `end`: muml["value"]["end"][name].getFloat)

proc getFrame* (muml: mumlNode): mumlFloatRange =
  result = (start: muml["frame"]["start"].getFloat, `end`: muml["frame"]["end"].getFloat)