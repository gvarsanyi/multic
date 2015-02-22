
compiler     = require 'ng-html2js'
error_parser = require '../error-parser'


module.exports = (inf, cb) ->

  try
    inf.res.compiled = compiler inf.file, inf.source # TODO: , module_name

    # TODO warnings?

  catch err
    # TODO error parsing
    inf.res.errors.push err

  cb()
