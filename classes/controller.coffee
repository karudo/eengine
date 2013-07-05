Base = require './base'

engine = require '../engine'

module.exports = class Controller extends Base
  actions: {}
  cbCalled: no


  constructor: (@params, @cb)->


  callCb: (params...)->
    @cbCalled = yes
    @cb? params...


  error: (text)->
    @callCb "action error: #{text}"


  ok: (v...)->
    @callCb no, v...


  actionExists: do->
    isFunction = engine.i._.isFunction
    atActions = @actions
    (m)-> isFunction atActions[m]


  exec: (m)->
    @actions[m] @

