with love.graphics
  .printCentered = (text, font, x, y, r, sx, sy) ->
    .setFont font
    .print text, x, y, r, sx, sy, font\getWidth(text) / 2, font\getHeight(text) / 2
