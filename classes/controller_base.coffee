Base = require './base'

module.exports = class ControllerBase extends Base
  @action = (name, params, func)->
    func = params if arguments.length < 3
    @::[name] = func