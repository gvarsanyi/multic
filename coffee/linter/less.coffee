
rule_parser   = require './rule/_parser'
less_compiler = require '../compiler/less-css'


module.exports = (inf, cb) ->

  inf.sourceMap = []
  inf.includeSources = {}
  less_compiler inf, ->
    inf.compiledLess = inf.res.compiled
    delete inf.res.compiled

    if inf.res.errors.length
      return cb()

    rule_parser inf, 'less', cb, (cfg) ->
      cb()
