
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
linter      = require 'htmllint'
rule_parser = require './rule/_parser'


# htmllint patch
RuleIssue = require '../../node_modules/htmllint/lib/issue'
rule      = require '../../node_modules/htmllint/lib/rules/html-req-lang'
rule.lint = (element, opts) ->
  unless opts[@name] and not element?.attribs?.lang?.value
    return []
  new RuleIssue 'E025', element.openLineCol


module.exports = (inf, cb) ->

  rule_parser inf, 'html', cb, (cfg) ->

    try

      success = (warnings) ->
        try
          for msg in warnings
            pos = LintError.parsePos msg.line, msg.column, -1, -1
            desc = linter.messages.renderIssue msg
            title = 'Warning' + if msg.code then ' (' + msg.code + ')' else ''
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
