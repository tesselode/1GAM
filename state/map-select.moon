export mapSelect

mapSelect =
  enter: =>
    @menu = Menu!
    @menu\addOption MapSelector!
    @menu\addOption MenuOptionText 'Back', font.medium, WIDTH / 2, HEIGHT * .85, =>
      gamestate.switch title

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    @menu\update dt

  keypressed: (key) =>
    if key == 'up'
      @menu\previous!
    if key == 'down'
      @menu\next!
    if key == 'left'
      @menu\secondaryPrevious!
    if key == 'right'
      @menu\secondaryNext!
    if key == 'return'
      @menu\select!

  draw: =>
    @canvas\clear 50, 50, 50, 255
    @canvas\renderTo ->
      @menu\draw!

    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
