export class Map extends Common
  new: (filename) =>
    @world = bump.newWorld!
    @player = {}

    --load level
    for line in love.filesystem.lines filename
      if line\find '<rect'
        x = tonumber line\match 'x="(.-)"'
        y = tonumber line\match 'y="(.-)"'
        w = tonumber line\match 'w="(.-)"'
        h = tonumber line\match 'h="(.-)"'
        Wall @world, x, y, w, h
      elseif line\find '<Player'
        x = tonumber line\match 'x="(.-)"'
        y = tonumber line\match 'y="(.-)"'
        table.insert @player, Player @world, x, y, lume.randomchoice({'guy1', 'guy2', 'guy3'}), #@player + 1
      elseif line\find '<Bubble'
        x = tonumber line\match 'x="(.-)"'
        y = tonumber line\match 'y="(.-)"'
        --@bubble = Bubble self, x, y

  draw: =>
    for item in *@world\getItems!
      item\draw!
      item\drawDebug!
