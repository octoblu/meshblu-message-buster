DoThings = require './do-things.coffee'
debug    = require('debug')('meshblu-message-buster:index')

console.log 'starting...'
new DoThings().start()
