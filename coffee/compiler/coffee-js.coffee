
compiler = require 'coffee-script'


module.exports = (inf, cb) ->

  try
    compiled = compiler.compile inf.source, {bare: true}

    cb null, compiled, null # TODO: warnings

  catch err
    desc = String(err).split('\n')[0].split(':')[4 ...].join(':').trim()

    if err.location?.first_line?
      pos = [err.location?.first_line, err.location?.first_column]

    cb require('../error-parser') inf, err, pos, desc
