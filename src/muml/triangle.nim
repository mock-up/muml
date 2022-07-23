import json, types, utils

proc getTriangle* (muml: mumlNode): mumlObject =
  result = mumlObject(kind: mumlKindTriangle)
  for key, val in muml.pairs:
    case key:
    of "frame":
      result.frame.start = val["start"].getInt
      result.frame.`end` = val["end"].getInt
    of "layer": result.layer = val.getInt
    of "position": result.triangle.position = val.getPosition
    of "width": result.triangle.width = val.getNumberValue
    of "height": result.triangle.height = val.getNumberValue
    of "scale": result.triangle.scale = val.getScale
    of "rotate": result.triangle.rotate = val.getNumberValue
    of "color":
      result.triangle.color = val.getRGB
    of "opacity": result.triangle.opacity = val.getNumberValue