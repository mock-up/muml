import json, types, utils

proc getText* (muml: mumlNode): mumlObject =
  result = mumlObject(kind: mumlKindText)
  for key, val in muml.pairs:
    case key:
    of "position": result.text.position  = val.getPosition
    of "color": result.text.color = val.getRGB
    of "text": result.text.text = val.getStr