
minifier = require 'uglify-js'


module.exports = (inf, cb) ->

  minified = minifier.minify(inf.source, {fromString: true}).code
  try

    # TODO warnings?
    if err
      # TODO: error parsing
      inf.res.errors.push err

    inf.res.minified = minified

  catch err
     # TODO: error parsing
    inf.res.errors.push err

  cb()
