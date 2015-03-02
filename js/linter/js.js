// Generated by CoffeeScript 1.9.1
var LintError, LintWarning, jshint, rule_parser;

LintError = require('../error/lint-error');

LintWarning = require('../warning/lint-warning');

jshint = require('jshint').JSHINT;

rule_parser = require('./rule/_parser');

module.exports = function(inf, cb) {
  return rule_parser(inf, (inf.es6 ? 'es6' : 'js'), cb, function(cfg) {
    var err, i, len, msg, pos, ref, ref1, ref2, title;
    if (inf.es6) {
      cfg.esnext = true;
    }
    try {
      jshint(inf.source, cfg);
      ref1 = ((ref = jshint.data()) != null ? ref.errors : void 0) || [];
      for (i = 0, len = ref1.length; i < len; i++) {
        msg = ref1[i];
        pos = LintError.parsePos(msg.line, msg.character, -1, -1);
        if (((ref2 = msg.code) != null ? ref2[0] : void 0) === 'W') {
          title = 'Warning' + (msg.code ? ' (' + msg.code + ')' : '');
          inf.res.warnings.push(new LintWarning(inf, msg, pos, msg.reason, title));
        } else {
          title = 'Error' + (msg.code ? ' (' + msg.code + ')' : '');
          inf.res.errors.push(new LintError(inf, msg, pos, msg.reason, title));
        }
      }
    } catch (_error) {
      err = _error;
      inf.res.errors.push(new LintError(inf, err));
    }
    return cb();
  });
};
