import types, ../builder

type
  Reactangle* = ref object of mumlRootElement
    position*: Animation[mumlPosition]
    width*: Animation[float]
    height*: Animation[float]
    scale*: Animation[mumlScale]
    rotate*: Animation[float]
    opacity*: Animation[float]
    # color*: Animation[Color]

mumlBuilder(Reactangle)
