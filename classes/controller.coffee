Base = require './base'

module.exports = class Controller extends Base
  #constructor: ()->


  cb: (params...)->
    @curCb params...


  exec: (curMethod, params, @curCb)->
    if @[curMethod]
      @[curMethod] params...

