
minifier = require 'minimize'


module.exports = (inf, cb) ->

  try
    minify_fn = new minifier
      empty:        true # KEEP empty attributes
      cdata:        true # KEEP CDATA from scripts
      comments:     true # KEEP comments
      conditionals: true # KEEP conditional internet explorer comments

    minify_fn.parse inf.source, (err, minified) ->
      # TODO warnings?

      if err
        # TODO: error parsing
        inf.res.errors.push err

      inf.res.minified = minified

      cb()

  catch err
     # TODO: error parsing
    inf.res.errors.push err

  cb()
