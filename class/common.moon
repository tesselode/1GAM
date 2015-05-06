export class Common
  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .print 'hello world'
