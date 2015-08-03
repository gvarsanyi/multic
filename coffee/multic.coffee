
MulticProcess = require './multic-process'


READ    = 1
COMPILE = 2
MINIFY  = 4
WRITE   = 8

source_to_target_types =
  coffee: ['js']
  css:    ['min']
  es6:    ['js']
  html:   ['js', 'min']
  jade:   ['html', 'js']
  js:     ['min']
  less:   ['css']
  sass:   ['css']


module.exports = (src, options) ->

  inf = new MulticProcess src, options

  iface = {file: {}}

  fn = inf.start

  for source_type, target_types of source_to_target_types
    for target_type in target_types
      do (source_type, target_type) ->

        iface[source_type] ?= (cb) ->
          # multic(src).js()
          fn 0, source_type, source_type, cb

        iface.file[source_type] ?= (cb) ->
          # multic(path).file.js()
          fn READ, source_type, source_type, cb

        if target_type is 'min'

          iface[source_type].min = (cb) ->
            # multic(src).js.min()
            fn MINIFY, source_type, source_type, cb

          iface[source_type].min.write = (target, cb) ->
            # multic(src).js.min.write(target)
            fn MINIFY|WRITE, source_type, source_type, cb, target

          iface.file[source_type].min = (cb) ->
            # multic(src).file.js.min()
            fn READ|MINIFY, source_type, source_type, cb

          iface.file[source_type].min.write = (target, cb) ->
            # multic(src).file.js.min.write(target)
            fn READ|MINIFY|WRITE, source_type, source_type, cb, target

        else

          iface[source_type][target_type] = (cb) ->
            # multic(src).coffee.js()
            fn COMPILE, source_type, target_type, cb

          iface[source_type][target_type].write = (target, cb) ->
            # multic(src).coffee.js.write(target)
            fn COMPILE|WRITE, source_type, target_type, cb, target

          iface[source_type][target_type].min = (cb) ->
            # multic(src).coffee.js.min()
            fn COMPILE|MINIFY, source_type, target_type, cb

          iface[source_type][target_type].min.write = (target, cb) ->
            # multic(src).coffee.js.min.write(target)
            fn COMPILE|MINIFY|WRITE, source_type, target_type, cb, target

          iface.file[source_type][target_type] = (cb) ->
            # multic(src).file.coffee.js()
            fn READ|COMPILE, source_type, target_type, cb

          iface.file[source_type][target_type].write = (target, cb) ->
            # multic(src).file.coffee.js.write(target)
            fn READ|COMPILE|WRITE, source_type, target_type, cb, target

          iface.file[source_type][target_type].min = (cb) ->
            # multic(src).file.coffee.js.min()
            fn READ|COMPILE|MINIFY, source_type, target_type, cb

          iface.file[source_type][target_type].min.write = (target, cb) ->
            # multic(src).file.coffee.js.min.write(target)
            fn READ|COMPILE|MINIFY|WRITE, source_type, target_type, cb, target

  iface
