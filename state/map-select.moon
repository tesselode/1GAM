export mapSelect

mapSelect =
  enter: (previous) =>
    @timer = timer.new!
    @tween = flux.group!

    if previous == game
      @blackAlpha = 255
      @tween\to self, .5, {blackAlpha: 0}
    else
      @blackAlpha = 0
    @takeInput = true

    @text = UIText 'Select map', font.medium, WIDTH / 2, HEIGHT * .05
    @menu = Menu!
    @menu\addOption MapSelector!
    @menu\addOption MenuOptionText 'Back', font.medium, WIDTH / 2, HEIGHT * .925, =>
      gamestate.switch title

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    sound.voiceSelectMap\play!

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    @menu\update dt

  keypressed: (key) =>
    if @takeInput
      if key == 'up' or key == 'w'
        @menu\previous!
        sound.menuBlip\play!

      if key == 'down' or key == 's'
        @menu\next!
        sound.menuBlip\play!

      if key == 'left' or key == 'a'
        @menu\secondaryPrevious!
        if @menu.current == 1
          sound.menuBlip\play!

      if key == 'right' or key == 'd'
        @menu\secondaryNext!
        if @menu.current == 1
          sound.menuBlip\play!

      if key == 'return'
        sound.menuSelect\play!
        @menu\select!
        if @menu.current == 1
          @takeInput = false
          @tween\to self, .5, {blackAlpha: 255}

  draw: =>
    @canvas\clear 50, 50, 50, 255
    @canvas\renderTo ->
      @text\draw!
      @menu\draw!

      --fade out effect
      with love.graphics
        .setColor 0, 0, 0, @blackAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
