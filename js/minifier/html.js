// Generated by CoffeeScript 1.9.1
var minifier;

minifier = require('minimize');

module.exports = function(inf, cb) {
  var err, error, minify_fn;
  error = function(err) {
    return cb(err);
  };
  try {
    minify_fn = new minifier({
      empty: true,
      cdata: true,
      comments: true,
      conditionals: true
    });
    return minify_fn.parse(inf.source, function(err, minified) {
      if (err) {
        return error(err);
      }
      return cb(null, minified);
    });
  } catch (_error) {
    err = _error;
    return error(err);
  }
};