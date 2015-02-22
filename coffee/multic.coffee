
sources =
  coffee: ['js']
  css:    ['min']
  es6:    ['js']
  html:   ['js', 'min']
  jade:   ['html', 'js']
  js:     ['min']
  sass:   ['css']


opts_factory = (source, orig, cb) ->
  if typeof orig is 'function' and not cb?
    [cb, orig] = [orig]

  unless typeof cb is 'function'
    throw new Error 'Argument `callback` is a required function'

  if orig? and typeof orig isnt 'object'
    throw new Error 'Argument `options` must be object type'

  opts = {}
  if orig
    for k, v of orig
      opts[k] = v

  opts.source ?= source
  opts.res ?=
    errors:   []
    includes: []
    warnings: []

  [opts, cb]


for source, targets of sources
  do (source, targets) ->
    module.exports[source] = (compilable) ->
      unless typeof compilable is 'string'
        compilable = ''

      iface = {}

      for target in targets
        do (target) ->
          compile = (opts, cb) ->
            [opts, cb] = opts_factory compilable, opts, cb
            if target is 'min'
              require('./minifier/' + source) opts, ->
                unless typeof opts.res.minified is 'string'
                  opts.res.minified = ''
                cb opts.res.errors[0], opts.res
            else
              require('./compiler/' + source + '-' + target) opts, ->
                unless typeof opts.res.compiled is 'string'
                  opts.res.compiled = ''
                cb opts.res.errors[0], opts.res

          unless target is 'min'
            compile.min = (opts, cb) ->
              [opts, cb] = opts_factory compilable, opts, cb
              opts.res.xxx = 1
              compile opts, ->
                unless typeof opts.res.compiled is 'string'
                  opts.res.compiled = ''
                if opts.res.errors.length
                  opts.res.minified = ''
                  return cb opts.res.errors[0], opts.res

                opts.source = opts.res.compiled
                minifier = require './minifier/' + target
                minifier opts, ->
                  unless typeof opts.res.minified is 'string'
                    opts.res.minified = ''
                  cb opts.res.errors[0], opts.res

          iface[target] = compile
      iface

return
