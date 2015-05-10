export class Menu
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

  secondaryNext: =>
    @option[@current]\next!

  secondaryPrevious: =>
    @option[@current]\previous!

  select: =>
    @option[@current]\select!

  update: (dt) =>
    for k, v in pairs @option
      v\update dt

  draw: =>
    for k, v in pairs @option
      v\draw!

export class MenuOption
  new: (@drawable, @select) =>

  startHighlighted: =>

  highlight: =>

  unhighlight: =>

  next: =>

  previous: =>

  update: (dt) =>
    @drawable\update dt

  draw: =>
    @drawable\draw!

export class MenuOptionText extends MenuOption
  new: (text, font, x, y, @select) =>
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
