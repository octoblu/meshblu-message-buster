MessageBuster = require './message-buster'
{exec}        = require 'child_process'
_             = require 'lodash'
debug         = require('debug')('meshblu-message-buster:index')

MeshbluConfig = require 'meshblu-config'
meshbluConfig = new MeshbluConfig {}

debug 'starting message buster'
messageBuster = new MessageBuster meshbluConfig.toJSON()
messageBuster.start()

setInterval =>
  pendingMessages = messageBuster.getPendingMessages()
  ohUhMessages = _.filter _.keys(pendingMessages), (id) =>
    FIVESECONDSAGO = _.now() - 5000;
    return pendingMessages[id] < FIVESECONDSAGO

  numberOfMessages = _.size(ohUhMessages)

  messageBuster.clearPendingMessages() if numberOfMessages > 100

  debug 'notifying cloudwatch', numberOfMessages

  child = exec "./notifyCloudWatch.sh #{numberOfMessages}", (error, stdout, stderr) =>
    debug 'notify stdout', stdout
    debug 'notify stderr', stderr
    debug 'notify exec error: ', error if error?
, 5000
