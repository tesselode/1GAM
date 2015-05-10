export class Menu extends Common
  new: =>
    @option = {}
    @current = 1

  addOption: (option) =>
    table.insert @option, option
    --highlight first option
    if #@option == 1
      @option[#@option]\startHighlighted!

  next: =>
    @option[@current]\unhighlight!

    --go to next menu option
    @current += 1
    if @current > #@option
      @current = 1

    @option[@current]\highlight!

  previous: =>
    @option[@current]\unhighlight!

    --go to previous menu option
    @current -= 1
    if @current == 0
      @current = #@option

    @option[@current]\highlight!

  select: =>
    @option[@current]\select!

  update: (dt) =>
    for k, v in pairs @option
      v\update dt

  draw: =>
    for k, v in pairs @option
      v\draw!

export class MenuOption extends Common
  new: (@drawable) =>

  startHighlighted: =>

  highlight: =>

  unhighlight: =>

  select: =>

  update: (dt) =>
    @drawable\update dt

  draw: =>
    @drawable\draw!

export class MenuOptionText extends MenuOption
  new: (text, font, x, y) =>
    @drawable = UIText text, font, x, y

    @highlightColor = {255, 255, 255, 255}
    @color = {150, 150, 150, 255}
    @drawable.color = @color

  startHighlighted: =>
    @drawable.color = @highlightColor

  highlight: =>
    @drawable.color = @highlightColor

  unhighlight: =>
    @drawable.color = @color
