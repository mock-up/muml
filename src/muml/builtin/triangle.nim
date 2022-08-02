import types, ../builder

type
  mumlTriangle* = ref object of mumlRootElement
    position: Animation[mumlPosition]
    scale: Animation[mumlScale]
    rotate: Animation[float]
    opacity: Animation[float]

mumlBuilder(mumlTriangle)
