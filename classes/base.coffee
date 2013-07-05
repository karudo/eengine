heart = null

module.exports = class Base
  #TODO: refactor it!
  Object.defineProperty @::, '_h',
    get: ->
      heart = require '../engine' unless heart?
      heart
    set: ->
      console.log '_heart !set'


  log: (s...)-> @_h.log 'BASE', s...