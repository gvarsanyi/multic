
MulticProcess = require './multic-process'


READ    = 1
COMPILE = 2
MINIFY  = 4

source_to_target_types =
  coffee: ['js']
  css:    ['min']
  es6:    ['js']
  html:   ['js', 'min']
  jade:   ['html', 'js']
  js:     ['min']
  sass:   ['css']


module.exports = (src, options) ->

  inf = new MulticProcess src, options

  iface = {file: {}}

  for source_type, target_types of source_to_target_types
    for target_type in target_types
      do (source_type, target_type) ->

        iface[source_type] ?= (cb) ->
          # multic(src).js (err, req) ->
          inf.process 0, source_type, source_type, cb

        iface.file[source_type] ?= (cb) ->
          # multic(path).file.js (err, req) ->
          inf.process READ, source_type, source_type, cb

        sfn = (iface[source_type] ?= {})[target_type] = (cb) ->
          if target_type is 'min'
            # multic(src).js.min (err, req) ->
            return inf.process MINIFY, source_type, source_type, cb

          # multic(src).coffee.js (err, req) ->
          inf.process COMPILE, source_type, target_type, cb

        unless target_type is 'min'
          sfn.min = (cb) ->
            # multic(src).coffee.js.min (err, req) ->
            inf.process COMPILE|MINIFY source_type, target_type, cb

        ffn = (iface.file[source_type] ?= {})[target_type] = (cb) ->
          if target_type is 'min'
            # multic(src).file.js.min (err, req) ->
            return inf.process READ|MINIFY source_type, source_type, cb

          # multic(src).file.coffee.js (err, req) ->
          inf.process READ|COMPILE, source_type, target_type, cb

        unless target_type is 'min'
          # multic(src).file.coffee.js.min (err, req) ->
          ffn.min = (cb) ->
            inf.process READ|COMPILE|MINIFY, source_type, target_type, cb

  iface
