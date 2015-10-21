_        = require 'lodash'
DoThings = require './do-things.coffee'
debug    = require('debug')('meshblu-message-buster:mass')

last = 0
_.times 100, (number) =>
  last += 10
  doThing = (currentLast) =>
    console.log 'Initializing websocket...'
    new DoThings(number, 'websocket').start()

    console.log 'Initializing http...'
    new DoThings(number, 'http').start()

    console.log 'Initializing messages-http...'
    new DoThings(number, 'messages-http').start()

  _.delay doThing, last
