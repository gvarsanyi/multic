// Generated by CoffeeScript 1.9.3
var CompilationError, ng_html2js, path;

CompilationError = require('../error/compilation-error');

ng_html2js = require('ng-html2js');

path = require('path');

module.exports = function(inf, cb) {
  var basename, err, module_name, pos;
  try {
    if (module_name = inf.options.moduleName) {
      if (typeof module_name !== 'string') {
        throw new Error('`options.moduleName` must be string');
      }
    } else {
      basename = path.basename(inf.options.file);
      if (-1 < (pos = basename.lastIndexOf('.'))) {
        basename = basename.substr(0, pos);
      }
      module_name = basename || '';
    }
    inf.res.compiled = ng_html2js(inf.options.file, inf.source, module_name);
  } catch (_error) {
    err = _error;
    inf.res.errors.push(new CompilationError(inf, err));
  }
  return cb();
};
