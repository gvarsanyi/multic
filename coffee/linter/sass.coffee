
rule_parser = require './rule/_parser'


module.exports = (inf, cb) ->

  rule_parser inf, 'sass', cb, (cfg) ->
    cb()
