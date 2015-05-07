export menu

menu =
  enter: =>
    @animatable =
      title: Animatable WIDTH * .5, HEIGHT * (1/3)
      menu: Menu WIDTH * .5, HEIGHT * .5

    @animatable.title\addItem 'Insert title here!', font.big
    @animatable.menu\addItem 'Play!', font.medium
    @animatable.menu\addItem 'Options', font.medium, 0, HEIGHT * .1
    @animatable.menu\addItem 'Quit', font.medium, 0, HEIGHT * .2

    @canvas = love.graphics.newCanvas!

  update: (dt) =>
    for k, v in pairs @animatable
      v\update dt

  keypressed: (key) =>
    if key == 'up'
      @animatable.menu\previous!
    if key == 'down'
      @animatable.menu\next!

    if key == 'return'
      if @animatable.menu.selected == 1
        gamestate.switch game
      if @animatable.menu.selected == 3
        love.event.quit!

  draw: =>
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      for k, v in pairs @animatable
        v\draw!

    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
