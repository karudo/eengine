{EventEmitter} = require('events')
fs = require 'fs'
path = require 'path'
async = require 'async'
_ = require 'underscore'
_s = require 'underscore.string'


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
    @events = new EventEmitter
    @classes = {}
    @controllers = {}


  log: (s...)-> console.log "LOG:", s...


  _loadDir: (dir, cb)=>
    includeDirFiles path.join(__dirname, dir), (err, files)=>
      _.extend @[dir], files
      cb no


  _initEngine: ->
    @log '_initEngine'
    async.eachSeries ['classes', 'controllers'], @_loadDir, =>
      @events.emit '_initEngine'


  start: (config)->
    @events.once '_initEngine', =>
      @log 'start', config
      @events.emit '_start'


  onStart: (cb)->
    @events.on '_start', cb


#create engine class
module.exports = global.ee = global.eengine = ee = new EEngine
#and init
ee._initEngine()