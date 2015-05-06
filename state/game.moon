export game

game =
  enter: =>
    @world = bump.newWorld!

    @test = Physical self, 30, 30, 30, 30

  draw: =>
    @test\draw!
