fs = require 'fs'
path = require 'path'
async = require 'async'
_ = require 'underscore'
_s = require 'underscore.string'


includeDirFiles = (dir, classify = yes)->
  console.log 'includeDirFiles', dir
  files = fs.readdirSync dir
  ret = {}
  for file in files
    [key] = file.split '.'
    key = _s.classify(key) if classify
    ret[key] = require(path.join(dir, file))
  ret


class EEngine

  async: async
  _: _
  _s: _s

  constructor: ->
    @config =
      projectDir: path.dirname process.mainModule.filename
      eeDir: 'ee'
      controllersDir: 'controllers'
    @classes = includeDirFiles(path.join(__dirname, 'classes'))
    @events = new @classes.Events
    @controllerManager = new @classes.ControllerManager


  log: (s...)-> console.log "LOG:", s...


  _loadDir: (basedir)=>
    (dir, cb)=>
      includeDirFiles path.join(basedir, dir), (err, files)=>
        _.extend @[dir], files
        cb no


  _initEngine: ->
    @log '_initEngine'
    @events.emit '_initEngine'

  execController: (c, m, p, cb)->
    @controllerManager.exec c, m, p, cb

  start: (config = {})->
    _.extend @config, config
    @events.once '_initEngine', =>
      controllers = includeDirFiles(path.join(@config.projectDir, @config.eeDir, @config.controllersDir), no)
      for cn, co of controllers
        @controllerManager.addController cn, co
      @log 'start', @config
      #async.eachSeries ['controllers'], @_loadDir(path.join(@config.projectDir, @config.eeDir)), =>
      @events.emit '_start'


  onStart: (cb)->
    @events.on '_start', cb

  getError: (text)-> new @classes.error text
  isError: (obj)-> obj instanceof @classes.error


#create engine class
module.exports = global.ee = global.eengine = ee = new EEngine
#and init
ee._initEngine()