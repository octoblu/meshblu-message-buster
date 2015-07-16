_           = require 'lodash'
debug       = require('debug')('meshblu-message-buster:message-buster')
Meshblu     = require './meshblu.coffee'

class MessageBuster
  constructor: (@number, @meshbluJSON={}) ->
    @pendingMessages = {}
    @iter = 0

  start: =>
    @createConnection =>
      @startBuser()

  startBuser: =>
    @meshblu.subscribe()
    @meshblu.onMessage (message) =>
      debug "received message for #{@number}: ", message.id, @pendingMessages[message.id]?
      delete @pendingMessages[message.id]

    @sendMessage()
    @interval = setInterval @sendMessage, 1000

  sendMessage: =>
    @meshblu.sendMessage
      devices: [@meshbluJSON.uuid]
      topic: 'hello-my-friend'
      id: @iter
      number: @number
    @pendingMessages[@iter] = _.now();
    debug "sent message for #{@number}: ", id: @iter
    @iter++

  createConnection: (callback=->)=>
    @meshblu = new Meshblu @meshbluJSON
    @meshblu.startPlainMeshblu =>
      debug 'connected'
      callback()

  restart: =>
    debug 'restart'
    clearInterval @interval
    @meshblu.conn.close()
    @pendingMessages = {}
    @start()

  getPendingMessages: => @pendingMessages
  clearPendingMessages: => @pendingMessages = {}

module.exports = MessageBuster
