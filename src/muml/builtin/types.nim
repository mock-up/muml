type
  Animation* [T] = seq[T]

  mumlRootElement* = ref object of RootObj
    layer: int
    frame: Animation[int]
  
  mumlPosition* = object
    x*: float
    y*: float
    z*: float
  
  mumlScale* = object
    width*: float
    height*: float