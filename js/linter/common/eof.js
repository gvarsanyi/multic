// Generated by CoffeeScript 1.9.1
var LintWarning;

LintWarning = require('../../warning/lint-warning');

module.exports = function(inf) {
  var desc, parts, pos, title;
  if (inf.source.substr(inf.source.length - 1) !== '\n') {
    title = 'Lint Warning (EOF)';
    desc = 'Missing enter character at end of file';
    pos = [(parts = inf.source.split('\n')).length - 1, parts.pop().length];
    return inf.res.warnings.push(new LintWarning(inf, {}, pos, desc, title));
  }
};
