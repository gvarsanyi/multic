// Generated by CoffeeScript 1.9.1
var html2js, jade2html;

jade2html = require('./jade-html');

html2js = require('./html-js');

module.exports = function(inf, cb) {
  return jade2html(inf, function(err, compiled, includes1, warnings1) {
    if (err) {
      return cb(err);
    }
    inf.source = compiled;
    return html2js(inf, function(err, compiled, includes2, warnings2) {
      var includes, warnings;
      if (err) {
        return cb(err);
      }
      if ((includes1 != null ? includes1.length : void 0) || (includes2 != null ? includes2.length : void 0)) {
        includes = (includes1 || []).concat(includes2 || []);
      }
      if ((warnings1 != null ? warnings1.length : void 0) || (warnings2 != null ? warnings2.length : void 0)) {
        warnings = (warnings1 || []).concat(warnings2 || []);
      }
      return cb(null, compiled, includes, warnings);
    });
  });
};