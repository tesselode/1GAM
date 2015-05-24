export title

title =
  enter: =>
    @titleText = UIText 'Bubble party!', font.big, WIDTH / 2, HEIGHT * .3

    --menu definition
    @menu = Menu!

    @menu\addOption MenuOptionText 'Play!', font.medium, WIDTH / 2, HEIGHT / 2, =>
      gamestate.switch mapSelect

    @menu\addOption MenuOptionText 'Options', font.medium, WIDTH / 2, HEIGHT * .6, =>
      gamestate.switch options

    @menu\addOption MenuOptionText 'Quit', font.medium, WIDTH / 2, HEIGHT * .7, =>
      love.event.quit!

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  keypressed: (key) =>
    if key == 'up'
      @menu\previous!
      sound.menuBlip\play!
    if key == 'down'
      @menu\next!
      sound.menuBlip\play!
    if key == 'return'
      @menu\select!
      sound.menuSelect\play!

  draw: =>
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      with love.graphics
        .setColor 50, 50, 50, 255
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT
      @titleText\draw!
      @menu\draw!

    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
