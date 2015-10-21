_             = require 'lodash'
debug         = require('debug')('meshblu-message-dangler:do-things')
MeshbluConfig = require 'meshblu-config'
MessageDangler = require './message-dangler'

class DoThings
  constructor: (number=1, sendMessageType='websocket', meshbluServer='meshblu.octoblu.com', meshbluPort=443) ->
    meshbluConfig = new MeshbluConfig {}

    meshbluJSON = _.cloneDeep meshbluConfig.toJSON()
    meshbluJSON.server = meshbluServer
    meshbluJSON.port = meshbluPort
    @danglerID = "[#{sendMessageType}:#{number}](#{meshbluServer})"
    @messageDangler = new MessageDangler number, meshbluJSON, sendMessageType
    @messageDangler.start()

  start: =>
    console.log "Starting...#{@danglerID}"
    setInterval =>
      pendingMessages = @messageDangler.getPendingMessages()
      totalPending = _.size(pendingMessages)
      ohUhMessages = _.filter _.keys(pendingMessages), (id) =>
        FIVESECONDSAGO = _.now() - 5000;
        return pendingMessages[id] < FIVESECONDSAGO

      numberOfMessages = _.size(ohUhMessages)

      @messageDangler.clearPendingMessages() if numberOfMessages > 100

      console.log "Everything is all good #{@danglerID}: ", numberOfMessages if numberOfMessages == 0
      console.log "Pending messages #{@danglerID}: ", numberOfMessages if numberOfMessages > 0
      console.log "OH NO! TOO MANY PENDING MESSAGES!!! #{@danglerID}" if numberOfMessages > 10
    , 5000

    setInterval =>
      console.log "Restarting #{@danglerID}..."
      @messageDangler.restart()
    , 120 * 60 * 1000

module.exports = DoThings
