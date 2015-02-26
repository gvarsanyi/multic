
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
eol_eof     = require './common/eol-eof'
linter      = require('csslint').CSSLint.verify


module.exports = (inf, cb) ->

  try
    cfg = # see descriptions at: https://github.com/CSSLint/csslint/wiki/Rules
      'star-property-hack':       true # Disallow star hack
      'underscore-property-hack': true # Disallow underscore hack
      'import':                   true # Disallow @import
      'universal-selector':       true # Disallow universal selector
      'overqualified-elements':   true # Disallow overqualified elements
      'zero-units':               true # Disallow units for zero values
      'unqualified-attributes':  true # Disallow unqualified attribute selectors
      'ids':                      true # Disallow IDs in selectors
      'important':                true # Disallow !important

    data = linter inf.source, cfg

    for msg in data?.messages
      pos = LintError.parsePos msg.line, msg.col, -1, -1

      message = String(msg.message).split(' at line ')[0]
      desc = message
      title = msg.rule?.name
      if msg.type is 'error'
        inf.res.errors.push new LintError inf, msg, pos, desc, title
      else
        inf.res.warnings.push new LintWarning inf, msg, pos, desc, title

    eol_eof inf

  catch err

    inf.res.errors.push new LintError inf, err

  cb()
