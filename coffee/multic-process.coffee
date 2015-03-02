
fs   = require 'fs'
path = require 'path'


REQUESTED  = 1
PROCESSING = 2
FINISHED   = 3

READ    = 1
COMPILE = 2
MINIFY  = 4


class MulticProcess

  flushed: false
  options: null # (object) user options
  res:     null # (Object) result of processing (to be returned)
  req:     null # (Object) request statuses: read, lint, compile, minify
  source:  null # (string) source (or: source file path -> options.file)


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


  process: (todo, source_type, target_type, cb, iter) =>
    unless typeof cb is 'function'
      throw new Error 'Argument #1 (only argument) must be a callback function'

    unless iter
      if @flushed
        throw new Error 'Duplicate processing is forbidden'
      else
        if todo & READ
          @req.read = REQUESTED
        if todo & COMPILE
          @req.compile = REQUESTED
        if todo & MINIFY
          @req.minify = REQUESTED

      @flushed = true

    if @res.errors.length
      cb @res.errors[0], @res
      return

    if @req.read is REQUESTED
      @req.read = PROCESSING
      @options.file = path.resolve @source
      fs.readFile @options.file, {encoding: 'utf8'}, (err, code) =>
        if err
          @res.errors.push err
        @source = @res.source = code or ''
        @req.read = FINISHED
        @process todo, source_type, target_type, cb, true
      return

    if @req.lint is REQUESTED
      @req.lint = PROCESSING
      require('./linter/' + source_type) @, =>
        @req.lint = FINISHED
        @process todo, source_type, target_type, cb, true
      return

    if @req.compile is REQUESTED
      @req.compile = PROCESSING
      require('./compiler/' + source_type + '-' + target_type) @, =>
        @req.compile = FINISHED
        unless typeof @res.compiled is 'string'
          @res.compiled = ''
        @process todo, source_type, target_type, cb, true
      return

    if @req.minify is REQUESTED
      @req.minify = PROCESSING
      if @res.compiled?
        @source = @res.compiled
      require('./minifier/' + target_type) @, =>
        @req.minify = FINISHED
        unless typeof @res.minified is 'string'
          @res.minified = ''
        @process todo, source_type, target_type, cb, true
      return

    cb null, @res
    return


module.exports = MulticProcess
