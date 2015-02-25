
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
linter      = require('coffeelint').lint


module.exports = (inf, cb) ->

  try
    warn_level = {level: 'warn'}
    cfg = # see option descriptions at http://www.coffeelint.org/#options
      camel_case_classes:           warn_level
      colon_assignment_spacing:     warn_level
      line_endings:                 warn_level
      no_empty_param_list:          warn_level
      no_implicit_braces:           warn_level
      no_plusplus:                  warn_level
      no_unnecessary_double_quotes: warn_level
      prefer_english_operator:      warn_level
      space_operators:              warn_level
      spacing_after_comma:          warn_level

    if inf.maxLength80
      cfg.max_line_length = warn_level

    for msg in linter inf.source, cfg
      rule = if msg.rule then '[' + msg.rule + '] ' else ''

      if typeof msg.message is 'string'
        if msg.message.substr(0, 7) is '[stdin]'
          parts = msg.message.split(' ')
          [line, col] = parts[0].substr(8).split ':'
          msg.message = parts[1 ...].join ' '

        msg.message = msg.message.split('\\u001b')[0]

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
