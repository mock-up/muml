import unittest, mumlnim

suite "to parse a simple video":
  let
    content = muml("tests/assets/muml_video.json").content
    video = content[0]

  test "get path of video":
    check video.path == "/xxx/clip1.mp4"

  test "get frame of video":
    check video.frame == (start: 0.0, `end`: 100.0)
  
  test "get video-frame of video":
    check video.video.frame == (start: 0.0, `end`: 100.0)
  
  test "get video-position of video":
    check video.video.position == (x: 0.0, y: 0.0)
  
  test "get video-scale of video":
    check video.video.scale == (width: 100.0, height: 100.0)
  
  test "get video-rotate of video":
    check video.video.rotate == 0.0
  
  test "get video-opacity of video":
    check video.video.opacity == 0.0
  
  test "get audio-volume of video":
    check video.audio.volume == 100.0

suite "to parse a video includes animations":
  let
    content = muml("tests/assets/muml_video_include_animation.json").content
    video = content[0]
  
  test "get video-position of video":
    check video.video.position.value == @[
      (x: (start: 0, `end`: 50), y: (start: 0, `end`: 0)),
      (x: (start: 50, `end`: 100), y: (start: 0, `end`: -50))
    ]