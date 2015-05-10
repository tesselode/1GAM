export title

title =
  enter: =>
    @text = UIText 'hello world!', font.medium, WIDTH / 2, HEIGHT / 2
    @text.shadowDistance = 2

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  draw: =>
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      with love.graphics
        .setColor 150, 150, 150, 255
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT
      @text\draw!

    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
