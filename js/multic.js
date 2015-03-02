// Generated by CoffeeScript 1.9.1
var COMPILE, MINIFY, MulticProcess, READ, source_to_target_types;

MulticProcess = require('./multic-process');

READ = 1;

COMPILE = 2;

MINIFY = 4;

source_to_target_types = {
  coffee: ['js'],
  css: ['min'],
  es6: ['js'],
  html: ['js', 'min'],
  jade: ['html', 'js'],
  js: ['min'],
  sass: ['css']
};

module.exports = function(src, options) {
  var fn, i, iface, inf, len, source_type, target_type, target_types;
  inf = new MulticProcess(src, options);
  iface = {
    file: {}
  };
  for (source_type in source_to_target_types) {
    target_types = source_to_target_types[source_type];
    fn = function(source_type, target_type) {
      var base, base1, ffn, sfn;
      if (iface[source_type] == null) {
        iface[source_type] = function(cb) {
          return inf.process(0, source_type, source_type, cb);
        };
      }
      if ((base = iface.file)[source_type] == null) {
        base[source_type] = function(cb) {
          return inf.process(READ, source_type, source_type, cb);
        };
      }
      sfn = (iface[source_type] != null ? iface[source_type] : iface[source_type] = {})[target_type] = function(cb) {
        if (target_type === 'min') {
          return inf.process(MINIFY, source_type, source_type, cb);
        }
        return inf.process(COMPILE, source_type, target_type, cb);
      };
      if (target_type !== 'min') {
        sfn.min = function(cb) {
          return inf.process(COMPILE | MINIFY(source_type, target_type, cb));
        };
      }
      ffn = ((base1 = iface.file)[source_type] != null ? base1[source_type] : base1[source_type] = {})[target_type] = function(cb) {
        if (target_type === 'min') {
          return inf.process(READ | MINIFY(source_type, source_type, cb));
        }
        return inf.process(READ | COMPILE, source_type, target_type, cb);
      };
      if (target_type !== 'min') {
        return ffn.min = function(cb) {
          return inf.process(READ | COMPILE | MINIFY, source_type, target_type, cb);
        };
      }
    };
    for (i = 0, len = target_types.length; i < len; i++) {
      target_type = target_types[i];
      fn(source_type, target_type);
    }
  }
  return iface;
};
