
minifier = require 'minimize'


module.exports = (inf, cb) ->

  error = (err) ->
    # cb require('../error-parser') inf, err, line, desc
    cb err # TODO: error parsing

  try
    minify_fn = new minifier
      empty:        true # KEEP empty attributes
      cdata:        true # KEEP CDATA from scripts
      comments:     true # KEEP comments
      conditionals: true # KEEP conditional internet explorer comments

    minify_fn.parse inf.source, (err, minified) ->
      if err
        return error err
      cb null, minified # TODO: , warnings

  catch err
    error err
