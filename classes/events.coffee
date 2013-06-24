$ = require 'jquery-deferred'

Base = require './base'
module.exports = class Events extends Base
  constructor: ->
    @events = {}

  _initCb: (event)-> @events[event] or= $.Callbacks('memory')

  on: (event, listener)-> @_initCb(event).add listener

  #TODO: make right once method
  once: (event, listener)-> @on(event, listener)

  emit: (event, args...)-> @_initCb(event).fire args...
