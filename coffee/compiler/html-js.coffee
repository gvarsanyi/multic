
compiler = require 'ng-html2js'


module.exports = (inf, cb) ->

  try
    compiled = compiler inf.file, inf.source # TODO: , module_name
    cb null, compiled, null # TODO: warnings

  catch err
    cb err
#     cb require('../error-parser') inf, err, pos, desc
