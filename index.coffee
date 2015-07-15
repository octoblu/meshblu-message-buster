_             = require 'lodash'
debug         = require('debug')('meshblu-message-buster:index')
MeshbluConfig = require 'meshblu-config'
MessageBuster = require './message-buster'
Notify        = require './notify'

meshbluConfig = new MeshbluConfig {}

debug 'starting message buster'
messageBuster = new MessageBuster meshbluConfig.toJSON()
messageBuster.start()

notify = new Notify

setInterval =>
  pendingMessages = messageBuster.getPendingMessages()
  ohUhMessages = _.filter _.keys(pendingMessages), (id) =>
    FIVESECONDSAGO = _.now() - 5000;
    return pendingMessages[id] < FIVESECONDSAGO

  numberOfMessages = _.size(ohUhMessages)

  messageBuster.clearPendingMessages() if numberOfMessages > 100

  debug 'pending messages', numberOfMessages
  notify.cloudWatch numberOfMessages
, 5000

setInterval =>
  debug 'restart'
  messageBuster.restart()
, 30000
