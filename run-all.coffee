DoThings = require './do-things.coffee'
debug    = require('debug')('meshblu-message-dangler:index')

MESHBLU_SERVER = process.env.MESHBLU_SERVER || 'meshblu.octoblu.com'
MESHBLU_PORT = process.env.MESHBLU_PORT || 443
console.log 'Initializing websocket...'
new DoThings(1, 'websocket', MESHBLU_SERVER, MESHBLU_PORT).start()

console.log 'Initializing http...'
new DoThings(1, 'http', MESHBLU_SERVER, MESHBLU_PORT).start()

console.log 'Initializing messages-http...'
new DoThings(1, 'messages-http', MESHBLU_SERVER, MESHBLU_PORT).start()

FLOW_MESHBLU_SERVER = process.env.FLOW_MESHBLU_SERVER || 'flow-meshblu.octoblu.com'
FLOW_MESHBLU_PORT = process.env.FLOW_MESHBLU_PORT || 443
console.log 'Initializing websocket for ...'
new DoThings(1, 'websocket', FLOW_MESHBLU_SERVER, FLOW_MESHBLU_PORT).start()

console.log 'Initializing http...'
new DoThings(1, 'http', FLOW_MESHBLU_SERVER, FLOW_MESHBLU_PORT).start()

console.log 'Initializing messages-http...'
new DoThings(1, 'messages-http', FLOW_MESHBLU_SERVER, FLOW_MESHBLU_PORT).start()
