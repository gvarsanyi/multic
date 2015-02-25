
LintWarning = require '../../warning/lint-warning'


module.exports = (inf) ->

  unless inf.source.substr(inf.source.length - 1) is '\n'

    title = 'Lint Warning (EOF)'
    desc = 'Missing enter character at end of file'
    pos = [(parts = inf.source.split '\n').length - 1, parts.pop().length]

    inf.res.warnings.push new LintWarning inf, {}, pos, desc, title
