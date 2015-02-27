
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
linter      = require('coffeelint').lint
rule_parser = require './rule/_parser'


module.exports = (inf, cb) ->

  rule_parser inf, 'coffee', cb, (cfg) ->

    try

      for msg in linter inf.source, cfg
        rule = if msg.rule then '[' + msg.rule + '] ' else ''

        if typeof msg.message is 'string'
          if msg.message.substr(0, 7) is '[stdin]'
            parts = msg.message.split(' ')
            [line, col] = parts[0].substr(8).split ':'
            msg.message = parts[1 ...].join ' '

          msg.message = msg.message.split('\u001b')[0]
          if (pos = msg.message.lastIndexOf '\n') > -1
            msg.message = msg.message.substr 0, pos

          if msg.description
            desc  = rule + msg.description.split('\n<pre>')[0]
            title = msg.message

        pos = LintError.parsePos (msg.lineNumber or line), col, -1, -1

        if msg.level is 'error'
          title ?= rule + 'Error'
          inf.res.errors.push new LintError inf, msg, pos, desc, title
        else
          title ?= rule + 'Lint warning'
          inf.res.warnings.push new LintWarning inf, msg, pos, desc, title

    catch err

      inf.res.errors.push new LintError inf, err

    cb()
