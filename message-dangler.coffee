_             = require 'lodash'
debug         = require('debug')('meshblu-message-dangler:message-dangler')
Meshblu       = require './meshblu.coffee'
MeshbluHttp   = require 'meshblu-http'

class MessageDangler
  constructor: (@number, @meshbluJSON={}, @sendMessageType) ->
    @SEND_MESSAGES =
      "websocket": @sendMessageOverWebsocket
      "http": @sendMessageOverHttp
      "messages-http": @sendMessageOverMessagesHttp

    unless @SEND_MESSAGES[@sendMessageType]?
      console.error "Invalid send message type. Defaulting..."
      @sendMessageType = "websocket"

    debug "Using #{@sendMessageType} for sending messages"

    @pendingMessages = {}
    @iter = 0

  start: =>
    @createConnection =>
      @startBuser()

  startBuser: =>
    @meshblu.subscribe()
    @meshblu.onMessage (message) =>
      debug "received message for #{@number}: ", id: message.id
      delete @pendingMessages[message.id]
    @sendMessage()
    @interval = setInterval @sendMessage, 2000

  sendMessage: =>
    message =
      devices: [@meshbluJSON.uuid]
      topic: 'hello-my-friend'
      id: @iter
      number: @number

    @SEND_MESSAGES[@sendMessageType] message
    @pendingMessages[@iter] = _.now();
    debug "sent message for #{@number}: ", id: @iter
    @iter++

  sendMessageOverWebsocket: (message) =>
    @meshblu.sendMessage message

  sendMessageOverHttp: (message) =>
    meshbluHttp = new MeshbluHttp @meshbluJSON
    meshbluHttp.message message

  sendMessageOverMessagesHttp: (message) =>
    newMeshbluJSON = _.cloneDeep @meshbluJSON
    newMeshbluJSON.server = process.env.MESHBLU_MESSAGES_SERVER || 'meshblu-messages.octoblu.com'
    newMeshbluJSON.port = process.env.MESHBLU_MESSAGES_PORT || 443
    meshbluHttp = new MeshbluHttp newMeshbluJSON
    meshbluHttp.message message

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

module.exports = MessageDangler
