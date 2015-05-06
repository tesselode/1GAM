love.load =  ->
  export *

  gamestate = require 'lib.gamestate'

  require 'class.common'

  require 'state.game'

  with gamestate
    .switch game
    .registerEvents!
