export class InputManager
  new: =>
    @controls = {}
    @controls[1] =
      left: 'left'
      right: 'right'
      jump: 'up'
      dive: 'down'
    @controls[2] =
      left: 'a'
      right: 'd'
      jump: 'w'
      dive: 's'

    @enabled = false
    game.signal.register 'game-countoff', -> @enabled = false
    game.signal.register 'game-start', -> @enabled = true

  update: (dt) =>
    if @enabled
      --walking
      for i, v in ipairs @controls
        with love.keyboard
          if .isDown v.left
            game.signal.emit 'player-walk', i, dt, -1
          elseif .isDown v.right
            game.signal.emit 'player-walk', i, dt, 1
          else
            game.signal.emit 'player-walk', i, dt, 0

  keypressed: (key) =>
    --pausing
    if key == 'escape'
      gamestate.push pause

    if @enabled
      --jumping
      for i, v in ipairs @controls
        if key == v.jump
          game.signal.emit 'player-jump', i
        elseif key == v.dive
          game.signal.emit 'player-dive', i

  keyreleased: (key) =>
    if @enabled
      --end jump
      for i, v in ipairs @controls
        if key == v.jump
          game.signal.emit 'player-end-jump', i
        elseif key == v.dive
          game.signal.emit 'player-end-dive', i
