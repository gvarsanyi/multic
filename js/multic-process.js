// Generated by CoffeeScript 1.9.3
var COMPILE, LINT, MINIFY, MulticProcess, Promise, READ, WRITE, fs, path,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Promise = null;

fs = require('fs');

path = require('path');

READ = 1;

COMPILE = 2;

MINIFY = 4;

WRITE = 8;

LINT = 128;

MulticProcess = (function() {
  MulticProcess.prototype.callback = null;

  MulticProcess.prototype.options = null;

  MulticProcess.prototype.promiseReject = null;

  MulticProcess.prototype.promiseResolve = null;

  MulticProcess.prototype.res = null;

  MulticProcess.prototype.source = null;

  MulticProcess.prototype.todo = 0;

  function MulticProcess(source, options) {
    this.source = source;
    this.options = options != null ? options : {};
    this.process = bind(this.process, this);
    this.finish = bind(this.finish, this);
    this.start = bind(this.start, this);
    if (!(typeof this.source === 'string' && this.source)) {
      throw new Error('Argument #1 `source` must be string type: source or ' + 'source file path');
    }
    if (typeof this.options !== 'object') {
      throw new Error('Argument #2 `options` must be object type');
    }
    if (this.options.file != null) {
      if (!(typeof this.options.file === 'string' && (this.options.file = path.resolve(this.options.file)))) {
        throw new Error('options.file must be a valid URL string');
      }
    }
    this.cue = [];
    this.res = {
      errors: [],
      includes: [],
      warnings: []
    };
  }

  MulticProcess.prototype.start = function(todo, sourceType, targetType, callback, target) {
    var arg_id;
    this.todo = todo;
    this.sourceType = sourceType;
    this.targetType = targetType;
    this.target = target;
    if (this.promiseResolve || this.callback) {
      throw new Error('Duplicate processing is forbidden');
    }
    if (((this.callback = callback) != null) && typeof this.callback !== 'function') {
      arg_id = ' (argument #' + (this.todo & WRITE ? 2 : 1) + ')';
      throw new Error('`callback`' + arg_id + ' must be a callback function');
    }
    if (this.todo & WRITE) {
      if (typeof this.target !== 'string' || !this.target) {
        throw new Error('`target` (argument #1) must be a string with value ' + 'that specifies path for file output');
      }
    }
    if (this.options.lint !== false) {
      this.todo = this.todo | LINT;
    }
    if (this.callback) {
      return this.process();
    }
    if (Promise == null) {
      Promise = require('promise');
    }
    return new Promise((function(_this) {
      return function(promiseResolve, promiseReject) {
        _this.promiseResolve = promiseResolve;
        _this.promiseReject = promiseReject;
        return _this.process();
      };
    })(this));
  };

  MulticProcess.prototype.finish = function() {
    var err;
    err = this.res.errors[0] || null;
    if (this.callback) {
      this.callback(err, this.res);
    } else if (err) {
      err.res = this.res;
      this.promiseReject(err);
    } else {
      this.promiseResolve(this.res);
    }
  };

  MulticProcess.prototype.process = function() {
    var data;
    if (this.res.errors.length) {
      return this.finish();
    }
    if (this.todo & READ) {
      this.todo -= READ;
      this.options.file = path.resolve(this.source);
      return fs.readFile(this.options.file, {
        encoding: 'utf8'
      }, (function(_this) {
        return function(err, code) {
          if (err) {
            _this.res.errors.push(err);
          }
          _this.source = _this.res.source = code || '';
          return _this.process();
        };
      })(this));
    }
    if (this.todo & LINT) {
      this.todo -= LINT;
      return require('./linter/' + this.sourceType)(this, (function(_this) {
        return function() {
          return _this.process();
        };
      })(this));
    }
    if (this.todo & COMPILE) {
      this.todo -= COMPILE;
      return require('./compiler/' + this.sourceType + '-' + this.targetType)(this, (function(_this) {
        return function() {
          if (typeof _this.res.compiled !== 'string') {
            _this.res.compiled = '';
          }
          return _this.process();
        };
      })(this));
    }
    if (this.todo & MINIFY) {
      this.todo -= MINIFY;
      if (this.res.compiled != null) {
        this.source = this.res.compiled;
      }
      return require('./minifier/' + this.targetType)(this, (function(_this) {
        return function() {
          if (typeof _this.res.minified !== 'string') {
            _this.res.minified = '';
          }
          return _this.process();
        };
      })(this));
    }
    if (this.todo & WRITE) {
      this.todo -= WRITE;
      data = this.res.minified || this.res.compiled;
      return fs.writeFile(this.target, data, {
        encoding: 'utf8'
      }, (function(_this) {
        return function(err) {
          if (err) {
            _this.res.errors.push(err);
          }
          return _this.process();
        };
      })(this));
    }
    return this.finish();
  };

  return MulticProcess;

})();

module.exports = MulticProcess;
