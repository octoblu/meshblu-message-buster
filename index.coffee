DoThings = require './do-things.coffee'
debug    = require('debug')('meshblu-message-dangler:index')

console.log 'starting...'
new DoThings().start()
