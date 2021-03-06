// Generated by CoffeeScript 1.9.3
var Babel, CompilationError;

Babel = require('babel');

CompilationError = require('../error/compilation-error');

module.exports = function(inf, cb) {
  var c, desc, err, l, opts, pos, ref, ref1, ref2, ref3;
  try {
    opts = {};
    if (inf.options.file) {
      opts.filename = inf.options.file;
    }
    inf.res.compiled = (Babel.transform(inf.source, opts)).code;
  } catch (_error) {
    err = _error;
    desc = String(err).split('\n')[0].split(':').slice(2).join(':').trim();
    if (((l = (ref = err.loc) != null ? ref.line : void 0) != null) && ((c = (ref1 = err.loc) != null ? ref1.column : void 0) != null)) {
      if ((pos = desc.lastIndexOf(' (' + l + ':' + c + ')')) > -1) {
        desc = desc.substr(0, pos);
      }
    }
    pos = CompilationError.parsePos((ref2 = err.loc) != null ? ref2.line : void 0, (ref3 = err.loc) != null ? ref3.column : void 0, -1);
    inf.res.errors.push(new CompilationError(inf, err, pos, desc));
  }
  return cb();
};
