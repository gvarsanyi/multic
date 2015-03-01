// Generated by CoffeeScript 1.9.1
var fs, path, sources;

fs = require('fs');

path = require('path');

sources = {
  coffee: ['js'],
  css: ['min'],
  es6: ['js'],
  html: ['js', 'min'],
  jade: ['html', 'js'],
  js: ['min'],
  sass: ['css']
};

module.exports = function(src, options) {
  var err_arg0, err_arg1, errors, fn, i, iface, inf, len, process, res, source, target, targets;
  if (typeof src !== 'string') {
    err_arg0 = new Error('Argument #1 `source` must be string type');
  }
  if ((options != null) && typeof options !== 'object') {
    err_arg1 = new Error('Argument #2 `options` must be object type');
    options = {};
  }
  if (options == null) {
    options = {};
  }
  inf = {
    options: options
  };
  res = inf.res != null ? inf.res : inf.res = {
    errors: errors = [],
    includes: [],
    warnings: []
  };
  inf.ruleTmp = {};
  if (options.file != null) {
    if (!(typeof options.file === 'string' && (options.file = path.resolve(options.file)))) {
      errors.push(new Error('options.file must be a valid URL string'));
    }
  }
  if (err_arg0) {
    errors.push(err_arg0);
  }
  if (err_arg1) {
    errors.push(err_arg1);
  }
  process = function(lint_inf, compile_inf, minify_inf, cb) {
    var source, target;
    if (typeof cb !== 'function') {
      throw new Error('Argument #1 (only argument) must be a callback function');
    }
    if (errors.length) {
      return cb(errors[0], res);
    }
    if (inf.source == null) {
      options.file = path.resolve(src);
      return fs.readFile(options.file, {
        encoding: 'utf8'
      }, function(err, code) {
        if (err) {
          errors.push(err);
        } else {
          inf.source = res.source = code;
        }
        return process(lint_inf, compile_inf, minify_inf, cb);
      });
    }
    if (lint_inf && (inf.lint || (inf.lint == null))) {
      inf.lint = false;
      return require('./linter/' + lint_inf)(inf, function() {
        return process(lint_inf, compile_inf, minify_inf, cb);
      });
    }
    if (compile_inf && (res.compiled == null)) {
      source = compile_inf.source, target = compile_inf.target;
      return require('./compiler/' + source + '-' + target)(inf, function() {
        if (typeof res.compiled !== 'string') {
          res.compiled = '';
        }
        return process(lint_inf, compile_inf, minify_inf, cb);
      });
    }
    if (minify_inf && (res.minified == null)) {
      if (res.compiled) {
        inf.source = res.compiled;
      }
      return require('./minifier/' + minify_inf)(inf, function() {
        if (typeof res.minified !== 'string') {
          res.minified = '';
        }
        return process(lint_inf, compile_inf, minify_inf, cb);
      });
    }
    return cb(null, res);
  };
  iface = {
    file: {}
  };
  for (source in sources) {
    targets = sources[source];
    fn = function(source, target) {
      var base, base1, ffn, sfn;
      if (iface[source] == null) {
        iface[source] = function(cb) {
          inf.source = src;
          return process(source, false, false, cb);
        };
      }
      if ((base = iface.file)[source] == null) {
        base[source] = function(cb) {
          return process(source, false, false, cb);
        };
      }
      sfn = (iface[source] != null ? iface[source] : iface[source] = {})[target] = function(cb) {
        inf.source = src;
        if (target === 'min') {
          return process(source, false, source, cb);
        }
        return process(source, {
          source: source,
          target: target
        }, false, cb);
      };
      if (target !== 'min') {
        sfn.min = function(cb) {
          inf.source = src;
          return process(source, {
            source: source,
            target: target
          }, target, cb);
        };
      }
      ffn = ((base1 = iface.file)[source] != null ? base1[source] : base1[source] = {})[target] = function(cb) {
        if (target === 'min') {
          return process(source, false, source, cb);
        }
        return process(source, {
          source: source,
          target: target
        }, false, cb);
      };
      if (target !== 'min') {
        return ffn.min = function(cb) {
          return process(source, {
            source: source,
            target: target
          }, target, cb);
        };
      }
    };
    for (i = 0, len = targets.length; i < len; i++) {
      target = targets[i];
      fn(source, target);
    }
  }
  return iface;
};
