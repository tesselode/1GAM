export game

game =
  enter: =>
    --updating
    @updateInterval = 1 / 120
    @updateTimer = @updateInterval

    --various components
    @signal = signal.new!
    @timer = timer.new!
    @inputManager = InputManager!
    @hud = Hud!

    --gameflow
    @rounds = 0
    @p1score = 0
    @p2score = 0

    --cosmetic
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    @signal.register 'player-win', (playerNum) ->
      --track scores
      if playerNum == 1
        @p1score += 1
      elseif playerNum == 2
        @p2score += 1

      if @p1score == 2 or @p2score == 2
        --go back to the menu
        @signal.emit 'match-end', playerNum
        sound.voiceMatchOver\play!
        @timer.add 2, ->
          gamestate.switch menu
      else
        --go to next round
        @signal.emit 'round-end', playerNum
        sound.voiceRoundOver\play!
        @timer.add 2, ->
          @nextRound!


    @nextRound!

  nextRound: =>
    @rounds += 1

    --load map
    if @map
      @map\clearSignals!
    @map = Map 'big arena'

    --start the game
    @signal.emit 'game-countoff'
    sound.voiceReady\play!
    @timer.add 1.2, ->
      @signal.emit 'game-start'
      sound.voiceGo\play!

  update: (dt) =>
    --fixed timestep updates
    @updateTimer -= dt
    while @updateTimer <= 0
      @updateTimer += @updateInterval

      --update components
      @timer.update @updateInterval
      @inputManager\update @updateInterval
      @map\update @updateInterval
      @hud\update @updateInterval

  keypressed: (key) =>
    @inputManager\keypressed key
    if key == 'f1'
      @startRound!

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
