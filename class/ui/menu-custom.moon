export class MapSelector extends MenuOption
  new: (@select) =>
    @timer = timer.new!

    --load map previews
    @maps = {}
    for file in *love.filesystem.getDirectoryItems 'level'
      if file\find '.oel'
        name = file\match '(.*).oel'
        print file, name
        table.insert @maps, {name: name, image: love.graphics.newImage 'level/'..name..'.png'}

    @scale = .75
    @selected = 1
    @x = 0
    @goalX = 0

    @canvas = love.graphics.newCanvas WIDTH * @scale, HEIGHT * @scale

  startHighlighted: =>
    @color = {255, 255, 255, 255}

  highlight: =>
    @color = {255, 255, 255, 255}

  unhighlight: =>
    @color = {150, 150, 150, 255}

  previous: =>
    @selected -= 1
    if @selected == 0
      @selected = #@maps

  next: =>
    @selected += 1
    if @selected > #@maps
      @selected = 1

  select: =>
    @timer.add 0.5, ->
      gamestate.switch game, @maps[@selected].name

  update: (dt) =>
    @timer.update dt

    @x = WIDTH * @scale * (@selected - 1)
    @goalX = lume.lerp @goalX, @x, .15

  draw: =>
    cx, cy = WIDTH / 2, HEIGHT / 2
    pw, ph = WIDTH * @scale, HEIGHT * @scale

    --render map preview
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      with love.graphics
        .setColor 255, 255, 255, 255
        for i = 1, #@maps
          x = pw * (i - 1) - @goalX
          .draw @maps[i].image, lume.round(x), 0, 0, @scale, @scale

    --draw map preview
    with love.graphics
      .setColor @color
      .setLineWidth 4
      .rectangle 'line', cx - pw / 2, cy - ph / 2, pw, ph
      .draw @canvas, cx - pw / 2, cy - ph / 2
