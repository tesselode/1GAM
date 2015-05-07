export class Sound
  buffer: 10

  new: (filename, type) =>
    @slot = {}
    for i = 1, @@buffer
      @slot[i] = love.audio.newSource filename, type

  play: =>
    for i = 1, @@buffer
      with @slot[i]
        if \isStopped!
          \play!
          break
