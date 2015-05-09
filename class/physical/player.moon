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
    @jumping = false
    @time = 0
    @won = false

    --tweak these!
    @gravity = 1500
    @quickFall = 3000
    @walkAcceleration = 1000
    @horizontalDrag = 3000
    @horizontalMaxSpeed = 300
    @verticalMaxSpeed = 1000
    @baseJumpPower = 450
    @additionalJumpPower = 100

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

  endJump: =>
    @jumping = false

  update: (dt) =>
    super dt

    --reset on ground status
    @onGroundPrevious = @onGround
    @onGround = false

    --horizontal drag
    if @vx < 0
      @vx += @currentDrag * dt
      if @vx > 0
        @vx = 0
    if @vx > 0
      @vx -= @currentDrag * dt
      if @vx < 0
        @vx = 0

    --limit horizontal speed
    @vx = lume.clamp @vx, -@horizontalMaxSpeed, @horizontalMaxSpeed

    --gravity
    if @vy < 0 and @jumping == false
      @vy += (@gravity + @quickFall) * dt
    else
      @vy += @gravity * dt

    --limit vertical speed
    @vy = lume.clamp @vy, -@verticalMaxSpeed, @verticalMaxSpeed

    --apply movement
    x, y, cols = @move @vx * dt, @vy * dt

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
    @animation.walk\update dt * (math.abs(@vx) / @horizontalMaxSpeed) ^ .3
    @animation.run\update dt * (math.abs(@vx) / @horizontalMaxSpeed) ^ .3
    @animation.jump\update dt

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
