
MinificationError = require '../error/minification-error'
UglifyJs          = require 'uglify-js'


module.exports = (inf, cb) ->

  try
    inf.res.minified = UglifyJs.minify(inf.source, {fromString: true}).code

    # uglify-js does not seem to support warnings

  catch err

    pos = MinificationError.parsePos err.line, err.col, -1

    inf.res.errors.push new MinificationError inf, err, pos

  cb()
