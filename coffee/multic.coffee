
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

linters = ['coffee', 'es6', 'html', 'js']


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


  process = (lint_inf, compile_inf, minify_inf, cb) ->
    unless typeof cb is 'function'
      throw new Error 'Argument #1 (only argument) must be a callback function'

    if errors.length
      return cb errors[0], res

    # read
    unless opts.source?
      opts.file = path.resolve src
      return fs.readFile opts.file, {encoding: 'utf8'}, (err, code) ->
        if err
          errors.push err
        else
          opts.source = res.source = code
        process lint_inf, compile_inf, minify_inf, cb

    # lint
    if lint_inf and lint_inf in linters and (opts.lint or not opts.lint?)
      opts.lint = false
      return require('./linter/' + lint_inf) opts, ->
        process lint_inf, compile_inf, minify_inf, cb

    # compile
    if compile_inf and not res.compiled?
      {source, target} = compile_inf
      return require('./compiler/' + source + '-' + target) opts, ->
        unless typeof res.compiled is 'string'
          res.compiled = ''
        process lint_inf, compile_inf, minify_inf, cb

    # minify
    if minify_inf and not res.minified?
      if res.compiled
        opts.source = res.compiled
      return require('./minifier/' + minify_inf) opts, ->
        unless typeof res.minified is 'string'
          res.minified = ''
        process lint_inf, compile_inf, minify_inf, cb

    cb null, res


  iface = {file: {}}
  for source, targets of sources
    for target in targets
      do (source, target) ->
        sfn = (iface[source] ?= {})[target] = (cb) ->
          opts.source = src
          if target is 'min'
            return process source, false, source, cb
          process source, {source, target}, false, cb
        unless target is 'min'
          sfn.min = (cb) ->
            opts.source = src
            process source, {source, target}, target, cb

        ffn = (iface.file[source] ?= {})[target] = (cb) ->
          if target is 'min'
            return process source, false, source, cb
          process source, {source, target}, false, cb
        unless target is 'min'
          ffn.min = (cb) ->
            process source, {source, target}, target, cb

  iface
