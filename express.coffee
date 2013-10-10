path = require 'path'
http = require 'http'

express = require 'express'
hbs = require 'express-hbs'

Base = require './classes/base'

module.exports = class Express extends Base
  constructor: ->
    super
    @app = express()
    @httpServer = http.createServer @app
    @scripts = []
    @styles = []
    @configure()


  configure: ->

    @app.configure =>
      #app.set 'port', 3000
      @app.use express.bodyParser()
      @app.use express.methodOverride()
      @app.use @app.router

      @app.engine 'hbs', hbs.express3({})
      @app.set 'view engine', 'hbs'
      @app.set 'views', __dirname + '/views'

      return

    @app.configure 'development', =>
      @app.use express.errorHandler { dumpExceptions: yes, showStack: yes }
      return

    @app.configure 'production', =>
      @app.use express.errorHandler()
      return


  addAction: (path, cb)->
    @app.post path, (req, res)->
      params = JSON.parse req.body.params
      cb params, (error, responce)->
        if error
          res.json 500, {error}
        else
          res.json responce


  setStaticDir: (dir)->
    @app.get '/', (req, res)=> res.render 'index', {@scripts}
    @app.use '/static', express.static dir


  addScript: (script, unshift = no)->
    if script.substring(0, 1) is '/'
      fullPath = script
    else
      fullPath = path.join '/static', script
    if unshift
      @scripts.unshift fullPath
    else
      @scripts.push fullPath
    fullPath


  addScripts: (scripts)->
    scripts = [scripts] unless Array.isArray scripts
    @addScript s for s in scripts


  start: ->
    @httpServer.listen(3000)
