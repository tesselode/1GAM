export mapSelect

mapSelect =
  enter: =>
    --fixed timestep updating
    @updateInterval = 1 / 120
    @updateTimer = @updateInterval

    @timer = timer.new!
    @tween = flux.group!

    @verticalPosition = 1
    @takeInput = true
    @blackAlpha = 0

    --load maps
    @maps = {}
    for file in *love.filesystem.getDirectoryItems 'level'
      if file\find '.oel'
        name = file\match '(.*).oel'
        print file, name
        table.insert @maps, {name: name, image: love.graphics.newImage 'level/'..name..'.png'}

    --map preview settings
    @preview =
      x: 0
      goalX: 0
      selected: 1
      size: .75
    @preview.canvas = love.graphics.newCanvas WIDTH * @preview.size, HEIGHT * @preview.size

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    --play a sound
    sound.voiceSelectMap\play!

  update: (dt) =>
    @updateTimer -= dt
    while @updateTimer <= 0
      @updateTimer += @updateInterval

      @timer.update dt
      @tween\update dt

      --update map preview
      @preview.goalX = (WIDTH * @preview.size) * (@preview.selected - 1)
      @preview.x = lume.lerp @preview.x, @preview.goalX, .075

  keypressed: (key) =>
    if @takeInput
      if key == 'up' or key == 'down'
        sound.menuBlip\play!
        if @verticalPosition == 1
          @verticalPosition = 2
        else
          @verticalPosition = 1

      --cycle through maps
      if @verticalPosition == 1
        with @preview
          if key == 'left'
            .selected -= 1
            sound.menuBlip\play!
          elseif key == 'right'
            .selected += 1
            sound.menuBlip\play!

          if .selected == 0
            .selected = #@maps
          elseif .selected > #@maps
            .selected = 1

        if key == 'return'
          @takeInput = false
          @tween\to self, 0.5, {blackAlpha: 255}
          sound.menuSelect\play!
          @timer.add 0.5, ->
            gamestate.switch game, @maps[@preview.selected].name

      if @verticalPosition == 2
        if key == 'return'
          sound.menuSelect\play!
          gamestate.switch title

  draw: =>
    cx, cy = WIDTH / 2, HEIGHT / 2 --center of screen
    ps = @preview.size --scale of map preview
    pw, ph = WIDTH * @preview.size, HEIGHT * @preview.size --overall size of map preview

    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      --render map preview
      @preview.canvas\clear 0, 0, 0, 255
      @preview.canvas\renderTo ->
        with love.graphics
          .setColor 255, 255, 255, 255
          for i = 1, #@maps
            .draw @maps[i].image, pw * (i - 1) - math.floor(@preview.x), 0, 0, ps, ps

      with love.graphics
        --draw map preview (with outline)
        if @verticalPosition == 1
          .setColor 255, 255, 255, 255
        else
          .setColor 150, 150, 150, 255
        .draw @preview.canvas, cx, cy, 0, 1, 1, pw / 2, ph / 2
        .setLineWidth 4
        .rectangle 'line', cx - pw / 2, cy - ph / 2, pw, ph

        --draw back "button"
        if @verticalPosition == 2
          .setColor 255, 255, 255, 255
        else
          .setColor 150, 150, 150, 255
        .printCentered 'Back', font.medium, cx, HEIGHT * .925

        --draw fade out
        .setColor 0, 0, 0, @blackAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    --draw main canvas
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, .getHeight! / HEIGHT, .getHeight! / HEIGHT
