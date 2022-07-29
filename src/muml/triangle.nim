import json, types
import builder

type
  mumlFrame = ref object of mumlRootObj
    start: int
    stop: int
  
  mumlPosition = ref object of mumlRootObj
    x: float
    y: float
    z: float
  
  mumlScale = ref object of mumlRootObj
    width: float
    height: float

  # 一旦colorとanimationは無視している
  mumlTriangle = ref object of mumlRootObj
    frame: mumlFrame
    layer: int
    position: mumlPosition
    width: float
    height: float
    scale: mumlScale
    rotate: float
    opacity: float

mumlBuilder(mumlTriangle)

export parse_mumlTriangle
