import json, Palette/color

type
  mumlNode* = JsonNode

  mumlKind* = enum
    mumlKindVideo
    mumlKindAudio
    mumlKindRectangle
  
  mumlHeader* = object
    project_name*: string
    width*: int
    height*: int
    fps*: int
    last_frame_number*: int

  mumlObject* = object
    layer*: Natural
    frame*: mumlFloatRange
    case kind*: mumlKind
    of mumlKindVideo:
      path*: string
      video*: mumlVideo_Video
      audio*: mumlVideo_Audio
    of mumlKindAudio:
      volume*: seq[mumlValue]
      balance*: seq[mumlAudioBalance]
      playback_position*: seq[mumlValue]
      speed*: seq[mumlValue]
    of mumlKindRectangle: rectangle*: mumlRectangle
  
  mumlRectangle* = object
    position*: seq[muml2DPosition]
    width*: seq[mumlValue]
    height*: seq[mumlValue]
    scale*: seq[mumlScale]
    rotate*: seq[mumlValue]
    color*: seq[mumlRGB]
    opacity*: seq[mumlValue]

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

  mumlRGB* = object
    frame*: mumlFloatRange
    color*: tRGB
  
  mumlScale* = object
    frame*: mumlFloatRange
    width*: mumlFloatRange
    height*: mumlFloatRange
  
  mumlValue* = object
    frame*: mumlFloatRange
    value*: mumlFloatRange
  
  mumlAudioBalance* = object