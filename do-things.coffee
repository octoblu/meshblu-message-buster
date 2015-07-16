_             = require 'lodash'
debug         = require('debug')('meshblu-message-buster:do-things')
MeshbluConfig = require 'meshblu-config'
MessageBuster = require './message-buster'
Notify        = require './notify'

class DoThings
  constructor: (@number) ->
    meshbluConfig = new MeshbluConfig {}

    @messageBuster = new MessageBuster @number, meshbluConfig.toJSON()
    @messageBuster.start()

    @notify = new Notify

  start: =>
    debug 'starting message buster', @number
    setInterval =>
      pendingMessages = @messageBuster.getPendingMessages()
      ohUhMessages = _.filter _.keys(pendingMessages), (id) =>
        ONESECONDSAGO = _.now() - 1000;
        return pendingMessages[id] < ONESECONDSAGO

      numberOfMessages = _.size(ohUhMessages)

      @messageBuster.clearPendingMessages() if numberOfMessages > 100

      max = _.max _.keys(ohUhMessages)
      min = _.min _.keys(ohUhMessages)
      debug "pending messages for #{@number}: ", min, '-', max if numberOfMessages > 0
      # @notify.cloudWatch numberOfMessages
    , 1000

    setInterval =>
      debug 'restart'
      @messageBuster.restart()
    , 120 * 60 * 1000

module.exports = DoThings
