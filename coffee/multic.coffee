
fs   = require 'fs'
path = require 'path'


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


module.exports = (src, options) ->
  unless typeof src is 'string'
    err_arg0 = new Error 'Argument #1 `source` must be string type'

  if options? and typeof options isnt 'object'
    err_arg1 = new Error 'Argument #2 `options` must be object type'
    options = {}

  opts = {}
  for k, v of options or {}
    opts[k] = v

  res = opts.res ?=
    errors: errors = []
    includes: []
    warnings: []

  if err_arg0
    errors.push err_arg0
  if err_arg1
    errors.push err_arg1


  process = (code, compiled, minified, cb) ->
    unless typeof cb is 'function'
      throw new Error 'Argument #1 (only argument) must be a callback function'

    if errors.length
      return cb errors[0], res

    # read
    if code is null
      opts.file = path.resolve src
      return fs.readFile opts.file, {encoding: 'utf8'}, (err, code) ->
        if err
          errors.push err
        else
          res.source = code
        process code, compiled, minified, cb

    # compile
    if compiled and typeof compiled is 'object'
      {source, target} = compiled
      opts.source ?= code
      return require('./compiler/' + source + '-' + target) opts, ->
        unless typeof res.compiled is 'string'
          res.compiled = ''
        process code, (compiled = res.compiled), minified, cb

    # minify
    if minified and typeof minified is 'object'
      {source} = minified
      if res.compiled
        opts.source = res.compiled
      opts.source ?= code
      return require('./minifier/' + source) opts, ->
        unless typeof res.minified is 'string'
          res.minified = ''
        process code, compiled, (minified = res.minified), cb

    cb null, res


  iface = {file: {}}
  for source, targets of sources
    for target in targets
      do (source, target) ->
        sfn = (iface[source] ?= {})[target] = (cb) ->
          if target is 'min'
            return process src, false, {source}, cb
          process src, {source, target}, false, cb
        unless target is 'min'
          sfn.min = (cb) ->
            process src, {source, target}, {source: target}, cb

        ffn = (iface.file[source] ?= {})[target] = (cb) ->
          if target is 'min'
            return process null, false, {source}, cb
          process null, {source, target}, false, cb
        unless target is 'min'
          ffn.min = (cb) ->
            process null, {source, target}, {source: target}, cb

  iface
