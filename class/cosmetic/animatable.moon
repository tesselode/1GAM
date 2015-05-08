--a general class for animatable text
export class Animatable extends Common
  new: (@x, @y) =>
    super!

    @item = {}
    @scale = 1

  addItem: (text, font, x, y, color) =>
    item =
      text: text
      font: font
      color: color or {r: 255, g: 255, b: 255, a: 255}
      x: x or 0
      y: y or 0
    table.insert @item, item

  draw: =>
    with love.graphics
      for item in *@item
        .setColor item.color.r, item.color.g, item.color.b, item.color.a
        .printCentered item.text, item.font, @x + item.x, @y + item.y, 0, @scale, @scale

--for menus
export class Menu extends Animatable
  new: (x, y) =>
    super x, y

    @selected = 1

    @color = {r: 255, g: 255, b: 255, a: 150}
    @highlightColor = {r: 255, g: 255, b: 255, a: 255}

  next: =>
    @selected += 1
    if @selected > #@item
      @selected = 1

  previous: =>
    @selected -= 1
    if @selected == 0
      @selected = #@item

  draw: =>
    with love.graphics
      for i, v in ipairs @item
        if i == @selected
          .setColor @highlightColor.r, @highlightColor.g, @highlightColor.b, @highlightColor.a
        else
          .setColor @color.r, @color.g, @color.b, @color.a
        .printCentered v.text, v.font, @x + v.x, @y + v.y, 0, @scale, @scale
