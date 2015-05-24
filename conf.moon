love.conf = (t) ->
  t.identity = 'BubbleParty'
  t.version = '0.9.2'

  with t.window
    .title = 'Bubble Party'
    .fullscreentype = 'desktop'

  with t.modules
    .joystick = false
    .physics = false
