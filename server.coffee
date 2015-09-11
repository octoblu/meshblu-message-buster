debug           = require('debug')('meshblu-message-buster:server')
express         = require 'express'
bodyParser      = require 'body-parser'
morgan          = require 'morgan'
errorhandler    = require 'errorhandler'
healthcheck     = require 'express-meshblu-healthcheck'
DoThings        = require './do-things.coffee'

app = express()
app.use bodyParser.json()
app.use morgan 'dev'
app.use errorhandler()
app.use healthcheck()


app.get '/', (response) => response.status(200).send { online : true }

server = app.listen (process.env.PORT || 80), ->
  host = server.address().address
  port = server.address().port

  console.log "Alexa Service started http://#{host}:#{port}"

  debug 'starting'
  new DoThings().start()
