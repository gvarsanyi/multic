
LintWarning = require '../warning/lint-warning'
eol_eof     = require './common/eol-eof'


module.exports = (inf, cb) ->

  try

    eol_eof inf

  catch err

    inf.res.errors.push new LintError inf, err

  cb()