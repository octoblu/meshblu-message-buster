meshblu     = require 'meshblu'
_           = require 'lodash'
debug       = require('debug')('meshblu-message-buster:message-buster')

class MessageBuster
  constructor: (@meshbluJSON={}) ->
    @pendingMessages = {}
    @iter = 0

  start: =>
    @createConnection =>
      @startBuser()

  startBuser: =>
    @conn.subscribe uuid: @meshbluJSON.uuid
    @conn.on 'message', (message) =>
      debug 'received message', message
      delete @pendingMessages[message.id]

    setInterval =>
      @conn.message
        devices: [@meshbluJSON.uuid]
        topic: 'hello-my-friend'
        id: @iter
      @pendingMessages[@iter] = _.now();
      debug 'sent message', id: @iter
      @iter++
    , 2500

  createConnection: (callback=->)=>
    @conn = meshblu.createConnection @meshbluJSON
    @conn.once 'ready', (config) =>
      debug 'onReady', config
      callback()

    @conn.on 'notReady', (error) =>
      debug 'notReady', error

  getPendingMessages: => @pendingMessages
  clearPendingMessages: => @pendingMessages = {}

module.exports = MessageBuster
