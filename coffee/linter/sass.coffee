
rule_parser   = require './rule/_parser'
sass_compiler = require '../compiler/sass-css'


module.exports = (inf, cb) ->

  inf.sourceMap = []
  inf.includeSources = {}
  sass_compiler inf, ->
    inf.compiledSass = inf.res.compiled
    delete inf.res.compiled

    if inf.res.errors.length
      return cb()

    rule_parser inf, 'sass', cb, (cfg) ->
      cb()
