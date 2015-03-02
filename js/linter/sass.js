// Generated by CoffeeScript 1.9.1
var rule_parser, sass_compiler;

rule_parser = require('./rule/_parser');

sass_compiler = require('../compiler/sass-css');

module.exports = function(inf, cb) {
  inf.sourceMap = [];
  inf.includeSources = {};
  return sass_compiler(inf, function() {
    inf.compiledSass = inf.res.compiled;
    delete inf.res.compiled;
    if (inf.res.errors.length) {
      return cb();
    }
    return rule_parser(inf, 'sass', cb, function(cfg) {
      return cb();
    });
  });
};
