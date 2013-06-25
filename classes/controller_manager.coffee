Base = require './base'
Controller = require './controller'



module.exports = class ControllerManager extends Base

  constructor: ->
    @controllers = {}


  log: (text)-> super 'ControllerManager', text


  callCbError: (cb, error)->
    cb? error
    @log error


  exec: (controllerName, methodName, params, cb)->
    if @controllers[controllerName]
      cObj = new @controllers[controllerName] params, cb
      if cObj.methodExists methodName
        cObj.exec methodName
      else
        @callCbError cb, "no method #{methodName} in controller #{controllerName}"
    else
      @callCbError cb, "no controller #{controllerName}"


  addController: (name, methods)->
    class NewController extends Controller
      methods: methods
    @controllers[name] = NewController



