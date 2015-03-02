// Generated by CoffeeScript 1.9.1
var LintError, LintWarning, htmllint, rule_parser;

LintError = require('../error/lint-error');

LintWarning = require('../warning/lint-warning');

htmllint = require('htmllint');

rule_parser = require('./rule/_parser');

require('../patch/htmllint-patch');

module.exports = function(inf, cb) {
  return rule_parser(inf, 'html', cb, function(cfg) {
    var err, error, success;
    try {
      success = function(warnings) {
        var desc, err, i, len, msg, pos, title;
        try {
          for (i = 0, len = warnings.length; i < len; i++) {
            msg = warnings[i];
            pos = LintError.parsePos(msg.line, msg.column, -1, -1);
            desc = htmllint.messages.renderIssue(msg);
            title = 'Warning' + (msg.code ? ' (' + msg.code + ')' : '');
            inf.res.warnings.push(new LintWarning(inf, msg, pos, desc, title));
          }
        } catch (_error) {
          err = _error;
          inf.res.errors.push(new LintError(inf, err));
        }
        return cb();
      };
      error = function(err) {
        inf.res.errors.push(new LintError(inf, err));
        return cb();
      };
      return (htmllint(inf.source, cfg)).then(success, error);
    } catch (_error) {
      err = _error;
      inf.res.errors.push(new LintError(inf, err));
      return cb();
    }
  });
};
