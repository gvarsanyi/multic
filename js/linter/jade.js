// Generated by CoffeeScript 1.9.1
var LintError, LintWarning, eof, jade_compiler;

eof = require('./common/eof');

LintError = require('../error/lint-error');

LintWarning = require('../warning/lint-warning');

jade_compiler = require('../compiler/jade-html');

module.exports = function(inf, cb) {
  inf.jadeNodes = [];
  return jade_compiler(inf, function() {
    var attributeNames, attrs, err, i, len, name, node, ref, req_attr, warn;
    inf.compiledJade = inf.res.compiled;
    delete inf.res.compiled;
    if (inf.res.errors.length) {
      return cb();
    }
    try {
      warn = function(desc, val) {
        var pos;
        pos = LintWarning.parsePos(node.line, null, -1);
        if (val) {
          desc += ': `' + val + '`';
        }
        return inf.res.warnings.push(new LintWarning(inf, {}, pos, desc, 'Lint Warning'));
      };
      req_attr = function(attr_name, msg) {
        var attr, found, i, len;
        found = false;
        for (i = 0, len = attrs.length; i < len; i++) {
          attr = attrs[i];
          if (String(attr.name).toLowerCase() === attr_name && attr.val) {
            found = true;
            break;
          }
        }
        if (!found) {
          return warn(msg, name);
        }
      };
      ref = inf.jadeNodes;
      for (i = 0, len = ref.length; i < len; i++) {
        node = ref[i];
        name = node.name, attrs = node.attrs, attributeNames = node.attributeNames;
        if (typeof name === 'string' && name !== name.toLowerCase()) {
          warn('Tag name should be lowercase', name);
        }
        name = name != null ? name.toLowerCase() : void 0;
        switch (name) {
          case 'html':
            req_attr('lang', 'tag has no lang=\'lang-RGN\' attribute value');
            break;
          case 'img':
            req_attr('alt', 'tag has no alt=\'text for image\' attribute value');
            req_attr('src', 'tag has no src=\'image-url\' attribute value');
            break;
          case 'label':
            req_attr('for', 'tag has no for=\'element-id\' attribute value');
        }
      }
      eof(inf);
    } catch (_error) {
      err = _error;
      inf.res.errors.push(new LintError(inf, err));
    }
    return cb();
  });
};