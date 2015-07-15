{exec}        = require 'child_process'
debug         = require('debug')('meshblu-message-buster:notify')
StatusPageAPI = require 'statuspage-api'

class Notify
  constructor: ->
    @statuspage = new StatusPageAPI
      pageid: process.env.STATUS_PAGE_ID
      apikey: process.env.STATUS_PAGE_KEY

  cloudWatch: (count) =>
    debug 'notifying cloudwatch'

    child = exec "./notifyCloudWatch.sh #{count}", (error, stdout, stderr) =>
      debug 'notify stdout', stdout
      debug 'notify stderr', stderr
      debug 'notify exec error: ', error if error?

  statusPageIo: (count) =>
    return unless count
    debug 'notifying status page io'

    args =
      "incident[name]": "Flow Meshblu communication interuptions",
      "incident[status]": "identified",
      "incident[impact_override]": "major",
      "incident[message]": "We've identified an issue with flows that is causing subscription and message routing issues. This will may prevent flows from responding to triggers and starting up.",
      "incident[component_ids][]": "nkb2l0jm15ps"

    @statuspage.post "incidents", args, @statusPageIoResponse

  statusPageIoResponse: (result) =>
    debug "Status: ", result.status
    debug "Error: ", result.error if error?
    debug "Data: ", result.data if result.status == "success"

module.exports = Notify
