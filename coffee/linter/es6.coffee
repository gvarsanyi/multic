
jslinter = require './js'


module.exports = (inf, cb) ->

  inf.es6 = true
  jslinter inf, ->
    inf.es6 = false
    cb()
