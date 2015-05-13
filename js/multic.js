// Generated by CoffeeScript 1.9.2
var COMPILE, MINIFY, MulticProcess, READ, WRITE, cluster, source_to_target_types;

MulticProcess = require('./multic-process');

READ = 1;

COMPILE = 2;

MINIFY = 4;

WRITE = 8;

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
  var fn, fn1, i, iface, inf, len, source_type, target_type, target_types;
  inf = new MulticProcess(src, options);
  iface = {
    file: {}
  };
  fn = inf.start;
  for (source_type in source_to_target_types) {
    target_types = source_to_target_types[source_type];
    fn1 = function(source_type, target_type) {
      var base;
      if (iface[source_type] == null) {
        iface[source_type] = function(cb) {
          return fn(0, source_type, source_type, cb);
        };
      }
      if ((base = iface.file)[source_type] == null) {
        base[source_type] = function(cb) {
          return fn(READ, source_type, source_type, cb);
        };
      }
      if (target_type === 'min') {
        iface[source_type].min = function(cb) {
          return fn(MINIFY, source_type, source_type, cb);
        };
        iface[source_type].min.write = function(target, cb) {
          return fn(MINIFY | WRITE, source_type, source_type, cb, target);
        };
        iface.file[source_type].min = function(cb) {
          return fn(READ | MINIFY, source_type, source_type, cb);
        };
        return iface.file[source_type].min.write = function(target, cb) {
          return fn(READ | MINIFY | WRITE, source_type, source_type, cb, target);
        };
      } else {
        iface[source_type][target_type] = function(cb) {
          return fn(COMPILE, source_type, target_type, cb);
        };
        iface[source_type][target_type].write = function(target, cb) {
          return fn(COMPILE | WRITE, source_type, target_type, cb, target);
        };
        iface[source_type][target_type].min = function(cb) {
          return fn(COMPILE | MINIFY, source_type, target_type, cb);
        };
        iface[source_type][target_type].min.write = function(target, cb) {
          return fn(COMPILE | MINIFY | WRITE, source_type, target_type, cb, target);
        };
        iface.file[source_type][target_type] = function(cb) {
          return fn(READ | COMPILE, source_type, target_type, cb);
        };
        iface.file[source_type][target_type].write = function(target, cb) {
          return fn(READ | COMPILE | WRITE, source_type, target_type, cb, target);
        };
        iface.file[source_type][target_type].min = function(cb) {
          return fn(READ | COMPILE | MINIFY, source_type, target_type, cb);
        };
        return iface.file[source_type][target_type].min.write = function(target, cb) {
          return fn(READ | COMPILE | MINIFY | WRITE, source_type, target_type, cb, target);
        };
      }
    };
    for (i = 0, len = target_types.length; i < len; i++) {
      target_type = target_types[i];
      fn1(source_type, target_type);
    }
  }
  return iface;
};

cluster = null;

module.exports.cluster = function() {
  return cluster = require('./cluster');
};

module.exports.stopCluster = function(cb) {
  return cluster.stop(cb);
};
