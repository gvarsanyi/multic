
jslinter = require './js'


module.exports = (inf, cb) ->

  inf.es6 = true
  jslinter inf, (err, res) ->
    inf.es6 = false
    cb err, res
