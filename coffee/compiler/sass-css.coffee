
CompilationError = require '../error/compilation-error'
NodeSass         = require 'node-sass'
fs               = require 'fs'
path             = require 'path'


module.exports = (inf, cb) ->

  try
    stats = {}

    pathes = []
    opts =
      data:         inf.source
      includePaths: pathes
      stats:        stats

      error: (err) ->
        pos = CompilationError.parsePos err.line, err.column, -1, -1
        inf.res.errors.push new CompilationError inf, err, pos
        cb()

      success: (res) ->
        if (includes = res?.stats?.includedFiles)?.length
          inf.res.includes.push includes...

        # node-sass does not seem to support warnings

        inf.res.compiled = res.css
        cb()

    if inf.options.file
      opts.file = inf.options.file
      pathes.push path.resolve path.dirname(inf.options.file) + '/'

    NodeSass.render opts

  catch err
    inf.res.errors.push new CompilationError inf, err
    cb()
