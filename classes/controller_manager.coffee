Base = require './base'
Controller = require './controller'

module.exports = class ControllerManager extends Base

  constructor: ->
    @controllers = {}


  exec: (controllerName, methodName, params, cb)->
    if @controllers[controllerName]
      cObj = new @controllers[controllerName]
      cObj.exec methodName, params, cb


  addController: (name, methods)->
    class NewController extends Controller
    for methodName, methodFunction of methods
      NewController.prototype[methodName] = methodFunction
    @controllers[name] = NewController



