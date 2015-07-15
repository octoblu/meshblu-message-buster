{exec}        = require 'child_process'
debug         = require('debug')('meshblu-message-buster:notify')

class Notify
  cloudWatch: (count) =>
    debug 'notifying cloudwatch'

    child = exec "./notifyCloudWatch.sh #{count}", (error, stdout, stderr) =>
      debug 'notify stdout', stdout
      debug 'notify stderr', stderr
      debug 'notify exec error: ', error if error?

module.exports = Notify
