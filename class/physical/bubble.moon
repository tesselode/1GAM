export class Bubble extends Physical
  new: (world, @x, @y) =>
    super world, 0, 0, 512, 288

    @enabled = true
    @goalX = @x
    @goalY = @y
    @moveSpeed = .5
    @radius = 20
    @goalRadius = @radius
    @growthSpeed = 2
    @following = false
    @canSwitchPlayers = true
    @alpha = 150
    @brightness = 0

    @drawDepth = 50

    game.signal.register 'player-win', -> @enabled = false

  update: (dt) =>
    super dt

    --check for collisions with players
    if @enabled and @canSwitchPlayers
      for item in *@world\getItems!
        if item.__class == Player and @following ~= item
          otherX, otherY = item\getCenter!
          if lume.distance(@x, @y, otherX, otherY) < @radius
            --start following the player
            if @following
              @following.hasBubble = false
            @following = item
            @following.hasBubble = true
            @moveSpeed = .1
            @goalRadius = 20
            @alpha = 255
            @brightness = 255
            @canSwitchPlayers = false
            @timer.add 1, -> @canSwitchPlayers = true
            sound.bubbleGet\play!
            break

    if @following
      --follow a player
      @goalX, @goalY = @following\getCenter!

      if @enabled
        --give a player more time
        @following.time += dt
        --grow over time
        @goalRadius += (@growthSpeed + 5 * @growthSpeed * (@following.time / 60)) * dt

    --tweens
    @moveSpeed = lume.lerp @moveSpeed, .5, .01
    if lume.distance(@x, @y, @goalX, @goalY) > 100
      @x = @goalX
      @y = @goalY
    else
      @x = lume.lerp @x, @goalX, @moveSpeed
      @y = lume.lerp @y, @goalY, @moveSpeed
    @radius = lume.lerp @radius, @goalRadius, .1
    @alpha = lume.lerp @alpha, 100, .03
    @brightness = lume.lerp @brightness, 0, .01

  draw: =>
    with love.graphics
      --.setColor @brightness, @brightness, @brightness, @alpha
      x, y, r = math.floor(@x), math.floor(@y), math.floor(@radius)

      .setColor 255, 255, 255, @alpha
      .circle 'fill', x, y, r, 100

      .setLineWidth 2
      .setLineStyle 'rough'
      .setColor 255, 255, 255, 255
      .circle 'line', x, y, r - 2, 100
      .setColor 0, 0, 0, 255
      .circle 'line', x, y, r, 100

  drawDebug: =>
