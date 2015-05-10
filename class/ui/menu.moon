export class Menu extends Common
  new: =>
    @option = {}
    @current = 1

  next: =>
    @current += 1
    if @current > #@option
      @current = 1

  previous: =>
    @current -= 1
    if @current == 0
      @current = #@option

  draw: =>
    for option in *@option
      option\draw!

export class MenuOption extends Common
  new: (@drawable) =>

  draw: =>
    @drawable\draw!
