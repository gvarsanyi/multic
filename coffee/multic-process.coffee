
Promise = null # require 'promise'
fs      = require 'fs'
path    = require 'path'


READ    = 1
COMPILE = 2
MINIFY  = 4
WRITE   = 8
LINT    = 128


class MulticProcess

  callback:       null # (function)
  options:        null # (object) user options
  promiseReject:  null # (function)
  promiseResolve: null # (function)
  res:            null # (Object) result of processing (to be returned)
  source:         null # (string) source (or: source file path -> options.file)
  todo:           LINT # (number) bitwise todo: READ(1), COMPILE(2), MINIFY(4),
                       # WRITE(8), LINT(128)


  constructor: (@source, @options={}) ->

    unless typeof @source is 'string' and @source
      throw new Error 'Argument #1 `source` must be string type: source or ' +
                      'source file path'

    unless typeof @options is 'object'
      throw new Error 'Argument #2 `options` must be object type'

    if @options.file?
      unless typeof @options.file is 'string' and
      @options.file = path.resolve @options.file
        throw new Error 'options.file must be a valid URL string'

    @cue = []

    @res =
      errors:   []
      includes: []
      warnings: []


  start: (@todo, @sourceType, @targetType, callback, @target) =>

    # catch repetition, set up tasks, types, save promise/callback handler
    if @promiseResolve or @callback
      throw new Error 'Duplicate processing is forbidden'

    if (@callback = callback)? and typeof @callback isnt 'function'
      arg_id = ' (argument #' + (if (@todo & WRITE) then 2 else 1) + ')'
      throw new Error '`callback`' + arg_id + ' must be a callback function'

    if (@todo & WRITE)
      if (typeof @target isnt 'string' or not @target)
        throw new Error '`target` (argument #1) must be a string with value ' +
                        'that specifies path for file output'

    @todo = @todo | LINT # linting is mandatory

    proxied = MulticProcess.clusterProxy? @

    if @callback # no promise if callback function is used
      unless proxied
        @process()
      return

    Promise ?= require 'promise'
    new Promise (@promiseResolve, @promiseReject) =>
      unless proxied
        @process()


  finish: =>
    err = @res.errors[0] or null

    if @callback
      @callback err, @res
    else if err
      err.res = @res
      @promiseReject err
    else
      @promiseResolve @res
    return


  process: =>
    if @res.errors.length
      return @finish()

    if @todo & READ
      @todo -= READ
      @options.file = path.resolve @source
      return fs.readFile @options.file, {encoding: 'utf8'}, (err, code) =>
        if err
          @res.errors.push err
        @source = @res.source = code or ''
        @process()

    if @todo & LINT
      @todo -= LINT
      return require('./linter/' + @sourceType) @, =>
        @process()

    if @todo & COMPILE
      @todo -= COMPILE
      return require('./compiler/' + @sourceType + '-' + @targetType) @, =>
        unless typeof @res.compiled is 'string'
          @res.compiled = ''
        @process()

    if @todo & MINIFY
      @todo -= MINIFY
      if @res.compiled?
        @source = @res.compiled
      return require('./minifier/' + @targetType) @, =>
        unless typeof @res.minified is 'string'
          @res.minified = ''
        @process()

    if @todo & WRITE
      @todo -= WRITE
      data = @res.minified or @res.compiled
      return fs.writeFile @target, data, {encoding: 'utf8'}, (err) =>
        if err
          @res.errors.push err
        @process()

    @finish()


module.exports = MulticProcess
