export class Hud extends Common
  new: =>
    @animatable = {}

    --countoff message
    game.signal.register 'game-countoff', ->
      countoff = Animatable WIDTH / 2, HEIGHT / 2

      with countoff
        \addItem 'Ready?', font.big, 0, 0
        \addItem 'Go!', font.big, 0, HEIGHT
        .timer.add 1, ->
          .tween\to(countoff, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
          .timer.add 1, ->
            .tween\to(countoff, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'

      table.insert @animatable, countoff

    --win message
    game.signal.register 'player-win', (playerNum) ->
      winMessage = Animatable WIDTH / 2, HEIGHT / 2

      with winMessage
        \addItem 'Player '..playerNum..' wins!', font.big, 0, HEIGHT
        .tween\to(winMessage, 0.5, {y: HEIGHT / 2 - HEIGHT})\ease 'backinout'
        .timer.add 1.5, ->
          .tween\to(winMessage, 0.5, {y: HEIGHT / 2 - 2 * HEIGHT})\ease 'backinout'

      table.insert @animatable, winMessage

  update: (dt) =>
    for animatable in *@animatable
      animatable\update dt

  draw: =>
    for animatable in *@animatable
      animatable\draw!
