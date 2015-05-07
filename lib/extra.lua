do
  local _with_0 = love.graphics
  _with_0.printCentered = function(text, font, x, y, r, sx, sy)
    _with_0.setFont(font)
    return _with_0.print(text, x, y, r, sx, sy, font:getWidth(text) / 2, font:getHeight(text) / 2)
  end
  return _with_0
end
