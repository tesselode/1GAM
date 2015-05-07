export class Hud extends Common
  new: =>
    super!

    @blackAlpha = 255

    @animatable = {}

    --countoff message
    game.signal.register 'game-countoff', ->
      @tween\to self, .5, {blackAlpha: 0}

      countoff = Animatable WIDTH / 2, HEIGHT / 2 + HEIGHT
      with countoff
        \addItem 'Ready?', font.big, 0, 0
        \addItem 'Go!', font.big, 0, HEIGHT
        .tween\to(countoff, 0.5, {y: HEIGHT / 2})\ease 'backinout'
        .timer.add 1, ->
          .tween\to(countoff, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
          .timer.add 1, ->
            .tween\to(countoff, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'
      table.insert @animatable, countoff

    --win message
    game.signal.register 'player-win', (playerNum) ->
      @timer.add 1.5, ->
        @tween\to self, .5, {blackAlpha: 255}

      winMessage = Animatable WIDTH / 2, HEIGHT / 2
      with winMessage
        \addItem 'Player '..playerNum..' wins!', font.big, 0, HEIGHT
        .tween\to(winMessage, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
        .timer.add 1.5, ->
          .tween\to(winMessage, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'
      table.insert @animatable, winMessage

  update: (dt) =>
    super dt

    for animatable in *@animatable
      animatable\update dt

  draw: =>
    with love.graphics
      .setColor 0, 0, 0, @blackAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    for animatable in *@animatable
      animatable\draw!
