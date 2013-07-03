Base = require './base'
Controller = require './controller'



module.exports = class ControllerManager extends Base

  constructor: ->
    @controllers = {}


  log: (text)-> super 'ControllerManager', text


  callCbError: (cb, error)->
    cb? error
    @log error


  exec: (controllerName, actionName, params, cb)->
    if @controllers[controllerName]
      cObj = new @controllers[controllerName] params, cb
      if cObj.actionExists actionName
        cObj.exec actionName
      else
        @callCbError cb, "no action #{actionName} in controller #{controllerName}"
    else
      @callCbError cb, "no controller #{controllerName}"


  addController: (name, actions)->
    class NewController extends Controller
      actions: actions
    @controllers[name] = NewController



