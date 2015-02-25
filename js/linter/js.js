// Generated by CoffeeScript 1.9.1
var LintError, LintWarning, linter;

LintError = require('../error/lint-error');

LintWarning = require('../warning/lint-warning');

linter = require('jshint').JSHINT;

module.exports = function(inf, cb) {
  var cfg, err, i, indent, len, maxlen, msg, pos, ref, ref1, ref2, title;
  try {
    cfg = {
      curly: true,
      devel: true,
      freeze: true,
      globalstrict: true,
      immed: true,
      latedef: true,
      noarg: true,
      node: true,
      nonbsp: true,
      nonew: true,
      quotmark: true,
      singleGroups: true,
      undef: true,
      unused: true
    };
    if ((indent = inf.indentation) && parseInt(indent, 10) === Number(indent) && indent > 0) {
      cfg.indent = indent;
    }
    if (maxlen = inf.maxLength80) {
      cfg.maxlen = 80;
    }
    if (inf.es6) {
      cfg.esnext = true;
    }
    linter(inf.source, cfg);
    ref1 = ((ref = linter.data()) != null ? ref.errors : void 0) || [];
    for (i = 0, len = ref1.length; i < len; i++) {
      msg = ref1[i];
      pos = LintError.parsePos(msg.line, msg.character, -1, -1);
      if (msg.code === 'W117' && inf.allowGlobals) {
        continue;
      }
      if (((ref2 = msg.code) != null ? ref2[0] : void 0) === 'W') {
        title = 'Lint Warning' + (msg.code ? ' (' + msg.code + ')' : '');
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
};
