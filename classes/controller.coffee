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
    ee._.isFunction @methods[m]


  exec: (m)->
    ret = @methods[m].call @, @
    @ok ret unless @cbCalled

