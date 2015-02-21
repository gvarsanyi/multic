
compiler = require 'node-sass'
path     = require 'path'


module.exports = (inf, cb) ->

  error = (err) ->
    cb err # TODO: error parsing
#     cb require('../error-parser') inf, err, line, desc

  try
    stats = {}

    pathes = []
    if inf.file
      pathes.push path.dirname(inf.file) + '/'

    compiler.render
      data:         inf.source
      error:        error
      includePaths: pathes
      stats:        stats
      success: (res) ->
        unless (includes = res?.stats?.includedFiles)?.length
          includes = null
        cb null, res.css, includes # TODO , warnings

  catch err
    error err
