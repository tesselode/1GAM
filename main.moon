love.load =  ->
  love.graphics.setDefaultFilter 'nearest', 'nearest'

  export *

  --constants
  WIDTH = 768
  HEIGHT = 432

  --load libraries
  gamestate = require 'lib.gamestate'
  signal = require 'lib.signal'
  bump = require 'lib.bump'
  lume = require 'lib.lume'

  --load classes
  require 'class.common'
  require 'class.physical'
  require 'class.wall'
  require 'class.player'
  require 'class.map'
  require 'class.input-manager'

  --load states
  require 'state.game'

  --initialize gamestates
  with gamestate
    .switch game
    .registerEvents!

love.keypressed = (key) ->
  --boss key
  if key == 'escape'
    love.event.quit!
