
MulticProcess = require './multic-process'
# cluster       = require 'cluster'
fs            = require 'fs'

# async prefetch modules
do ->
  all_processors =
    linter:   ['coffee', 'css', 'es6', 'html', 'jade', 'js', 'sass']
    compiler: ['coffee-js', 'es6-js', 'html-js', 'jade-html', 'jade-js',
              'sass-css']
    minifier: ['css', 'html', 'js']

  list = []
  for processor_type, processors of all_processors
    for processor in processors
      list.push './' + processor_type + '/' + processor

  other_loaded = false
  t0 = (new Date).getTime()

  fs.readdir __dirname + '/linter/map', (err, nodes) ->
    for node in nodes or []
      list.push './linter/map/' + node
    if other_loaded
      fetch()
    other_loaded = true

  fs.readdir __dirname + '/linter/rule', (err, nodes) ->
    for node in nodes or []
      list.push './linter/rule/' + node
    if other_loaded
      fetch()
    other_loaded = true

  fetch = ->
    if mod = list.pop()
      require mod
      setTimeout fetch, 10
#     else
#       console.log '[worker #' + cluster.worker.id + '] all required in',
#                   (new Date).getTime() - t0


process.on 'message', (msg) ->
#   console.log '[worker #' + cluster.worker.id + ']', msg

  cb = (err, res) ->
#     console.log '[worker #' + cluster.worker.id + '] processed'
    process.send {req: 'processed', reqId: msg.reqId, err, res}

  processor = new MulticProcess msg.source, msg.options
  processor._worker = true
  processor.start msg.todo, msg.sourceType, msg.targetType, cb, msg.target


process.send {req: 'ready'}
