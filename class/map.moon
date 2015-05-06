export class Map extends Common
  new: =>
    @world = bump.newWorld!

    Physical @world, 30, 30, 30, 30

  draw: =>
    for item in *@world\getItems!
      item\draw!
