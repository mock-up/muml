import json

type mumlVideo* = object
  path*: string

proc getVideo* (json: JsonNode): mumlVideo = discard