MessageBuster = require './message-buster'
Notify        = require './notify'
_             = require 'lodash'
debug         = require('debug')('meshblu-message-buster:index')

MeshbluConfig = require 'meshblu-config'
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
  notify.statusPageIo numberOfMessages
, 5000
