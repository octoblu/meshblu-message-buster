MessageBuster = require './message-buster'
meshbluJSON   = require './meshblu.json'
{exec}        = require 'child_process'
_             = require 'lodash'
debug         = require('debug')('meshblu-message-buster:index')

meshbluJSON.options = transports: ['websocket']

debug 'starting message buster'
messageBuster = new MessageBuster meshbluJSON
messageBuster.start()

setInterval =>
  pendingMessages = messageBuster.getPendingMessages()

  ohUhMessages = _.filter _.keys(pendingMessages), (id) =>
    FIVESECONDSAGO = _.now() - 5000;
    return pendingMessages[id] < FIVESECONDSAGO

  numberOfMessages = _.size(ohUhMessages)
  return debug 'no pending messages' unless numberOfMessages

  debug 'notifying cloudwatch', numberOfMessages
  child = exec "./notifyCloudWatch.sh #{numberOfMessages}", (error, stdout, stderr) =>
    debug 'notify stdout', stdout
    debug 'notify stderr', stderr
    debug 'notify exec error: ', error if error?
    messageBuster.clearPendingMessages()
, 3000
