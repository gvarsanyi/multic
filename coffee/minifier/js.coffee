
minifier = require 'uglify-js'


module.exports = (inf, cb) ->

  try
    minified = minifier.minify(inf.source, fromString: true).code

    cb null, minified # TODO: , warnings

  catch err
    # cb require('../error-parser') inf, err, line, desc
    cb err # TODO: error parsing
