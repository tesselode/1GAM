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
            @following = item
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
        @following.time += dt * 100
        --grow over time
        @goalRadius += (@growthSpeed + 5 * @growthSpeed * (@following.time / 60)) * dt

    --tweens
    @moveSpeed = lume.lerp @moveSpeed, .5, .01
    @x = lume.lerp @x, @goalX, @moveSpeed
    @y = lume.lerp @y, @goalY, @moveSpeed
    @radius = lume.lerp @radius, @goalRadius, .1
    @alpha = lume.lerp @alpha, 150, .03
    @brightness = lume.lerp @brightness, 0, .03

  draw: =>
    with love.graphics
      .setColor @brightness, @brightness, 255, @alpha
      .circle 'fill', @x, @y, @radius, 100

  drawDebug: =>
