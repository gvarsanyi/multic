
CompilationError = require '../error/compilation-error'
compiler         = require 'coffee-script'


module.exports = (inf, cb) ->

  try
    opts = {bare: true}
    if inf.options.file
      opts.filename = inf.options.file

    inf.res.compiled = compiler.compile inf.source, opts

    # coffee-script does not seem to support warnings
    # coffee-script does not have includes

  catch err

    desc = String(err).split('\n')[0].split(':')[4 ...].join(':').trim()

    pos = CompilationError.parsePos err.location?.first_line,
                                    err.location?.first_column

    inf.res.errors.push new CompilationError inf, err, pos, desc

  cb()
