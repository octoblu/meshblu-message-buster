DoThings = require './do-things.coffee'
debug    = require('debug')('meshblu-message-buster:index')

debug 'starting'
new DoThings().start()
