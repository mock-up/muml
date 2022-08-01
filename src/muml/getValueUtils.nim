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

func toIdent (deserializeKey: string, keyValueID: int): tuple[val, resultElement, key: NimNode] =
  result.val = newIdentNode("val_" & $keyValueID)
  result.resultElement = newIdentNode("resultElement_" & $keyValueID)
  result.key = newIdentNode(deserializeKey)

proc getFloatSequenceParserAST* (deserializeKey: string, keyValueID: int): NimNode =
  let (val, resultElement, key) = toIdent(deserializeKey, keyValueID)
  result = nnkOfBranch.newTree(
    newLit(deserializeKey),
    quote do:
      for jsonArrayElement in `val`:
        `resultElement`.`key`.add jsonArrayElement.getFloat
  )

proc getIntSequenceParserAST* (deserializeKey: string, keyValueID: int): NimNode =
  let (val, resultElement, key) = toIdent(deserializeKey, keyValueID)
  result = nnkOfBranch.newTree(
    newLit(deserializeKey),
    quote do:
      for jsonArrayElement in `val`:
        `resultElement`.`key`.add jsonArrayElement.getInt
  )

proc getStringSequenceParserAST* (deserializeKey: string, keyValueID: int): NimNode =
  let (val, resultElement, key) = toIdent(deserializeKey, keyValueID)
  result = nnkOfBranch.newTree(
    newLit(deserializeKey),
    quote do:
      for jsonArrayElement in `val`:
        `resultElement`.`key`.add jsonArrayElement.getStr.removeDoubleQuotation
  )
