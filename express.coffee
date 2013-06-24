express = require 'express'

Base = require './classes/base'

module.exports = class Express extends Base
  constructor: ->
    super
    @app = express()
    @configure()

  configure: ->

    app = @app

    app.configure ->
      app.set 'port', 3000
      app.use express.bodyParser()
      app.use express.methodOverride()
      app.use app.router

      #publicDir = "#{__dirname}/public"
      #assetsDir = "#{__dirname}/assets"

      #app.use require('connect-assets') { src: assetsDir }
      #app.use express.static(publicDir)
      return


    app.configure 'development', ->
      app.use express.errorHandler { dumpExceptions: yes, showStack: yes }
      return


    app.configure 'production', ->
      app.use express.errorHandler()
      return