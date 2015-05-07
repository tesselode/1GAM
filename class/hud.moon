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

  update: (dt) =>
    for animatable in *@animatable
      animatable\update dt

  draw: =>
    for animatable in *@animatable
      animatable\draw!
