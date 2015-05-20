export class Wall extends Physical
  new: (world, x, y, w, h) =>
    --extend past top of screen
    if y == 0
      y -= 100
      h += 100

    --extend past bottom of screen
    if y + h == HEIGHT
      h += 100

    super world, x, y, w, h
