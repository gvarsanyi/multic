
minifier = require 'clean-css'


module.exports = (inf, cb) ->

  error = (err) ->
    # cb require('../error-parser') inf, err, line, desc
    console.log 'EE', err.stack
    cb err # TODO: error parsing

  try
    res = (new minifier {}).minify inf.source

    if res?.errors?.length
      return error res.errors

    unless minified = res?.styles
      return error new Error 'Minification failed'

    warnings = res?.warnings
    # TODO process warnings

    cb null, minified, warnings

  catch err
    error err
