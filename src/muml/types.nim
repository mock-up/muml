import json, Palette/color, uuids

type
  mumlNode* = JsonNode

  mumlRootObj* = ref object of RootObj
    default_content: string

  mumlKind* = enum
    mumlKindVideo
    mumlKindAudio
    mumlKindRectangle
    mumlKindTriangle
    mumlKindText
  
  mumlFilterKind* = enum
    colorInversion
    grayScale
  
  mumlHeader* = object
    project_name*: string
    width*: int
    height*: int
    fps*: int
    last_frame_number*: int

  mumlObject* = object
    layer*: Natural
    frame*: mumlIntRange
    uuid*: UUID
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
    of mumlKindTriangle: triangle*: mumlTriangle
    of mumlKindText: text*: mumlText

  mumlTriangle* = object
    position*: seq[muml2DPosition]
    width*: seq[mumlValue]
    height*: seq[mumlValue]
    scale*: seq[mumlScale]
    rotate*: seq[mumlValue]
    color*: seq[mumlRGB]
    opacity*: seq[mumlValue]
  
  mumlRectangle* = object
    position*: seq[muml2DPosition]
    width*: seq[mumlValue]
    height*: seq[mumlValue]
    scale*: seq[mumlScale]
    rotate*: seq[mumlValue]
    color*: seq[mumlRGB]
    opacity*: seq[mumlValue]
  
  mumlText* = object
    text*: string # seq[string]
    position*: seq[muml2DPosition]
    color*: seq[mumlRGB]

  mumlVideo_Video* = object
    frame*: mumlIntRange
    position*: seq[muml2DPosition]
    scale*: seq[mumlScale]
    rotate*: seq[mumlValue]
    opacity*: seq[mumlValue]
    filters*: seq[mumlFilter]
  
  mumlFilter* = object
    case kind*: mumlFilterKind
    of colorInversion:
      red*: bool
      green*: bool
      blue*: bool
    of grayScale:
      value*: float

  mumlVideo_Audio* = object
    volume*: seq[mumlValue]

  mumlIntRange* = tuple[start: int, `end`: int]
  mumlFloatRange* = tuple[start: float, `end`: float]

  muml2DPosition* = object
    frame*: mumlIntRange
    x*: mumlFloatRange
    y*: mumlFloatRange

  mumlRGB* = object
    frame*: mumlIntRange
    color*: tRGB
  
  mumlScale* = object
    frame*: mumlIntRange
    width*: mumlFloatRange
    height*: mumlFloatRange
  
  mumlValue* = object
    frame*: mumlIntRange
    value*: mumlFloatRange
  
  mumlAudioBalance* = object
