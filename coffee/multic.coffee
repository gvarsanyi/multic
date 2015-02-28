
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


module.exports = (src, options) ->
  unless typeof src is 'string'
    err_arg0 = new Error 'Argument #1 `source` must be string type'

  if options? and typeof options isnt 'object'
    err_arg1 = new Error 'Argument #2 `options` must be object type'
    options = {}

  options ?= {}

  inf = {options}

  res = inf.res ?=
    errors: errors = []
    includes: []
    warnings: []

  inf.ruleTmp = {}

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
    unless inf.source?
      options.file = path.resolve src
      return fs.readFile options.file, {encoding: 'utf8'}, (err, code) ->
        if err
          errors.push err
        else
          inf.source = res.source = code
        process lint_inf, compile_inf, minify_inf, cb

    # lint
    if lint_inf and (inf.lint or not inf.lint?)
      inf.lint = false
      return require('./linter/' + lint_inf) inf, ->
        process lint_inf, compile_inf, minify_inf, cb

    # compile
    if compile_inf and not res.compiled?
      {source, target} = compile_inf
      return require('./compiler/' + source + '-' + target) inf, ->
        unless typeof res.compiled is 'string'
          res.compiled = ''
        process lint_inf, compile_inf, minify_inf, cb

    # minify
    if minify_inf and not res.minified?
      if res.compiled
        inf.source = res.compiled
      return require('./minifier/' + minify_inf) inf, ->
        unless typeof res.minified is 'string'
          res.minified = ''
        process lint_inf, compile_inf, minify_inf, cb

    cb null, res


  iface = {file: {}}
  for source, targets of sources
    for target in targets
      do (source, target) ->
        iface[source] ?= (cb) ->
          inf.source = src
          process source, false, false, cb
        iface.file[source] ?= (cb) ->
          process source, false, false, cb

        sfn = (iface[source] ?= {})[target] = (cb) ->
          inf.source = src
          if target is 'min'
            return process source, false, source, cb
          process source, {source, target}, false, cb
        unless target is 'min'
          sfn.min = (cb) ->
            inf.source = src
            process source, {source, target}, target, cb

        ffn = (iface.file[source] ?= {})[target] = (cb) ->
          if target is 'min'
            return process source, false, source, cb
          process source, {source, target}, false, cb
        unless target is 'min'
          ffn.min = (cb) ->
            process source, {source, target}, target, cb

  iface
