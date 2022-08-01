import std/[macros]

func toIdent (deserializeKey: string, keyValueID: int): tuple[val, resultElement, key: NimNode] =
  result.val = newIdentNode("val_" & $keyValueID)
  result.resultElement = newIdentNode("resultElement_" & $keyValueID)
  result.key = newIdentNode(deserializeKey)

func toIdent (typeName, deserializeKey: string, keyValueID: int): tuple[typeName, val, resultElement, key: NimNode] =
  (result.val, result.resultElement, result.key) = toIdent(deserializeKey, keyValueID)
  result.typeName = newIdentNode(typeName)

proc getIntParserAST* (deserializeKey: string, keyValueID: int): NimNode =
  let (val, resultElement, key) = toIdent(deserializeKey, keyValueID)
  result = nnkOfBranch.newTree(
    newLit(deserializeKey),
    quote do:
      `resultElement`.`key` = getInt(`val`)
  )

proc getInt8ParserAST* (deserializeKey: string, keyValueID: int): NimNode =
  let (val, resultElement, key) = toIdent(deserializeKey, keyValueID)
  result = nnkOfBranch.newTree(
    newLit(deserializeKey),
    quote do:
      `resultElement`.`key` = int8(getInt(`val`))
  )

proc getFloatParserAST* (deserializeKey: string, keyValueID: int): NimNode =
  let (val, resultElement, key) = toIdent(deserializeKey, keyValueID)
  result = nnkOfBranch.newTree(
    newLit(deserializeKey),
    quote do:
      `resultElement`.`key` = getFloat(`val`)
  )

proc getStringParserAST* (deserializeKey: string, keyValueID: int): NimNode =
  let (val, resultElement, key) = toIdent(deserializeKey, keyValueID)
  result = nnkOfBranch.newTree(
    newLit(deserializeKey),
    quote do:
      `resultElement`.`key` = getStr(`val`).removeDoubleQuotation
  )

proc getEnumParserAST* (typeName, deserializeKey: string, keyValueID: int): NimNode =
  let (typeName, val, resultElement, key) = toIdent(typeName, deserializeKey, keyValueID)
  result = nnkOfBranch.newTree(
    newLit(deserializeKey),
    quote do:
      `resultElement`.`key` = getStr(`val`).removeDoubleQuotation.parseEnum[`typeName`]
  )

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
