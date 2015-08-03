
MulticProcess = require './multic-process'
fs            = require 'fs'

# async prefetch modules
do ->
  all_processors =
    linter:   ['coffee', 'css', 'es6', 'html', 'jade', 'js', 'less', 'sass']
    compiler: ['coffee-js', 'es6-js', 'html-js', 'jade-html', 'jade-js',
               'less-css', 'sass-css']
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
