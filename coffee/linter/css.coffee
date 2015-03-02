
CssLint     = require('csslint').CSSLint
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
rule_parser = require './rule/_parser'


module.exports = (inf, cb) ->

  rule_parser inf, 'css', cb, (cfg) ->

    try

      data = CssLint.verify inf.source, cfg

      for msg in data?.messages
        pos = LintError.parsePos msg.line, msg.col, -1, -1

        message = String(msg.message).split(' at line ')[0]
        desc = message
        title = msg.rule?.name
        if msg.type is 'error'
          inf.res.errors.push new LintError inf, msg, pos, desc, title
        else
          inf.res.warnings.push new LintWarning inf, msg, pos, desc, title

    catch err

      inf.res.errors.push new LintError inf, err

    cb()
