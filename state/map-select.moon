export mapSelect

mapSelect =
  enter: =>
    @menu = Menu!
    @menu\addOption MapSelector!

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  draw: =>
    @canvas\clear 50, 50, 50, 255
    @canvas\renderTo ->
      @menu\draw!

    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
