
CompilationError = require '../error/compilation-error'
NodeSass         = require 'node-sass'
fs               = require 'fs'
path             = require 'path'


module.exports = (inf, cb) ->

  if inf.compiledSass?
    inf.res.compiled = inf.compiledSass
    return cb()

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

        unless inf.includeSources and typeof inf.includeSources is 'object' and
        includes?.length
          return cb()
        loaded = 0
        for include in includes
          do (include) ->
            fs.readFile include, {encoding: 'utf8'}, (err, data) ->
              if typeof data is 'string' and not err
                inf.includeSources[include] = data
              loaded += 1
              if loaded >= includes.length
                cb()
        return

    if inf.options.file
      opts.file = inf.options.file
      pathes.push path.resolve path.dirname(inf.options.file) + '/'

    NodeSass.render opts

  catch err
    inf.res.errors.push new CompilationError inf, err
    cb()
