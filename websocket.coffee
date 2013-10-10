Base = require './classes/base'

socket_io = require 'socket.io'

module.exports = class WS extends Base
  constructor: (@express)->
    @express.addScript('/socket.io/socket.io.js', yes)
    socket_io.listen(@express.httpServer)
