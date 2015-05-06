export class Physical extends Common
  new: (@state, x, y, w, h) =>
    super!

    @state.world\add self, x, y, w, h

  draw: =>
    with love.graphics
      .setColor 150, 150, 150, 255
      .rectangle 'fill', @state.world\getRect self
