import macros

var elements_list {.compileTime.} = @[
  "mumlVideo",
  "mumlAudio",
  "mumlImage",
  "mumlRectangle",
  "mumlTriangle",
  "mumlCircle",
  "mumlStar",
  "mumlText"
]

macro genMumlKind* (new_kind_arr: static[seq[string]]) =
  for kind in new_kind_arr:
    elements_list.add "muml" & kind
  var enumTy = nnkEnumTy.newTree()
  enumTy.add newEmptyNode()
  for element in elements_list:
    enumTy.add newIdentNode(element)
  result = nnkStmtList.newTree(
    nnkTypeSection.newTree(
      nnkTypeDef.newTree(
        newIdentNode("mumlKind2"),
        newEmptyNode(),
        enumTy
      )
    )
  )