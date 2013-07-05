Base = require './base'


module.exports = class Controller extends Base
  actions: {actions:{}}
  cbCalled: no


  constructor: (@params, @cb)->

  log: (text...)-> super 'Controller', text...

  callCb: (params...)->
    @log 'callCb', params
    @cbCalled = yes
    @cb? params...


  error: (text)->
    @callCb "action error: #{text}"


  ok: (args...)->
    @callCb no, args...


  actionExists: (a)-> @actions.actions[a]?


  exec: (a)->
    obj = new @actions
    obj[a] @

