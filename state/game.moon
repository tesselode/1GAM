export game

game =
  enter: =>
    @map = Map 'level/big arena.oel'

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  draw: =>
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      @map\draw!

    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
