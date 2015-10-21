DoThings = require './do-things.coffee'
debug    = require('debug')('meshblu-message-dangler:index')

console.log 'Initializing websocket...'
new DoThings(1, 'websocket').start()

console.log 'Initializing http...'
new DoThings(1, 'http').start()

console.log 'Initializing messages-http...'
new DoThings(1, 'messages-http').start()
