export class UIGroup extends Common
  new: (@x, @y) =>
    super!

    @item = {}

  addText: (text) =>
    table.insert @item, text

  draw: =>
    for k, v in pairs @item
      v\draw @x, @y

export class UIText extends Common
  new: (@text, @font, @x, @y) =>
    super!

    @color = {255, 255, 255, 255}
    @align = 'center'
    @shadow = true
    @shadowDistance = 2
    @shadowColor = {0, 0, 0, 255}
    @sx = 1
    @sy = 1

  draw: (l, t) =>
    l = l or 0
    t = t or 0

    with love.graphics
      .setFont @font

      --set alignment
      local ox, oy
      if @align == 'center'
        ox = @font\getWidth(@text) / 2
        oy = @font\getHeight(@text) / 2

      --draw shadow
      if @shadow
        .setColor @shadowColor
        .print @text, @x + @shadowDistance + l, @y + @shadowDistance + t, 0, @sx, @sy, ox, oy

      --draw text
      .setColor @color
      .print @text, @x + l, @y + t, 0, @sx, @sy, ox, oy
