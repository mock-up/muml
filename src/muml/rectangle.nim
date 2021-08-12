import json, types, utils, Palette/color

proc getRectangle* (muml: mumlNode): mumlObject =
  result = mumlObject(kind: mumlKindRectangle)
  for key, val in muml.pairs:
    case key:
    of "frame":
      result.frame.start = val["start"].getFloat
      result.frame.`end` = val["end"].getFloat
    of "layer": result.layer = val.getInt
    of "position": result.rectangle.position = val.getPosition
    of "width": result.rectangle.width = val.getNumberValue
    of "height": result.rectangle.height = val.getNumberValue
    of "scale": result.rectangle.scale = val.getScale
    of "rotate": result.rectangle.rotate = val.getNumberValue
    of "color":
      result.rectangle.color = val.getRGB
    of "opacity": result.rectangle.opacity = val.getNumberValue