
compiler     = require 'node-sass'
error_parser = require '../error-parser'
path         = require 'path'


module.exports = (inf, cb) ->

  try
    stats = {}

    pathes = []
    if inf.file
      pathes.push path.dirname(inf.file) + '/'

    compiler.render
      data:         inf.source
      includePaths: pathes
      stats:        stats
      error: (err) ->
        inf.res.errors.push err
        cb()
      success: (res) ->
        if (includes = res?.stats?.includedFiles)?.length
          inf.res.includes.push includes...
        # TODO warnings?
        inf.res.compiled = res.css
        cb()

  catch err
    # TODO error parsing
    inf.res.errors.push err
    cb()
