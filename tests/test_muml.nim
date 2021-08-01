import unittest, json, mumlnim

suite "to parse videos":
  let
    jsonStr = "tests/assets/muml_video.json".readFile()
    jsonObj = jsonStr.parseJson

  test "get path of video":
    check jsonObj.getVideo.path == "/xxx/clip1.mp4"

  test "get frame of video":
    check jsonObj.getVideo.frame == (start: 0.0, `end`: 100.0)
  
  test "get video-frame of video":
    check jsonObj.getVideo.video.frame == (start: 0.0, `end`: 100.0)
  
  test "get video-position of video":
    check jsonObj.getVideo.video.position == (x: 0.0, y: 0.0)
  
  test "get video-scale of video":
    check jsonObj.getVideo.video.scale == (width: 100.0, height: 100.0)
  
  test "get video-rotate of video":
    check jsonObj.getVideo.video.rotate == 0.0
  
  test "get video-opacity of video":
    check jsonObj.getVideo.video.opacity == 0.0
  
  test "get audio-volume of video":
    check jsonObj.getVideo.audio.volume == 100.0