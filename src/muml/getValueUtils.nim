import std/[macros]

proc getValueBoilerplate (deserializeKey: string, keyValueID: int, rightNode: NimNode): seq[NimNode] =
  result = @[
    newLit(deserializeKey),
    nnkAsgn.newTree(
      nnkDotExpr.newTree(
        newIdentNode("resultElement_" & $keyValueID),
        newIdentNode(deserializeKey)
      ),
      rightNode
    )
  ]

proc getValue* (_: typedesc[int], deserializeKey: string, keyValueID: int): seq[NimNode] =
  result = getValueBoilerplate(
    deserializeKey, keyValueID,
    nnkDotExpr.newTree(
      newIdentNode("val_" & $keyValueID),
      newIdentNode("getInt")
    )
  )

proc getValue* (_: typedesc[float], deserializeKey: string, keyValueID: int): seq[NimNode] =
  result = getValueBoilerplate(
    deserializeKey, keyValueID,
    nnkDotExpr.newTree(
      newIdentNode("val_" & $keyValueID),
      newIdentNode("getFloat")
    )
  )

proc getValue* (_: typedesc[string], deserializeKey: string, keyValueID: int): seq[NimNode] =
  result = getValueBoilerplate(
    deserializeKey, keyValueID,
    nnkDotExpr.newTree(
      nnkDotExpr.newTree(
        newIdentNode("val_" & $keyValueID),
        newIdentNode("getStr")
      ),
      newIdentNode("removeDoubleQuotation")
    )
  )

proc getValue* (_: typedesc[enum], typeName, deserializeKey: string, keyValueID: int): seq[NimNode] =
  result = getValueBoilerplate(
    deserializeKey, keyValueID,
    nnkCall.newTree(
      nnkBracketExpr.newTree(
        newIdentNode("parseEnum"),
        newIdentNode(typeName[5..^1])
      ),
      nnkCall.newTree(
        newIdentNode("removeDoubleQuotation"),
        nnkDotExpr.newTree(
          newIdentNode("val_" & $keyValueID),
          newIdentNode("getStr")
        )
      )
    )
  )
