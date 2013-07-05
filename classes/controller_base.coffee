Base = require './base'

module.exports = class ControllerBase extends Base
  @action = (name, params, func)->
    @actions = {} unless @actions?
    if arguments.length < 3
      func = params
      params = {}
    @::[name] = func
    @actions[name] = {params}

