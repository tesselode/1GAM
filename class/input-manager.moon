export class InputManager
  new: =>
    @controls = {}
    @controls[1] =
      left: 'left'
      right: 'right'
      jump: 'up'
    @controls[2] =
      left: 'a'
      right: 'd'
      jump: 'w'

    @enabled = false
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

  keypressed: (key) =>
    if @enabled
      --jumping
      for i, v in ipairs @controls
        if key == v.jump
          game.signal.emit 'player-jump', i

  keyreleased: (key) =>
    if @enabled
      --end jump
      for i, v in ipairs @controls
        if key == v.jump
          game.signal.emit 'player-end-jump', i
