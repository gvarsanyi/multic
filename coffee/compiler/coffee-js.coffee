
compiler     = require 'coffee-script'
error_parser = require '../error-parser'


module.exports = (inf, cb) ->

  try
    inf.res.compiled = compiler.compile inf.source, {bare: true}

    # TODO warnings?

  catch err
    desc = String(err).split('\n')[0].split(':')[4 ...].join(':').trim()

    if err.location?.first_line?
      pos = [err.location?.first_line, err.location?.first_column]

    inf.res.errors.push error_parser inf, err, pos, desc

  cb()
