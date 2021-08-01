import unittest, mumlnim

suite "to parse videos":
  let content = muml("tests/assets/muml_video.json").content

  test "get path of video":
    check content.getVideo.path == "/xxx/clip1.mp4"

  test "get frame of video":
    check content.getVideo.frame == (start: 0.0, `end`: 100.0)
  
  test "get video-frame of video":
    check content.getVideo.video.frame == (start: 0.0, `end`: 100.0)
  
  test "get video-position of video":
    check content.getVideo.video.position == (x: 0.0, y: 0.0)
  
  test "get video-scale of video":
    check content.getVideo.video.scale == (width: 100.0, height: 100.0)
  
  test "get video-rotate of video":
    check content.getVideo.video.rotate == 0.0
  
  test "get video-opacity of video":
    check content.getVideo.video.opacity == 0.0
  
  test "get audio-volume of video":
    check content.getVideo.audio.volume == 100.0