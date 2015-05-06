export class Player extends Physical
  new: (world, x, y) =>
    super world, x, y, 16, 16

    @filter = (other) =>
      --collide with walls and other players
      if other.__class == Wall or other.__class == Player
        return 'slide'

    @vx = 0
    @vy = 0

    @onGround = false
    @jumping = false
    @time = 0

    --tweak these!
    @gravity = 1500
    @quickFall = 3000
    @walkAcceleration = 1000
    @horizontalDrag = 500
    @horizontalMaxSpeed = 300
    @baseJumpPower = 450
    @additionalJumpPower = 100

  walk: (dt, v) =>
    @vx += v * @walkAcceleration * dt

  jump: =>
    if @onGround
      @vy = -@baseJumpPower - @additionalJumpPower * (math.abs(@vx) / @horizontalMaxSpeed)
      @jumping = true
      @animation.jump\gotoFrame 2

  endJump: =>
    @jumping = false

  update: (dt) =>
    super dt

    --reset on ground status
    @onGround = false

    --horizontal drag
    if @vx < 0
      @vx += @horizontalDrag * dt
      if @vx > 0
        @vx = 0
    if @vx > 0
      @vx -= @horizontalDrag * dt
      if @vx < 0
        @vx = 0

    --limit horizontal speed
    @vx = lume.clamp @vx, -@horizontalMaxSpeed, @horizontalMaxSpeed

    --gravity
    if @vy < 0 and @jumping == false
      @vy += (@gravity + @quickFall) * dt
    else
      @vy += @gravity * dt

    --apply movement
    _, _, cols = @move @vx * dt, @vy * dt

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

  drawDebug: =>
    --draw hitbox
    if true
      x, y, w, h = @world\getRect self
      with love.graphics
        .setColor 255, 255, 255, 100
        .rectangle 'fill', x, y, w, h
