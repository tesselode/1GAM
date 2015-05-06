export class Physical extends Common
  new: (@world, x, y, w, h) =>
    super!

    @world\add self, x, y, w, h

  draw: =>
    with love.graphics
      .setColor 150, 150, 150, 255
      .rectangle 'fill', @world\getRect self
