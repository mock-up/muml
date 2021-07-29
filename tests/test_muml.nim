import unittest, json, mumlnim

suite "to parse videos":
  let
    jsonStr = "tests/assets/muml_video.json".readFile()
    jsonObj = jsonStr.parseJson
  echo jsonObj

  test "get path of video":
    check(jsonObj.getVideo.path == "/xxx/clip1.mp4")