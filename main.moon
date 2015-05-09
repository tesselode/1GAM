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
  flux = require 'lib.flux'
  lume = require 'lib.lume'
  require 'lib.extra'

  --load images
  image = {}
  image.characters = love.graphics.newImage 'image/characters.png'

  --load animations
  grid =
    characters: anim8.newGrid 32, 32, 736, 128
  animation =
    guy1:
      walk: anim8.newAnimation grid.characters('1-4', 1), .12
      run: anim8.newAnimation grid.characters('15-18', 1), .12
      jump: anim8.newAnimation grid.characters('5-7', 1), {.1, 100, 100}
    guy2:
      walk: anim8.newAnimation grid.characters('1-4', 2), .12
      run: anim8.newAnimation grid.characters('15-18', 2), .12
      jump: anim8.newAnimation grid.characters('5-7', 2), {.1, 100, 100}
    guy3:
      walk: anim8.newAnimation grid.characters('1-4', 3), .12
      run: anim8.newAnimation grid.characters('15-18', 3), .12
      jump: anim8.newAnimation grid.characters('5-7', 3), {.1, 100, 100}

  --load fonts
  font =
    small: love.graphics.newFont 'font/kenpixel_mini.ttf', 16
    medium: love.graphics.newFont 'font/kenpixel_mini_square.ttf', 32
    big: love.graphics.newFont 'font/kenpixel_mini_square.ttf', 64

  --load classes
  require 'class.common'
  require 'class.physical.physical'
  require 'class.physical.wall'
  require 'class.physical.player'
  require 'class.physical.bubble'
  require 'class.map'
  require 'class.input-manager'
  require 'class.cosmetic.animatable'
  require 'class.cosmetic.hud'
  require 'class.cosmetic.sound'

  --load sounds
  sound = {}
  for file in *love.filesystem.getDirectoryItems 'sound'
    sound[file\match('(.*).wav')] = Sound 'sound/'..file

  --load states
  require 'state.game'
  require 'state.title'

  --initialize gamestates
  with gamestate
    .switch title
    .registerEvents!

love.keypressed = (key) ->
  --boss key
  if key == 'escape'
    love.event.quit!
