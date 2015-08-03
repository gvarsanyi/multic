// Generated by CoffeeScript 1.9.3
var CoffeeLint, LintError, LintWarning, rule_parser;

CoffeeLint = require('coffeelint');

LintError = require('../error/lint-error');

LintWarning = require('../warning/lint-warning');

rule_parser = require('./rule/_parser');

module.exports = function(inf, cb) {
  return rule_parser(inf, 'coffee', cb, function(cfg) {
    var col, desc, err, i, len, line, messages, msg, parts, pos, ref, rule, title;
    try {
      messages = CoffeeLint.lint(inf.source, cfg);
      for (i = 0, len = messages.length; i < len; i++) {
        msg = messages[i];
        rule = msg.rule ? '[' + msg.rule + '] ' : '';
        if (typeof msg.message === 'string') {
          if (msg.message.substr(0, 7) === '[stdin]') {
            parts = msg.message.split(' ');
            ref = parts[0].substr(8).split(':'), line = ref[0], col = ref[1];
            msg.message = parts.slice(1).join(' ');
          }
          if (msg.message.substr(0, 7) === 'error: ') {
            msg.message = msg.message[7].toUpperCase() + msg.message.substr(8);
          }
          msg.message = msg.message.split('\u001b')[0];
          if ((pos = msg.message.lastIndexOf('\n')) > -1) {
            msg.message = msg.message.substr(0, pos);
          }
          if (msg.description) {
            desc = rule + msg.description.split('\n<pre>')[0];
            title = msg.message;
          }
        }
        pos = LintError.parsePos(msg.lineNumber || line, col, -1, -1);
        if (msg.level === 'error') {
          if (title == null) {
            title = rule + 'Error';
          }
          inf.res.errors.push(new LintError(inf, msg, pos, desc, title));
        } else {
          if (title == null) {
            title = rule + 'Lint warning';
          }
          inf.res.warnings.push(new LintWarning(inf, msg, pos, desc, title));
        }
      }
    } catch (_error) {
      err = _error;
      inf.res.errors.push(new LintError(inf, err));
    }
    return cb();
  });
};
