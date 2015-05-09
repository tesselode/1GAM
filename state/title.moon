export title

title =
  enter: (previous) =>
    @timer = timer.new!
    @tween = flux.group!

    @takeInput = true
    if previous == game
      @blackAlpha = 255
      @tween\to self, 0.5, {blackAlpha: 0}
    else
      @blackAlpha = 0

    @animatable =
      title: Animatable WIDTH * .5, HEIGHT * (1/3)
      menu: Menu WIDTH * .5, HEIGHT * .5

    @animatable.title\addItem 'Insert title here!', font.big
    @animatable.menu\addItem 'Play!', font.medium
    @animatable.menu\addItem 'Options', font.medium, 0, HEIGHT * .1
    @animatable.menu\addItem 'Quit', font.medium, 0, HEIGHT * .2

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    for k, v in pairs @animatable
      v\update dt

  keypressed: (key) =>
    if @takeInput
      if key == 'up'
        @animatable.menu\previous!
        sound.menuBlip\play!
      if key == 'down'
        @animatable.menu\next!
        sound.menuBlip\play!

      if key == 'return'
        if @animatable.menu.selected == 1
          --@takeInput = false
          --@tween\to self, 0.5, {blackAlpha: 255}
          --@timer.add 0.5, ->
          --  gamestate.switch game
          sound.menuSelect\play!
          gamestate.switch mapSelect
        if @animatable.menu.selected == 3
          love.event.quit!

  draw: =>
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      for k, v in pairs @animatable
        v\draw!

      with love.graphics
        .setColor 0, 0, 0, @blackAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
