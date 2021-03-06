// Generated by CoffeeScript 1.9.3
var less_compiler, rule_parser;

rule_parser = require('./rule/_parser');

less_compiler = require('../compiler/less-css');

module.exports = function(inf, cb) {
  inf.sourceMap = [];
  inf.includeSources = {};
  return less_compiler(inf, function() {
    inf.compiledLess = inf.res.compiled;
    delete inf.res.compiled;
    if (inf.res.errors.length) {
      return cb();
    }
    return rule_parser(inf, 'less', cb, function(cfg) {
      return cb();
    });
  });
};
