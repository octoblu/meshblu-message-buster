_        = require 'lodash'
DoThings = require './do-things.coffee'
debug    = require('debug')('meshblu-message-buster:mass')

last = 0
_.times 100, (number) =>
  last += 40
  doThing = (currentLast) =>
    new DoThings(number).start()
  _.delay doThing, last
