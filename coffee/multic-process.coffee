
Promise = null # require 'promise'
fs      = require 'fs'
path    = require 'path'

REQUESTED  = 1
PROCESSING = 2
FINISHED   = 3

READ    = 1
COMPILE = 2
MINIFY  = 4


class MulticProcess

  callback:       null # (function)
  options:        null # (object) user options
  promiseReject:  null # (function)
  promiseResolve: null # (function)
  res:            null # (Object) result of processing (to be returned)
  req:            null # (Object) request statuses: read, lint, compile, minify
  source:         null # (string) source (or: source file path -> options.file)


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

    @req =
      # read:    REQUESTED
      lint:    REQUESTED
      # compile: REQUESTED
      # minify:  REQUESTED


  start: (todo, source_type, target_type, callback) =>
    # catch repetition, set up tasks, types, save promise/callback handler
    if @promiseResolve or @callback
      throw new Error 'Duplicate processing is forbidden'

    if callback? and typeof callback isnt 'function'
      throw new Error 'Argument #1 (only argument) must be a callback function'
    @callback = callback

    @sourceType = source_type
    @targetType = target_type

    if todo & READ
      @req.read = REQUESTED
    if todo & COMPILE
      @req.compile = REQUESTED
    if todo & MINIFY
      @req.minify = REQUESTED

    if @callback # no promise if callback function is used
      @process()
      return

    Promise ?= require 'promise'
    new Promise (@promiseResolve, @promiseReject) =>
      @process()


  process: =>
    finish = =>
      err = @res.errors[0] or null

      if @callback
        @callback err, @res
      else if err
        err.res = @res
        @promiseReject err
      else
        @promiseResolve @res
      return

    if @res.errors.length
      return finish()

    if @req.read is REQUESTED
      @req.read = PROCESSING
      @options.file = path.resolve @source
      return fs.readFile @options.file, {encoding: 'utf8'}, (err, code) =>
        if err
          @res.errors.push err
        @source = @res.source = code or ''
        @req.read = FINISHED
        @process()

    if @req.lint is REQUESTED
      @req.lint = PROCESSING
      return require('./linter/' + @sourceType) @, =>
        @req.lint = FINISHED
        @process()

    if @req.compile is REQUESTED
      @req.compile = PROCESSING
      return require('./compiler/' + @sourceType + '-' + @targetType) @, =>
        @req.compile = FINISHED
        unless typeof @res.compiled is 'string'
          @res.compiled = ''
        @process()

    if @req.minify is REQUESTED
      @req.minify = PROCESSING
      if @res.compiled?
        @source = @res.compiled
      return require('./minifier/' + @targetType) @, =>
        @req.minify = FINISHED
        unless typeof @res.minified is 'string'
          @res.minified = ''
        @process()

    finish()


module.exports = MulticProcess
