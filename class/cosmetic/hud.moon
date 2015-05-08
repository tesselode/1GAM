export class Hud extends Common
  new: =>
    super!

    @blackAlpha = 255

    @animatable = {}

    --countoff message
    game.signal.register 'game-countoff', ->
      @tween\to self, .5, {blackAlpha: 0}

      message = Animatable WIDTH / 2, HEIGHT / 2 + HEIGHT

      with message
        \addItem 'Round '..game.rounds, font.big, 2, 2, {r: 0, g: 0, b: 0, a: 255}
        \addItem 'Round '..game.rounds, font.big, 0, 0

        \addItem game.p1score..' - '..game.p2score, font.medium, 2, HEIGHT * .1 + 2, {r: 0, g: 0, b: 0, a: 255}
        \addItem game.p1score..' - '..game.p2score, font.medium, 0, HEIGHT * .1

        \addItem 'Go!', font.big, 2, HEIGHT + 2, {r: 0, g: 0, b: 0, a: 255}
        \addItem 'Go!', font.big, 0, HEIGHT

        .tween\to(message, 0.5, {y: HEIGHT / 2})\ease 'backinout'
        .timer.add 1, ->
          .tween\to(message, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
          .timer.add 1, ->
            .tween\to(message, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'

      table.insert @animatable, message

    --round win message
    game.signal.register 'round-end', (playerNum) ->
      @timer.add 1.5, ->
        @tween\to self, .5, {blackAlpha: 255}

      message = Animatable WIDTH / 2, HEIGHT / 2

      with message
        \addItem 'Player '..playerNum..' wins!', font.big, 2, HEIGHT + 2, {r: 0, g: 0, b: 0, a: 255}
        \addItem 'Player '..playerNum..' wins!', font.big, 0, HEIGHT

        .tween\to(message, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
        .timer.add 1.5, ->
          .tween\to(message, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'

      table.insert @animatable, message

    --match win message
    game.signal.register 'match-end', (playerNum) ->
      @timer.add 1.5, ->
        @tween\to self, .5, {blackAlpha: 255}

      message = Animatable WIDTH / 2, HEIGHT / 2

      with message
        \addItem 'Champion:', font.medium, 2, HEIGHT * .95 + 2, {r: 0, g: 0, b: 0, a: 255}
        \addItem 'Champion:', font.medium, 0, HEIGHT * .95

        \addItem 'Player '..playerNum, font.big, 2, HEIGHT * 1.05 + 2, {r: 0, g: 0, b: 0, a: 255}
        \addItem 'Player '..playerNum, font.big, 0, HEIGHT * 1.05

        .tween\to(message, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
        .timer.add 1.5, ->
          .tween\to(message, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'

      table.insert @animatable, message

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
