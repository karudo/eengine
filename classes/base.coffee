heart = null
s =
  get: ->
    heart = require '../engine' unless heart?
    heart
  set: ->
    console.log '_heart !set'

module.exports = class Base
  Object.defineProperty @::, '_heart', s
  Object.defineProperty @::, '_h', s

  log: (s...)-> @_h.log 'BASE', s...