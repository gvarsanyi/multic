// Generated by CoffeeScript 1.9.1
var LintError, LintWarning, linter;

LintError = require('../error/lint-error');

LintWarning = require('../warning/lint-warning');

linter = require('htmllint');

module.exports = function(inf, cb) {
  var cfg, err, error, indent, success;
  try {
    cfg = {
      'attr-name-style': 'dash',
      'attr-no-dup': true,
      'attr-no-unsafe-char': true,
      'attr-quote-style': 'quoted',
      'attr-req-value': true,
      'html-req-lang': true,
      'id-no-dup': true,
      'img-req-alt': true,
      'img-req-src': true,
      'indent-style': 'spaces',
      'label-req-for': true,
      'line-end-style': 'lf',
      'tag-name-lowercase': true,
      'tag-name-match': true,
      'tag-self-close': true,
      'indent-width': false
    };
    if ((indent = inf.indentation) && parseInt(indent, 10) === Number(indent) && indent > 0) {
      cfg['indent-width'] = indent;
    }
    success = function(warnings) {
      var desc, err, i, len, msg, pos, title;
      try {
        for (i = 0, len = warnings.length; i < len; i++) {
          msg = warnings[i];
          pos = LintError.parsePos(msg.line, msg.column, -1, -1);
          desc = linter.messages.renderIssue(msg);
          title = 'Lint Warning' + (msg.code ? ' (' + msg.code + ')' : '');
          inf.res.warnings.push(new LintWarning(inf, msg, pos, desc, title));
        }
      } catch (_error) {
        err = _error;
        inf.res.errors.push(new LintError(inf, err));
      }
      return cb();
    };
    error = function(err) {
      console.log('Y', err);
      inf.res.errors.push(new LintError(inf, err));
      return cb();
    };
    return (linter(inf.source, cfg)).then(success, error);
  } catch (_error) {
    err = _error;
    inf.res.errors.push(new LintError(inf, err));
    return cb();
  }
};