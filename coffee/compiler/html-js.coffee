
CompilationError = require '../error/compilation-error'
compiler         = require 'ng-html2js'


module.exports = (inf, cb) ->

  try
    inf.res.compiled = compiler inf.file, inf.source # TODO , module_name

    # ng-html2js does not seem to support warnings
    # ng-html2js does not have includes (not ones that would pull in contents anyway)

  catch err

    # ng-html2js does not seem to have any errors, so just in case:
    inf.res.errors.push new CompilationError inf, err

  cb()
