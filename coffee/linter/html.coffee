
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
linter      = require 'htmllint'
rule_parser = require './rule/_parser'


module.exports = (inf, cb) ->

  rule_parser inf, 'html', cb, (cfg) ->

    try

      success = (warnings) ->
        try
          for msg in warnings
            pos = LintError.parsePos msg.line, msg.column, -1, -1
            desc = linter.messages.renderIssue msg
            title = 'Lint Warning' + if msg.code then ' (' + msg.code + ')' else ''
            inf.res.warnings.push new LintWarning inf, msg, pos, desc, title
        catch err
          inf.res.errors.push new LintError inf, err

        cb()

      error = (err) ->
        inf.res.errors.push new LintError inf, err
        cb()

      (linter inf.source, cfg).then success, error

    catch err

      inf.res.errors.push new LintError inf, err
      cb()
