export class Hud extends Common
  new: =>
    super!

    @blackAlpha = 255

    @message = {}


    --countoff message
    game.signal.register 'game-countoff', ->
      --fade in from black
      @tween\to self, .5, {blackAlpha: 0}

      message = UIGroup WIDTH / 2, HEIGHT / 2 + HEIGHT

      with message
        \addText UIText 'Round '..game.rounds, font.big, 0, 0
        \addText UIText game.p1score..' - '..game.p2score, font.medium, 0, HEIGHT * .1
        \addText UIText 'Go!', font.big, 0, HEIGHT

        .tween\to(message, 0.5, {y: HEIGHT / 2})\ease 'backinout'
        .timer.add 1, ->
          .tween\to(message, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
          .timer.add 1, ->
            .tween\to(message, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'

      table.insert @message, message

    --round win message
    game.signal.register 'round-end', (playerNum) ->
      @timer.add 1.5, ->
        @tween\to self, .5, {blackAlpha: 255}

      message = UIGroup WIDTH / 2, HEIGHT / 2

      with message
        \addText UIText 'Player '..playerNum..' wins!', font.big, 0, HEIGHT

        .tween\to(message, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
        .timer.add 1.5, ->
          .tween\to(message, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'

      table.insert @message, message

    --match win message
    game.signal.register 'match-end', (playerNum) ->
      @timer.add 1.5, ->
        @tween\to self, .5, {blackAlpha: 255}

      message = UIGroup WIDTH / 2, HEIGHT / 2

      with message
        \addText UIText 'Champion:', font.medium, 0, HEIGHT * .95
        \addText UIText 'Player '..playerNum, font.big, 0, HEIGHT * 1.05

        .tween\to(message, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
        .timer.add 1.5, ->
          .tween\to(message, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'

      table.insert @message, message

  update: (dt) =>
    super dt

    for k, v in pairs @message
      v\update dt

  draw: =>
    with love.graphics
      .setColor 0, 0, 0, @blackAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    for k, v in pairs @message
      v\draw!
