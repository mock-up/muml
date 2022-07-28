import std/[random, macros, json, strutils]
import types, utils

{.experimental: "dynamicBindSym".}

proc serialize (typedescNimNode: NimNode, rootType: bool): JsonNode {.compileTime.} =
  result = %*{}
  let typeImpl = typedescNimNode.getImpl
  if (typeImpl[2].kind != nnkRefTy) and (typeImpl[2][0].kind != nnkObjectTy) and rootType:
    error("mumlElementになり得る型は構造体（object）型に限られます", typedescNimNode)
  result["type"] = %* typedescNimNode.repr
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
    result = %* ("enum:" & typedescNimNode.repr)

var randObject {.compileTime.} = initRand(20031030)

proc parseIntField (deserializeKey, loopVal: string): seq[NimNode] =
  result = @[
    newLit(deserializeKey),
    nnkAsgn.newTree(
      nnkDotExpr.newTree(
        newIdentNode("resultElement"),
        newIdentNode(deserializeKey)
      ),
      nnkDotExpr.newTree(
        newIdentNode(loopVal),
        newIdentNode("getInt")
      )
    )
  ]

proc parseFloatField (deserializeKey, loopVal: string): seq[NimNode] =
  result = @[
    newLit(deserializeKey),
    nnkAsgn.newTree(
      nnkDotExpr.newTree(
        newIdentNode("resultElement"),
        newIdentNode(deserializeKey)
      ),
      nnkDotExpr.newTree(
        newIdentNode(loopVal),
        newIdentNode("getFloat")
      )
    )
  ]

proc parseStringField (deserializeKey, loopVal: string): seq[NimNode] =
  result = @[
    newLit(deserializeKey),
    nnkAsgn.newTree(
      nnkDotExpr.newTree(
        newIdentNode("resultElement"),
        newIdentNode(deserializeKey)
      ),
      nnkDotExpr.newTree(
        nnkDotExpr.newTree(
          newIdentNode(loopVal),
          newIdentNode("getStr")
        ),
        newIdentNode("removeDoubleQuotation")
      )
    )
  ]

proc parseEnumField (deserializeKey, typeName, loopVal: string): seq[NimNode] =
  result = @[
    newLit(deserializeKey),
    nnkAsgn.newTree(
      nnkDotExpr.newTree(
        newIdentNode("resultElement"),
        newIdentNode(deserializeKey)
      ),
      nnkCall.newTree(
        nnkBracketExpr.newTree(
          newIdentNode("parseEnum"),
          newIdentNode(typeName[5..^1])
        ),
        nnkCall.newTree(
          newIdentNode("removeDoubleQuotation"),
          nnkDotExpr.newTree(
            newIdentNode(loopVal),
            newIdentNode("getStr")
          )
        )
      )
    )
  ]

proc generateParser (procName, typeName: NimNode, json: JsonNode): NimNode {.compileTime.} =
  let
    keyValueID = randObject.rand(1000000)
    key = ident("key_" & $keyValueID)
    val = ident("val_" & $keyValueID)
    resultElement = ident"resultElement"

  result = quote do:
    proc `procName`* (muml: mumlNode): mumlRootObj =
      var `resultElement` = `typeName`()
      for `key`, `val` in muml.pairs:
        case `key`
        of "demo":
          discard
        else:
          discard
  
  # 上記コードの`discard`文を置換
  result[^1][^1][^1] = nnkCaseStmt.newTree(
    newIdentNode("key_" & $keyValueID)
  )
  
  for deserializeKey, deserializeVal in json.pairs:
    if deserializeKey == "type":
      continue

    if deserializeVal.kind == JString:
      echo deserializeVal.getStr
      case deserializeVal.getStr
      of "int":
        result[^1][^1][^1].add nnkOfBranch.newTree(parseIntField(deserializeKey, "val_" & $keyValueID))
      of "float":
        result[^1][^1][^1].add nnkOfBranch.newTree(parseFloatField(deserializeKey, "val_" & $keyValueID))
      of "string":
        result[^1][^1][^1].add nnkOfBranch.newTree(parseStringField(deserializeKey, "val_" & $keyValueID))
      else:
        if deserializeVal.getStr[0..4] == "enum:":
          result[^1][^1][^1].add nnkOfBranch.newTree(parseEnumField(deserializeKey, deserializeVal.getStr, "val_" & $keyValueID))
    elif deserializeVal.kind == JObject:
      discard # generateParser(newStmtList(), val)

  result[^1].add nnkAsgn.newTree(
    newIdentNode("result"),
    newIdentNode("resultElement")
  )

  dumpAstGen:
    parseEnum[ty](removeDoubleQuotation(val.getStr))

macro mumlBuilder (mumlElements: varargs[untyped]): untyped =
  result = newStmtList()
  for mumlElement in mumlElements:
    let
      typeName = ident(mumlElement.repr)
      procName = ident("parse_" & mumlElement.repr)
      serializedMumlElement = serialize(bindSym(mumlElement), true)

    echo serializedMumlElement
    
    result.add generateParser(procName, typeName, serializedMumlElement)


type
  mumlRootObj = ref object of RootObj
  myObj = ref object of mumlRootObj
    myField1: bool

  myEnum = enum
    m1, m2, m3

  newElement = ref object of mumlRootObj
    field1: int
    field2: string
    field3: myObj
    field4: float
    field5: myEnum

expandMacros:
  mumlBuilder(newElement)

let muml = %* {
  "field1": 10,
  "field2": "str",
  "field3": {
    "myField1": true
  },
  "field4": 12.3,
  "field5": "m3"
}

echo parse_newElement(muml).repr
