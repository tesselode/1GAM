export game

game =
  enter: =>
    @map = Map 'level/big arena.oel'

  draw: =>
    @map\draw!
