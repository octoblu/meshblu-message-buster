_             = require 'lodash'
debug         = require('debug')('meshblu-message-buster:do-things')
MeshbluConfig = require 'meshblu-config'
MessageBuster = require './message-buster'
Notify        = require './notify'

class DoThings
  constructor: (@number=1) ->
    meshbluConfig = new MeshbluConfig {}

    @messageBuster = new MessageBuster @number, meshbluConfig.toJSON()
    @messageBuster.start()

    @notify = new Notify

  start: =>
    debug 'starting message buster', @number
    setInterval =>
      pendingMessages = @messageBuster.getPendingMessages()
      totalPending = _.size(pendingMessages)
      ohUhMessages = _.filter _.keys(pendingMessages), (id) =>
        ONESECONDSAGO = _.now() - 5000;
        return pendingMessages[id] < ONESECONDSAGO

      numberOfMessages = _.size(ohUhMessages)

      @messageBuster.clearPendingMessages() if numberOfMessages > 100

      debug "pending messages for #{@number}: ", numberOfMessages if numberOfMessages > 0
      # @notify.cloudWatch numberOfMessages
    , 5000

    setInterval =>
      debug 'restart'
      @messageBuster.restart()
    , 120 * 60 * 1000

module.exports = DoThings
