Base = require './base'

module.exports = class Controller extends Base
  methods: {}
  cbCalled: no


  constructor: (@params, @cb)->


  callCb: (params...)->
    @cbCalled = yes
    @cb? params...


  error: (text)->
    @callCb "method error: #{text}"


  ok: (v...)->
    @callCb no, v...


  methodExists: (m)->
    @_h.i._.isFunction @methods[m]


  exec: (m)->
    @methods[m].call @, @

