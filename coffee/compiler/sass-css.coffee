
CompilationError = require '../error/compilation-error'
compiler         = require 'node-sass'
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
        if isNaN Number line = err.line
          line = null
        else
          line -= 1
          if isNaN Number col = err.column
            col = null
          else
            col -= 1
          pos = [line, col]

        inf.res.errors.push new CompilationError inf, err, pos
        cb()

      success: (res) ->
        if (includes = res?.stats?.includedFiles)?.length
          inf.res.includes.push includes...

        # node-sass does not seem to support warnings

        inf.res.compiled = res.css
        cb()

    if inf.file
      opts.file = inf.file
      pathes.push path.resolve path.dirname(inf.file) + '/'

    compiler.render opts

  catch err
    inf.res.errors.push new CompilationError inf, err
    cb()
