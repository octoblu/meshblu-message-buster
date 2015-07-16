debug       = require('debug')('meshblu-message-buster:meshblu')
meshblu     = require 'meshblu'
MeshbluSocketIO = require 'meshblu-socket.io'
MeshbluWebsocket = require 'meshblu-websocket'

class Meshblu
  constructor: (@config) ->

  startPlainMeshblu: (callback=->) =>
    debug 'using meshblu'
    @config.options = transports: ['websocket'];
    @conn = meshblu.createConnection @config
    @conn.on 'ready', (config) =>
      @config.uuid = config.uuid
      @config.token = config.token
      debug 'ready'
      callback()
    @conn.on 'notReady', (error) =>
      debug 'notReady', error

  startSocketIoMeshblu: (callback=->) =>
    debug 'using socket io'
    @conn = new MeshbluSocketIO @config
    @conn.connect =>
      debug 'ready'
      callback()
    @conn.on 'notReady', (error) =>
      debug 'notReady', error

  startWebsocketMeshblu: (callback=->) =>
    @conn = new MeshbluWebsocket @config

    @conn.on 'close', @onClose
    @conn.on 'error', @onError
    @conn.connect (error) =>
      if error?
        debug JSON.stringify error
      debug 'ready'
      callback()

  onMessage: (callback=->)=>
    @conn.on 'message', (message) =>
      callback message

  sendMessage: (message) =>
    @conn.message message

  subscribe: =>
    debug 'subscribe to ', @config.uuid
    @conn.subscribe uuid: @config.uuid

  onClose: =>
    debug 'onClose', JSON.stringify arguments

  onError: (error) =>
    debug 'onError', error.message

module.exports = Meshblu
