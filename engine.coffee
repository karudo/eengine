ee = null

fs = require 'fs'
path = require 'path'
async = require 'async'
_ = require 'underscore'
_s = require 'underscore.string'


includeDirClasses = (dir, classify = yes)->
  console.log 'includeDirClasses', dir
  files = fs.readdirSync dir
  ret = {}
  for file in files
    [key] = file.split '.'
    key = _s.classify(key) if classify
    ret[key] = require(path.join(dir, file))
  ret

extendNS = (dotNS, mainNS, name, o)->
  obj = {}
  if _.isString name
    obj[name] = o
  else
    _.extend obj, name

  for key of obj
    if key.indexOf('.') > -1
      dotNS[key] = obj[key]
    else
      mainNS[key] = obj[key]

  return


class EEngine

  constructor: ->
    @_c = {}
    @_m = {}
    @_i = {}
    @_u = {includeDirClasses}
    @addInstance {async, _, _s}
    @config =
      projectDir: path.dirname process.mainModule?.filename
      appSubDir: 'app'
      globalVars: ['ee', 'eengine']


  #classes namespace
  c: (clName)=> @_c[clName] or @c[clName]
  addClass: (name, cl)-> extendNS @_c, @c, name, cl


  #models namespace
  m: (mName)=> @_c[mName] or @c[mName]
  addModel: (name, mod)-> extendNS @_m, @m, name, mod


  #instances namespace
  i: (iName)=> @_i[iName] or @i[iName]
  addInstance: (name, cl)-> extendNS @_i, @i, name, cl


  #utils and helpers
  u: (uName)=> @_u[uName] or @u[uName]
  addUtil: (name, cl)-> extendNS @_u, @u, name, cl


  execAction: (controller, action, params, cb)->
    @i.controllerManager.exec controller, action, params, cb

  log: (s...)-> console.log "LOG:", s...


  _setDefaults: ->
    unless @config.controllersDir
      @config.controllersDir = path.join @config.projectDir, @config.appSubDir, 'controllers'
    unless @config.clientDir
      @config.clientDir = path.join @config.projectDir, @config.appSubDir, 'client'
    unless @config.configDir
      @config.configDir = path.join @config.projectDir, 'config'


  _initExpress: ->
    e = require('./express')
    @i.express = new e
    @i.express.setStaticDir @config.clientDir
    @i.express.addScripts @config.client.scripts


  _initSIO: ->
    s = require './websocket'
    @i.websocket = new s @i.express


  _initEngine: ->
    @log '_initEngine'
    @addClass includeDirClasses(path.join(__dirname, 'classes'))
    @events = new @c.Events
    @addInstance 'controllerManager', new @c.ControllerManager
    global[varName] = ee for varName in @config.globalVars

    @events.emit '_initEngine'


  start: (config = {})->
    _.extend @config, config

    @_initEngine()

    @events.once '_initEngine', =>
      @_setDefaults()
      _.extend @config, require(@config.configDir)
      for cn, co of includeDirClasses @config.controllersDir, no
        @i.controllerManager.addController cn, co
      @log 'start', @config

      @_initExpress()
      @_initSIO()

      @i.express.start()
      @events.emit '_start'


  onStart: (cb)->
    @events.on '_start', cb

  getError: (text)-> new @c.error text
  isError: (obj)-> obj instanceof @c.error


#create engine class
module.exports = ee = new EEngine
