import std/macros, json, builder
import builtin/types
import uuids

const BuiltInElements* = [
  "Video", # "image", "audio",
  "Triangle",
  "Rectangle", "Text"
]

proc caseOfApplyParserAST (elements: seq[string]): NimNode =
  result = nnkCaseStmt.newTree(
    nnkDotExpr.newTree(
      nnkBracketExpr.newTree(
        newIdentNode("element"),
        newLit("type")
      ),
      newIdentNode("getStr")
    )
  )
  for element in elements:
    result.add nnkOfBranch.newTree(
      newLit(element),
      nnkStmtList.newTree(
        nnkCall.newTree(
          newIdentNode("parse_" & element),
          newIdentNode("element")
        )
      )
    )
  result.add nnkElse.newTree(
    quote do:
      raise newException(Exception, "not found tag")
  )

macro mumlDeserializer* (customElements: varargs[untyped]): untyped =
  var elements = @BuiltInElements
  for customElement in customElements:
    elements.add $customElement

  let
    procName = newIdentNode("muml")
    elementIdent = newIdentNode("element")
    caseOfApplyParser = caseOfApplyParserAST(elements)

  result = quote do:
    proc `procName`* (json: JsonNode): seq[mumlRootElement] =
      for `elementIdent` in json:
        var mumlObj = `caseOfApplyParser`
        mumlObj.id = genUuid()
        result.add mumlObj
