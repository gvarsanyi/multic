
CompilationError = require '../error/compilation-error'
ng_html2js       = require 'ng-html2js'


module.exports = (inf, cb) ->

  try
    inf.res.compiled = ng_html2js inf.options.file, inf.source # TODO mod_name

    # ng-html2js does not seem to support warnings
    # ng-html2js does not have includes

  catch err

    # ng-html2js does not seem to have any errors, so just in case:
    inf.res.errors.push new CompilationError inf, err

  cb()
