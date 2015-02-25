
CompilationError = require '../error/compilation-error'
compiler         = require 'babel'


module.exports = (inf, cb) ->

  try
    opts = {}
    if inf.file
      opts.filename = inf.file

    inf.res.compiled = (compiler.transform inf.source, opts).code

    # babel does not seem to support warnings
    # babel does not have includes (not ones that would pull in contents anyway)

  catch err

    desc = String(err).split('\n')[0].split(':')[2 ...].join(':').trim()

    if (l = err.loc?.line)? and (c = err.loc?.column)?
      if (pos = desc.lastIndexOf ' (' + l + ':' + c + ')') > -1
        desc = desc.substr 0, pos

    pos = CompilationError.parsePos err.loc?.line, err.loc?.column, -1

    inf.res.errors.push new CompilationError inf, err, pos, desc

  cb()