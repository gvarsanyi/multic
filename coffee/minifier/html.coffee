
MinificationError = require '../error/minification-error'
minifier          = require 'minimize'


module.exports = (inf, cb) ->

  try
    minify_fn = new minifier
      empty:        true # KEEP empty attributes
      cdata:        true # KEEP CDATA from scripts
      comments:     true # KEEP comments
      conditionals: true # KEEP conditional internet explorer comments

    minify_fn.parse inf.source, (err, minified) ->

      if err # minimize does not seem to support errors, so just in case
        inf.res.errors.push new MinificationError inf, err
      else
        inf.res.minified = minified

      # minimize does not seem to support warnings

      cb()

  catch err
    inf.res.errors.push new MinificationError inf, err

  cb()
