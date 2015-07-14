meshblu     = require 'meshblu'
meshbluJSON = require './meshblu.json'
debug       = require('debug')('meshblu-message-buster')

conn = meshblu.createConnection meshbluJSON

i = 0
conn.once 'ready', (config) =>
  debug 'onReady', config
  conn.subscribe uuid: meshbluJSON.uuid
  conn.on 'message', (message) =>
    debug 'received message', message

  setInterval =>
    conn.message
      devices: [meshbluJSON.uuid]
      topic: 'hello-my-friend'
      id: i
    debug 'sent message', id: i
    i++
  , 1000

conn.on 'notReady', (error) =>
  debug 'notReady', error
