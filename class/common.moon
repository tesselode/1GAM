export class Common
  new: =>
    @timer = timer.new!
    @drawDepth = 0

  update: (dt) =>
    @timer.update dt

  draw: =>

  drawDebug: =>
