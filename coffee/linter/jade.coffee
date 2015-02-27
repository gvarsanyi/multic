
jade_compiler = require '../compiler/jade-html'
rule_parser   = require './rule/_parser'


module.exports = (inf, cb) ->

  inf.jadeNodes = []
  jade_compiler inf, ->
    inf.compiledJade = inf.res.compiled
    delete inf.res.compiled

    if inf.res.errors.length
      return cb()

    rule_parser inf, 'jade', cb, (cfg) ->
      cb()
