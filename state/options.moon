export options

options =
  enter: =>
    @titleText = UIText 'Options', font.big, WIDTH / 2, HEIGHT * .3

    --menu definition
    @menu = Menu!

    --scale option
    text = 'Scale: '..option.scale..'X'
    @menu\addOption MenuOptionText text, font.medium, WIDTH / 2, HEIGHT / 2, =>
      option.scale += .5
      option.scale = 1 if option.scale > 4

      --apply screen size
      if not option.fullscreen
        love.window.setMode WIDTH * option.scale, HEIGHT * option.scale

    --fullscreen option
    if option.fullscreen
      text = 'Fullscreen: On'
    else
      text = 'Fullscreen: Off'
    @menu\addOption MenuOptionText text, font.medium, WIDTH / 2, HEIGHT * .6, =>
      option.fullscreen = not option.fullscreen

      --apply window options
      if option.fullscreen
        width, height = love.window.getDesktopDimensions!
        love.window.setMode width, height, {fullscreen: true}
      else
        love.window.setMode WIDTH * option.scale, HEIGHT * option.scale, {fullscreen: false}

    @menu\addOption MenuOptionText 'Back', font.medium, WIDTH / 2, HEIGHT * .7, =>
      gamestate.switch title

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

      --update menu text
      @menu.option[1].drawable.text = 'Scale: '..option.scale..'X'
      if option.fullscreen
        @menu.option[2].drawable.text = 'Fullscreen: On'
      else
        @menu.option[2].drawable.text = 'Fullscreen: Off'

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
