
LintError = require '../../error/lint-error'


module.exports = (inf, source_type, msg_factory, title, lines) ->

  if -1 < pos = inf.source.indexOf '\r'

    desc = 'CR (\\r) character found'
    pos = LintError.posByIndex lines, pos

    msg_factory pos, desc, title
