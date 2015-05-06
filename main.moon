love.load =  ->
  love.graphics.setDefaultFilter 'nearest', 'nearest'

  export *

  --constants
  WIDTH = 768
  HEIGHT = 432

  --load libraries
  gamestate = require 'lib.gamestate'
  timer = require 'lib.timer'
  signal = require 'lib.signal'
  bump = require 'lib.bump'
  anim8 = require 'lib.anim8'
  lume = require 'lib.lume'
  require 'extra'

  --load images
  image = {}
  image.spritesheet = love.graphics.newImage 'image/spritesheet.png'

  --load animations
  grid =
    spriteSheet: anim8.newGrid 32, 32, 736, 128
  animation =
    guy1:
      walk: anim8.newAnimation grid.spriteSheet('1-4', 1), .12
      run: anim8.newAnimation grid.spriteSheet('15-18', 1), .12
      jump: anim8.newAnimation grid.spriteSheet('5-7', 1), {.1, 100, 100}
    guy2:
      walk: anim8.newAnimation grid.spriteSheet('1-4', 2), .12
      run: anim8.newAnimation grid.spriteSheet('15-18', 2), .12
      jump: anim8.newAnimation grid.spriteSheet('5-7', 2), {.1, 100, 100}
    guy3:
      walk: anim8.newAnimation grid.spriteSheet('1-4', 3), .12
      run: anim8.newAnimation grid.spriteSheet('15-18', 3), .12
      jump: anim8.newAnimation grid.spriteSheet('5-7', 3), {.1, 100, 100}

  --load fonts
  font =
    default: love.graphics.newFont 12
    medium: love.graphics.newFont 24
    big: love.graphics.newFont 48

  --load classes
  require 'class.common'
  require 'class.physical'
  require 'class.wall'
  require 'class.player'
  require 'class.bubble'
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
