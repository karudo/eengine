Base = require './base'

{isFunction} = (require '../engine').i._

module.exports = class ControllerBase extends Base
  @action = (name, params, func)->
    @actions = {} unless @actions?
    if isFunction params
      func = params
      params = {}
    @actions[name] = {params}
    @::[name] = func if isFunction func

  #TODO: for pure js controllers
  #@extend = ->


