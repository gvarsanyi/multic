
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
htmllint    = require 'htmllint'
rule_parser = require './rule/_parser'


require '../patch/htmllint-patch'


module.exports = (inf, cb) ->

  rule_parser inf, 'html', cb, (cfg) ->

    try

      success = (warnings) ->
        try
          for msg in warnings
            pos = LintError.parsePos msg.line, msg.column, -1, -1
            desc = htmllint.messages.renderIssue msg
            title = 'Warning' + if msg.code then ' (' + msg.code + ')' else ''
            inf.res.warnings.push new LintWarning inf, msg, pos, desc, title
        catch err
          inf.res.errors.push new LintError inf, err

        cb()

      error = (err) ->
        inf.res.errors.push new LintError inf, err
        cb()

      (htmllint inf.source, cfg).then success, error

    catch err

      inf.res.errors.push new LintError inf, err
      cb()
