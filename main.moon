love.load =  ->
  export *

  gamestate = require 'lib.gamestate'
  signal = require 'lib.signal'
  bump = require 'lib.bump'

  require 'class.common'
  require 'class.physical'
  require 'class.wall'
  require 'class.map'

  require 'state.game'

  with gamestate
    .switch game
    .registerEvents!

love.keypressed = (key) ->
  if key == 'escape'
    love.event.quit!
