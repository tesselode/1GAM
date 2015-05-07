export game

game =
  enter: =>
    --updating
    @updateInterval = 1 / 120
    @updateTimer = @updateInterval

    @signal = signal.new!
    @timer = timer.new!
    @map = Map 'level/big arena.oel'
    @inputManager = InputManager!
    @hud = Hud!
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    --start the game
    @signal.emit 'game-countoff'
    @timer.add 1.2, ->
      @signal.emit 'game-start'

  update: (dt) =>
    --fixed timestep updates
    @updateTimer -= dt
    while @updateTimer <= 0
      @updateTimer += @updateInterval

      @timer.update @updateInterval
      @inputManager\update @updateInterval
      @map\update @updateInterval
      @hud\update @updateInterval

  keypressed: (key) => @inputManager\keypressed key

  keyreleased: (key) => @inputManager\keyreleased key

  draw: =>
    --redner to canvas
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      @map\draw!
      @hud\draw!

    --draw canvas
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
