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
    let position = @[muml2DPosition(frame: (-1.0, -1.0), x: (0.0, 0.0), y: (0.0, 0.0))]
    check video.video.position == position
  
  test "get video-scale of video":
    let scale = @[mumlScale(frame: (-1.0, -1.0), width: (100.0, 100.0), height: (100.0, 100.0))]
    check video.video.scale == scale
  
  test "get video-rotate of video":
    let rotate = @[mumlValue(frame: (-1.0, -1.0), value: (0.0, 0.0))]
    check video.video.rotate == rotate
  
  test "get video-opacity of video":
    let opacity = @[mumlValue(frame: (-1.0, -1.0), value: (0.0, 0.0))]
    check video.video.opacity == opacity
  
  test "get audio-volume of video":
    let volume = @[mumlValue(frame: (-1.0, -1.0), value: (100.0, 100.0))]
    check video.audio.volume == volume

suite "to parse a video includes animations":
  let
    content = muml("tests/assets/muml_video_include_animation.json").content
    video = content[0]
  
  test "get video-position of video":
    check video.video.position[0].frame.start == 0.0