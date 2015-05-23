export pause

pause =
  enter: =>
    @timer = timer.new!
    @tween = flux.group!

    @text1 = UIText 'Press enter to continue', font.medium, WIDTH / 2, HEIGHT * .45
    @text2 = UIText 'Press escape to quit', font.medium, WIDTH / 2, HEIGHT * .55
    @blackAlpha = 0
    @takeInput = true

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    @timer.update dt
    @tween\update dt

  keypressed: (key) =>
    if @takeInput
      if key == 'return'
        gamestate.pop!
      if key == 'escape'
        @takeInput = false
        sound.menuSelect\play!
        @tween\to self, 0.5, {blackAlpha: 255}
        @timer.add 0.5, ->
          gamestate.switch mapSelect

  draw: =>
    with love.graphics
      @canvas\renderTo ->
        .setColor 100, 100, 100, 255
        .draw game.canvas

        @text1\draw!
        @text2\draw!

        .setColor 0, 0, 0, @blackAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
