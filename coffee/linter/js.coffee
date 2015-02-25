
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
linter      = require('jshint').JSHINT


module.exports = (inf, cb) ->

  try
    cfg = # see option descriptions at http://jshint.com/docs/options/
      curly:        true
      devel:        true
      freeze:       true
      globalstrict: true
      immed:        true
      latedef:      true
      noarg:        true
      node:         true
      nonbsp:       true
      nonew:        true
      quotmark:     true
      singleGroups: true
      undef:        true
      unused:       true

    if (indent = inf.indentation) and
    parseInt(indent, 10) is Number(indent) and indent > 0
      cfg.indent = indent

    if maxlen = inf.maxLength80
      cfg.maxlen = 80

    if inf.es6
      cfg.esnext = true

    linter inf.source, cfg

    for msg in linter.data()?.errors or []
      pos = LintError.parsePos msg.line, msg.character, -1, -1

      if msg.code is 'W117' and inf.allowGlobals
        continue

      if msg.code?[0] is 'W'
        title = 'Lint Warning' + if msg.code then ' (' + msg.code + ')' else ''
        inf.res.warnings.push new LintWarning inf, msg, pos, msg.reason, title
      else
        title = 'Error' + if msg.code then ' (' + msg.code + ')' else ''
        inf.res.errors.push new LintError inf, msg, pos, msg.reason, title

  catch err

    inf.res.errors.push new LintError inf, err

  cb()
