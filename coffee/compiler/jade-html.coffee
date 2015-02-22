
compiler     = require 'jade'
error_parser = require '../error-parser'


module.exports = (inf, cb) ->

  try
    inf.res.compiled = compiler.render inf.source,
      filename:     inf.file
      compileDebug: false
      pretty:       true
      includes:     (includes = [])

    if Array.isArray includes
      inf.res.includes.push includes...

    # TODO warnings?

  catch err
    desc = String(err).split('\n\n')[1 ...].join '\n\n'

    for err_line in String(err).split '\n'
      if err_line.substr(0, 4) is '  > ' and
      (line_n = String(err_line.substr(4).split('|')[0]).trim()) and
      not isNaN line_n = Number line_n
        line = line_n - 1
        break

    inf.res.errors.push error_parser inf, err, line, desc

  cb()
