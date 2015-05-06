export class Physical extends Common
  new: (@world, x, y, w, h) =>
    super!

    @world\add self, x, y, w, h

  getCenter: =>
    x, y, w, h = @world\getRect self
    x + w / 2, y + h / 2

  move: (dx, dy) =>
    --moves to a relative position
    x, y = @world\getRect self
    return @world\move self, x + dx, y + dy, @filter

  drawDebug: =>
    with love.graphics
      .setColor 150, 150, 150, 255
      .rectangle 'fill', @world\getRect self
