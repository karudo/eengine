fs = require 'fs'
path = require 'path'
#async = require 'async'
_ = require 'underscore'
_s = require 'underscore.string'
$ = require 'jquery-deferred'


includeDirFiles = (dir, cb)->
  ee.log 'includeDirFiles', dir
  fs.readdir dir, (err, files)->
    ret = {}
    for file in files
      [key] = file.split '.'
      ret[_s.classify(key)] = require(path.join(dir, file))
    cb no, ret

class EEngine
  constructor: ->
    @_initEngineDef = $.Deferred()
    @_startDef = $.Deferred()

    @classes = {}
    @controllers = {}

  log: (s...)-> console.log "LOG:", s...

  _initEngine: ->
    @log '_initEngine'
    includeDirFiles path.join(__dirname, 'classes'), (err, files)=>
      _.extend @classes, files
      @_initEngineDef.resolve()

  start: (config)->
    @_initEngineDef.done =>
      @log 'start', config
      @_startDef.resolve()


  onStart: (cb)->
    @_startDef.done cb



module.exports = global.ee = global.eengine = ee = new EEngine

ee._initEngine()