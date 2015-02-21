// Generated by CoffeeScript 1.9.1
var minifier;

minifier = require('clean-css');

module.exports = function(inf, cb) {
  var err, error, minified, ref, res, warnings;
  error = function(err) {
    console.log('EE', err.stack);
    return cb(err);
  };
  try {
    res = (new minifier({})).minify(inf.source);
    if (res != null ? (ref = res.errors) != null ? ref.length : void 0 : void 0) {
      return error(res.errors);
    }
    if (!(minified = res != null ? res.styles : void 0)) {
      return error(new Error('Minification failed'));
    }
    warnings = res != null ? res.warnings : void 0;
    return cb(null, minified, warnings);
  } catch (_error) {
    err = _error;
    return error(err);
  }
};