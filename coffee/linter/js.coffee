
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
linter      = require('jshint').JSHINT
rule_parser = require './rule/_parser'


module.exports = (inf, cb) ->

  rule_parser inf, (if inf.es6 then 'es6' else 'js'), cb, (cfg) ->
    if inf.es6
      cfg.esnext = true

    try

      linter inf.source, cfg

      for msg in linter.data()?.errors or []
        pos = LintError.parsePos msg.line, msg.character, -1, -1

#         if msg.code is 'W117' and inf.allowGlobals
#           continue

        if msg.code?[0] is 'W'
          title = 'Warning' + if msg.code then ' (' + msg.code + ')' else ''
          inf.res.warnings.push new LintWarning inf, msg, pos, msg.reason, title
        else
          title = 'Error' + if msg.code then ' (' + msg.code + ')' else ''
          inf.res.errors.push new LintError inf, msg, pos, msg.reason, title

    catch err

      inf.res.errors.push new LintError inf, err

    cb()
