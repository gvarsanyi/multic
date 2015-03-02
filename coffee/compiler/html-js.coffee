
CompilationError = require '../error/compilation-error'
ng_html2js       = require 'ng-html2js'
path             = require 'path'


module.exports = (inf, cb) ->

  try
    if module_name = inf.options.moduleName
      unless typeof module_name is 'string'
        throw new Error '`options.moduleName` must be string'
    else
      basename = path.basename inf.options.file
      if -1 < pos = basename.lastIndexOf '.'
        basename = basename.substr 0, pos
      module_name = basename or ''

    inf.res.compiled = ng_html2js inf.options.file, inf.source, module_name

    # ng-html2js does not seem to support warnings
    # ng-html2js does not have includes

  catch err

    # ng-html2js does not seem to have any errors, so just in case:
    inf.res.errors.push new CompilationError inf, err

  cb()
