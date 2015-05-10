export class MapSelector extends MenuOption
  new: =>
    --load map previews
    @maps = {}
    for file in *love.filesystem.getDirectoryItems 'level'
      if file\find '.oel'
        name = file\match '(.*).oel'
        print file, name
        table.insert @maps, {name: name, image: love.graphics.newImage 'level/'..name..'.png'}

    @scale = .5
    @selected = 1

    @canvas = love.graphics.newCanvas WIDTH * @scale, HEIGHT * @scale

  update: (dt) =>

  draw: =>
    --render map preview
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      with love.graphics
        .setColor 255, 255, 255, 255
        .draw @maps[1].image, 0, 0, 0, @scale, @scale

    --draw map preview
    with love.graphics
      .setColor 255, 255, 255, 255
      x = WIDTH / 2 - (WIDTH * @scale) / 2
      y = HEIGHT / 2 - (HEIGHT * @scale) / 2
      .draw @canvas, x, y
