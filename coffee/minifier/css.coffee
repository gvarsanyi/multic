
CleanCss          = require 'clean-css'
MinificationError = require '../error/minification-error'


module.exports = (inf, cb) ->

  try
    res = (new CleanCss {}).minify inf.source

    for err in res.errors or []
      inf.res.errors.push new MinificationError inf, err

    # actually, all returned warnings seem to be errors
    for warn in res.warnings or []
      inf.res.errors.push new MinificationError inf, warn

    inf.res.minified = res?.styles

  catch err
      inf.res.errors.push new MinificationError inf, err

  cb()

