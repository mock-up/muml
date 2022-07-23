import unittest, muml

# genMumlKind(@[
#   "Test1",
#   "Test2"
# ])

suite "add element":
  test "test1":
    let
      content = muml("tests/assets/muml_filters.json").content
      video = content[0]
    check(true)