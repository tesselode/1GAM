export class Player extends Physical
  new: (world, x, y, character, @playerNum) =>
    super world, x, y, 16, 16

    @filter = (other) =>
      --collide with walls and other players
      if other.__class == Wall or other.__class == Player
        return 'slide'

    @vx = 0
    @vy = 0

    @currentDrag = 0
    @onGround = false
    @onGroundPrevious = false
    @canDoubleJump = true
    @jumping = false
    @diving = false
    @time = 0
    @won = false
    @hasBubble = false
    @timeScale = 1

    --tweak these!
    @gravity = 1500
    @verticalMaxSpeed = 600
    @diveGravity = 5000
    @diveMaxSpeed = 800
    @quickFall = 3000
    @walkAcceleration = 800
    @horizontalDrag = 2000
    @horizontalMaxSpeed = 300
    @baseJumpPower = 450
    @doubleJumpPower = 350
    @additionalJumpPower = 100
    @bubbleSpeedMultiplier = 1

    --animation stuff
    @animation =
      walk: animation[character].walk\clone!
      run: animation[character].run\clone!
      jump: animation[character].jump\clone!
    @facingDirection = 1
    @drawDepth = 100

    --sound stuff
    @walkSoundTimer = 1

    --signals
    @walkRegistry = game.signal.register 'player-walk', (playerNum, dt, v) ->
      if playerNum == @playerNum
        @walk dt, v
    @jumpRegistry = game.signal.register 'player-jump', (playerNum) ->
      if playerNum == @playerNum
        @jump!
    @endJumpRegistry = game.signal.register 'player-end-jump', (playerNum) ->
      if playerNum == @playerNum
        @endJump!
    @diveRegistry = game.signal.register 'player-dive', (playerNum) ->
      if playerNum == @playerNum
        @dive!
    @endDiveRegistry = game.signal.register 'player-end-dive', (playerNum) ->
      if playerNum == @playerNum
        @endDive!

  walk: (dt, v) =>
    --calculate drag
    if v == 0 or (@vx ~= 0 and lume.sign(@vx) ~= lume.sign(v))
      @currentDrag = @horizontalDrag
    else
      @currentDrag = 0

    @vx += v * @walkAcceleration * dt

  jump: =>
    if @onGround
      @vy = -@baseJumpPower - @additionalJumpPower * (math.abs(@vx) / @horizontalMaxSpeed)
      @jumping = true
      @animation.jump\gotoFrame 2
      sound.playerJump\play!
    elseif @canDoubleJump
      @vy = -@doubleJumpPower - @additionalJumpPower * (math.abs(@vx) / @horizontalMaxSpeed)
      @canDoubleJump = false
      @jumping = true
      @animation.jump\gotoFrame 2
      sound.playerDoubleJump\play!

  endJump: =>
    @jumping = false

  dive: =>
    @diving = true
    @vy = @diveMaxSpeed * .3

  endDive: =>
    @diving = false
    --@vy = @verticalMaxSpeed

  update: (dt) =>
    super dt

    --adjust time scale depending on Bubble
    if @hasBubble
      @timeScale = @bubbleSpeedMultiplier
    else
      @timeScale = 1

    --reset on ground status
    @onGroundPrevious = @onGround
    @onGround = false

    --horizontal drag
    if @vx < 0
      @vx += @currentDrag * dt * @timeScale
      if @vx > 0
        @vx = 0
    if @vx > 0
      @vx -= @currentDrag * dt * @timeScale
      if @vx < 0
        @vx = 0

    --limit horizontal speed
    @vx = lume.clamp @vx, -@horizontalMaxSpeed, @horizontalMaxSpeed

    --gravity
    local g
    if @diving
      g = @diveGravity
    else
      g = @gravity
    if @vy < 0 and @jumping == false
      @vy += (g + @quickFall) * dt * @timeScale
    else
      @vy += g * dt * @timeScale

    --limit vertical speed
    local max
    if @diving
      max = @diveMaxSpeed
    else
      max = @verticalMaxSpeed
    @vy = lume.clamp @vy, -max, max

    --apply movement
    x, y, cols = @move @vx * dt * @timeScale, @vy * dt * @timeScale

    for col in *cols
      if col.other.__class == Wall or col.other.__class == Player
        --horizontal collisions
        if col.normal.x ~= 0
          @vx = 0
        --vertical collisions
        if col.normal.y ~= 0
          @vy = 0
          if col.normal.y < 0
            @onGround = true
            @canDoubleJump = true

    --vertical wrapping
    if y > HEIGHT + 16
      @world\update self, x, -8

    --check for win condition
    if (not @won) and @time >= 60
      @won = true
      game.signal.emit 'player-win', @playerNum

    --reset walking animation
    if math.abs(@vx) < 10
      @animation.walk\gotoFrame 1
      @animation.run\gotoFrame 1
    --face the right direction
    if math.abs(@vx) > 10
      @facingDirection = lume.sign @vx
    --falling animation
    if @vy > 0
      @animation.jump\gotoFrame 3

    --update animations
    @animation.walk\update dt * @timeScale * (math.abs(@vx) / @horizontalMaxSpeed) ^ .3
    @animation.run\update dt * @timeScale * (math.abs(@vx) / @horizontalMaxSpeed) ^ .3
    @animation.jump\update dt * @timeScale

  clearSignals: =>
    game.signal.remove 'player-walk', @walkRegistry
    game.signal.remove 'player-jump', @jumpRegistry
    game.signal.remove 'player-end-jump', @endJumpRegistry

  draw: =>
    x, y = @getCenter!
    with love.graphics
      .setColor 255, 255, 255, 255
      if @onGround
        --draw walking animation
        if math.abs(@vx) / @horizontalMaxSpeed > 0.6
          @animation.run\draw image.characters, x, y - 7, 0, 1 * @facingDirection, 1, 16, 16
        else
          @animation.walk\draw image.characters, x, y - 7, 0, 1 * @facingDirection, 1, 16, 16
      else
        --draw jumping animation
        @animation.jump\draw image.characters, x, y - 7, 0, 1 * @facingDirection, 1, 16, 16

      --draw timer below player
      text = tostring @time
      if text\find '%.'
        text = text\match '(.*%.%d)'
      .setColor 0, 0, 0, 255
      .printCentered text, font.small, x + 1, y + 17
      .setColor 255, 255, 255, 255
      .printCentered text, font.small, x, y + 16

  drawDebug: =>
    --draw hitbox
    if false
      x, y, w, h = @world\getRect self
      with love.graphics
        .setColor 255, 255, 255, 100
        .rectangle 'fill', x, y, w, h
