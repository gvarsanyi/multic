
minifier = require 'clean-css'


module.exports = (inf, cb) ->

  try
    res = (new minifier {}).minify inf.source

    if res?.warnings?.length
      # TODO: warning parser
      inf.res.warnings.push res.warnings...

    if res?.errors?.length
      # TODO: error parser
      inf.res.errors.push res.errors...

    inf.res.minified = res?.styles

  catch err
     # TODO: error parsing
    inf.res.errors.push err

  cb()

