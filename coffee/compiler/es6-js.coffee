
compiler = require '6to5'


module.exports = (inf, cb) ->

  try
    parsed_opts = {}
    if inf.file
      parsed_opts.filename = inf.file

    compiled = (compiler.transform inf.source, parsed_opts).code

    cb null, compiled # TODO: includes, warnings

  catch err
    desc = String(err).split('\n')[0].split(':')[2 ...].join(':').trim()

    if (l = err.loc?.line)? and (c = err.loc?.column)?
      if (pos = desc.lastIndexOf ' (' + l + ':' + c + ')') > -1
        desc = desc.substr 0, pos

    unless isNaN Number line_n = err.loc?.line
      line = line_n - 1

    pos = [line, err.loc?.column]

    cb require('../error-parser') inf, err, pos, desc
