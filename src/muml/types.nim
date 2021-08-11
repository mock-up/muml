import json

type
  mumlNode* = JsonNode

  mumlKind* = enum
    mumlVideo
    mumlAudio
    mumlRectangle

  mumlObject* = object
    frame*: mumlFloatRange
    case kind*: mumlKind
    of mumlVideo:
      path*: string
      video*: mumlVideo_Video
      audio*: mumlVideo_Audio
    of mumlAudio:
      volume*: seq[mumlValue]
      balance*: seq[mumlAudioBalance]
      playback_position*: seq[mumlValue]
      speed*: seq[mumlValue]
    of mumlRectangle:
      position*: seq[muml2DPosition]

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
  
  mumlAudioBalance* = object