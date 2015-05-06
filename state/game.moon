export game

game =
  enter: =>
    @signal = signal.new!
    @map = Map 'level/big arena.oel'
    @inputManager = InputManager!
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    @updateInterval = 1 / 120
    @updateTimer = @updateInterval

  update: (dt) =>
    --fixed timestep updates
    @updateTimer -= dt
    while @updateTimer <= 0
      @updateTimer += @updateInterval
      @inputManager\update @updateInterval
      @map\update @updateInterval

  keypressed: (key) => @inputManager\keypressed key

  keyreleased: (key) => @inputManager\keyreleased key

  draw: =>
    --redner to canvas
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      @map\draw!

    --draw canvas
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
