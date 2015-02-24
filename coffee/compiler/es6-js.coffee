
CompilationError = require '../error/compilation-error'
compiler         = require '6to5'


module.exports = (inf, cb) ->

  try
    opts = {}
    if inf.file
      opts.filename = inf.file

    inf.res.compiled = (compiler.transform inf.source, opts).code

    # 6to5 does not seem to support warnings
    # 6to5 does not have includes (not ones that would pull in contents anyway)

  catch err

    desc = String(err).split('\n')[0].split(':')[2 ...].join(':').trim()

    if (l = err.loc?.line)? and (c = err.loc?.column)?
      if (pos = desc.lastIndexOf ' (' + l + ':' + c + ')') > -1
        desc = desc.substr 0, pos

    unless isNaN Number line_n = err.loc?.line
      line = line_n - 1

    pos = [line, err.loc?.column]

    inf.res.errors.push new CompilationError inf, err, pos, desc

  cb()