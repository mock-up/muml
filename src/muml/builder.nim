import std/[random, macros, json]
import types, utils, getValueUtils
export getInt, getFloat, getStr, pairs

proc serialize (typedescNimNode: NimNode, rootType: bool): JsonNode {.compileTime.} =
  result = %*{}
  let typeImpl = typedescNimNode.getImpl
  if (typeImpl[2].kind != nnkRefTy) and (typeImpl[2][0].kind != nnkObjectTy) and rootType:
    error("mumlElementになり得る型は構造体（object）型に限られます", typedescNimNode)
  result["type"] = %* $typedescNimNode
  if typeImpl[2][0].kind == nnkObjectTy:
    let typeImplFields = typeImpl[2][0][2]
    for typeImplField in typeImplFields:
      let
        fieldName = typeImplField[0]
        typeName = typeImplField[1]
      case $typeName
      of "int", "string", "bool", "float", "float32", "float64":
        result[$fieldName] = %* $typeName
      else:
        result[$fieldName] = serialize(typeName, false)
  elif typeImpl[2].kind == nnkEnumTy:
    result = %* ("enum:" & $typedescNimNode)

var randObject {.compileTime.} = initRand(20031030)

proc generateParser (prevAST: NimNode, keyValueID: int, deserializeMap: JsonNode): NimNode {.compileTime.} =
  ## of節以降を生成する、ネストしたオブジェクトがある場合はfor文、case節までを生成する
  result = prevAST
  
  var objectTypeName = ""

  for deserializeKey, deserializeVal in deserializeMap.pairs:
    if deserializeKey == "type":
      objectTypeName = deserializeVal.getStr.removeDoubleQuotation
      continue

    if deserializeVal.kind == JString:
      ### of節を生成する
      case deserializeVal.getStr
      of "int":
        result.add nnkOfBranch.newTree(
          getValue(int, deserializeKey, keyValueID)
        )
      of "float":
        result.add nnkOfBranch.newTree(
          getValue(float, deserializeKey, keyValueID)
        )
      of "string":
        result.add nnkOfBranch.newTree(
          getValue(string, deserializeKey, keyValueID)
        )
      else:
        if deserializeVal.getStr[0..4] == "enum:":
          result.add nnkOfBranch.newTree(
            getValue(enum, deserializeKey, deserializeVal.getStr, keyValueID)
          )
    
    elif deserializeVal.kind == JObject:
      ### ネストしたオブジェクトのためにforとcaseを生成する
      let
        nextKeyValueID = randObject.rand(1000000)
        nextResultElement = "resultElement_" & $nextKeyValueID
      result.add nnkOfBranch.newTree(
        newLit(deserializeKey),
        nnkStmtList.newTree(
          nnkVarSection.newTree(
            nnkIdentDefs.newTree(
              newIdentNode(nextResultElement),
              newEmptyNode(),
              nnkCall.newTree(
                newIdentNode(deserializeVal["type"].getStr.removeDoubleQuotation)
              )
            )
          ),
          nnkForStmt.newTree(
            newIdentNode("key_" & $nextKeyValueID),
            newIdentNode("val_" & $nextKeyValueID),
            nnkDotExpr.newTree(
              newIdentNode("val_" & $keyValueID),
              newIdentNode("pairs")
            ),
            nnkStmtList.newTree(
              nnkCaseStmt.newTree(
                newIdentNode("key_" & $nextKeyValueID)
              )
            )
          )
        )
      )
      result[^1][^1][^1][^1][^1] = generateParser(result[^1][^1][^1][^1][^1], nextKeyValueID, deserializeVal)      
      result[^1][^1].add nnkAsgn.newTree(
        nnkDotExpr.newTree(
          newIdentNode("resultElement_" & $keyValueID),
          newIdentNode(deserializeKey)
        ),
        newIdentNode(nextResultElement)
      )

proc generateParserProc (procName, typeName: NimNode, json: JsonNode): NimNode {.compileTime.} =
  let
    keyValueID = randObject.rand(1000000)
    key = ident("key_" & $keyValueID)
    val = ident("val_" & $keyValueID)
    resultElement = ident("resultElement_" & $keyValueID)

  result = quote do:
    proc `procName` (muml: mumlNode): mumlRootObj =
      var `resultElement` = `typeName`()
      for `key`, `val` in muml.pairs:
        discard
  
  # prevASTの`discard`文を置換
  result[^1][^1][^1] = nnkCaseStmt.newTree(
    newIdentNode("key_" & $keyValueID)
  )
  
  result[^1][^1][^1] = generateParser(result[^1][^1][^1], keyValueID, json)

  result[^1].add nnkAsgn.newTree(
    newIdentNode("result"),
    newIdentNode("resultElement_" & $keyValueID)
  )

macro mumlBuilder* (mumlElement: typedesc): untyped =
  let
    typeName = ident($mumlElement)
    procName = ident("parse_" & $mumlElement)
    serializedMumlElement = serialize(mumlElement, true)
  result = generateParserProc(procName, typeName, serializedMumlElement)
