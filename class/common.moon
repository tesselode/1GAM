export class Common
  new: =>
    @timer = timer.new!
    @tween = flux.group!
    @drawDepth = 0

  update: (dt) =>
    @timer.update dt
    @tween\update dt

  clearSignals: =>

  draw: =>

  drawDebug: =>
