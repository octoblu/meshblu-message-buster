_             = require 'lodash'
debug         = require('debug')('meshblu-message-dangler:do-things')
MeshbluConfig = require 'meshblu-config'
MessageBuster = require './message-dangler'

class DoThings
  constructor: (@number=1, @sendMessageType='websocket') ->
    meshbluConfig = new MeshbluConfig {}

    @messageBuster = new MessageBuster @number, meshbluConfig.toJSON(), @sendMessageType
    @messageBuster.start()

  start: =>
    console.log "Starting...[#{@sendMessageType}:#{@number}]"
    setInterval =>
      pendingMessages = @messageBuster.getPendingMessages()
      totalPending = _.size(pendingMessages)
      ohUhMessages = _.filter _.keys(pendingMessages), (id) =>
        FIVESECONDSAGO = _.now() - 5000;
        return pendingMessages[id] < FIVESECONDSAGO

      numberOfMessages = _.size(ohUhMessages)

      @messageBuster.clearPendingMessages() if numberOfMessages > 100

      console.log "Everything is all good [#{@sendMessageType}:#{@number}]: ", numberOfMessages if numberOfMessages == 0
      console.log "Pending messages [#{@sendMessageType}:#{@number}]: ", numberOfMessages if numberOfMessages > 0
      console.log "OH NO! TOO MANY PENDING MESSAGES!!! [#{@sendMessageType}:#{@number}]" if numberOfMessages > 10
    , 5000

    setInterval =>
      console.log "Restarting [#{@sendMessageType}:#{@number}]..."
      @messageBuster.restart()
    , 120 * 60 * 1000

module.exports = DoThings
