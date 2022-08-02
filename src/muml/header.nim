# import json, types, utils

# proc getHeader* (muml: mumlNode): mumlHeader =
#   result = mumlHeader()
#   for key, val in muml.pairs:
#     case key:
#     of "project_name":
#       result.project_name = val.getStr.removeDoubleQuotation
#     of "width": result.width = val.getInt
#     of "height": result.height = val.getInt
#     of "fps": result.fps = val.getInt
#     of "last_frame_number":
#       result.last_frame_number = val.getInt