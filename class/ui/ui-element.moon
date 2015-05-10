export class UIText extends Common
  new: (@text, @font, @x, @y) =>
    @color = {255, 255, 255, 255}
    @align = 'center'
    @shadow = true
    @shadowDistance = 2
    @shadowColor = {0, 0, 0, 255}
    @sx = 1
    @sy = 1

  draw: =>
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
        .print @text, @x + @shadowDistance, @y + @shadowDistance, 0, @sx, @sy, ox, oy

      --draw text
      .setColor @color
      .print @text, @x, @y, 0, @sx, @sy, ox, oy
