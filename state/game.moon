export game

game =
  enter: =>
    @signal = signal.new!
    @map = Map 'level/big arena.oel'
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    @map\update dt

  keypressed: (key) =>
    if key == 'up'
      @signal.emit 'jump'

  draw: =>
    --redner to canvas
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      @map\draw!

    --draw canvas
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
