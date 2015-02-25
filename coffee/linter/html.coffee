
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
linter      = require 'htmllint'


module.exports = (inf, cb) ->

  try
    cfg = # descriptions at: https://github.com/htmllint/htmllint/wiki/Options
      'attr-name-style':    'dash'
      'attr-no-dup':         true
      'attr-no-unsafe-char': true
      'attr-quote-style':    'quoted' # TODO quote consistency
      'attr-req-value':      true
      'html-req-lang':       true
      'id-no-dup':           true
      'img-req-alt':         true
      'img-req-src':         true
      'indent-style':        'spaces'
      'label-req-for':       true
      'line-end-style':      'lf'
      # 'spec-char-escape':    true # this also trigger warnings about spaces
      'tag-name-lowercase':  true
      'tag-name-match':      true
      'tag-self-close':      true
      'indent-width':        false

    if (indent = inf.indentation) and
    parseInt(indent, 10) is Number(indent) and indent > 0
      cfg['indent-width'] = indent

    # TODO support for max line length
    # if maxlen = inf.maxLength80
    #  cfg.maxlen = 80

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
      console.log 'Y', err
      inf.res.errors.push new LintError inf, err
      cb()

    (linter inf.source, cfg).then success, error


#     for msg in linter.data()?.errors or []
#       pos = LintError.parsePos msg.line, msg.character, -1, -1
#
#       if msg.code is 'W117' and inf.allowGlobals
#         continue
#
#       if msg.code?[0] is 'W'
#         title = 'Lint Warning' + if msg.code then ' (' + msg.code + ')' else ''
#         inf.res.warnings.push new LintWarning inf, msg, pos, msg.reason, title
#       else
#         title = 'Error' + if msg.code then ' (' + msg.code + ')' else ''
#         inf.res.errors.push new LintError inf, msg, pos, msg.reason, title

  catch err

    inf.res.errors.push new LintError inf, err
    cb()
