// Generated by CoffeeScript 1.9.1
var jslinter;

jslinter = require('./js');

module.exports = function(inf, cb) {
  inf.es6 = true;
  return jslinter(inf, function() {
    inf.es6 = false;
    return cb();
  });
};
