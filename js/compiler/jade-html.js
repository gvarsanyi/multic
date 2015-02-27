// Generated by CoffeeScript 1.9.1
var CompilationError, CompilationWarning, compiler, path, util,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
  slice = [].slice;

CompilationError = require('../error/compilation-error');

CompilationWarning = require('../warning/compilation-warning');

compiler = require('jade');

path = require('path');

util = require('util');

compiler.Parser.prototype._parseInclude = compiler.Parser.prototype.parseInclude;

compiler.Parser.prototype.parseInclude = function() {
  var ipath, ref, tok;
  if (Array.isArray((ref = this.options) != null ? ref.includes : void 0)) {
    tok = this.peek();
    ipath = path.resolve(this.resolvePath(tok.val.trim(), 'include'));
    if (indexOf.call(this.options.includes, ipath) < 0) {
      this.options.includes.push(ipath);
    }
  }
  return this._parseInclude();
};

compiler.Parser.prototype._parseExpr = compiler.Parser.prototype.parseExpr;

compiler.Parser.prototype.parseExpr = function() {
  var expr, ref, ref1;
  expr = this._parseExpr();
  if (Array.isArray((ref = this.options) != null ? ref.nodes : void 0)) {
    if ((ref1 = this.options) != null) {
      ref1.nodes.push(expr);
    }
  }
  return expr;
};

module.exports = function(inf, cb) {
  var cfg, desc, err, err_line, i, includes, len, line, orig_warn, pos, ref, ref1;
  if (inf.compiledJade != null) {
    inf.res.compiled = inf.compiledJade;
    return cb();
  }
  try {
    orig_warn = console.warn;
    console.warn = function() {
      var desc, i, item, len, line, msg, msgs, pos, spos;
      msgs = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      msg = [];
      for (i = 0, len = msgs.length; i < len; i++) {
        item = msgs[i];
        msg.push(typeof item === 'string' ? item : util.inspect(item));
      }
      msg = msg.join();
      if (msg.substr(0, 9) === 'Warning: ' && ((spos = msg.indexOf(' for line ')) > -1 || (spos = msg.indexOf(' on line ')) > -1)) {
        desc = msg.substr(9, spos);
        line = msg.substr(spos + 1).split(' ')[2];
        pos = CompilationWarning.parsePos(line, null, -1);
        return inf.res.warnings.push(new CompilationWarning(inf, msg, pos, desc));
      } else {
        return inf.res.warnings.push(new CompilationWarning(inf, msg));
      }
    };
    cfg = {
      compileDebug: false,
      pretty: true,
      includes: (includes = [])
    };
    if (inf.options.file) {
      cfg.filename = inf.options.file;
    }
    if (Array.isArray(inf.jadeNodes)) {
      cfg.nodes = inf.jadeNodes;
    }
    inf.res.compiled = compiler.render(inf.source, cfg);
    console.warn = orig_warn;
    if (Array.isArray(includes)) {
      (ref = inf.res.includes).push.apply(ref, includes);
    }
  } catch (_error) {
    err = _error;
    console.warn = orig_warn;
    desc = String(err).split('\n\n').slice(1).join('\n\n');
    ref1 = String(err).split('\n');
    for (i = 0, len = ref1.length; i < len; i++) {
      err_line = ref1[i];
      if (!(err_line.substr(0, 4) === '  > ')) {
        continue;
      }
      line = String(err_line.substr(4).split('|')[0]).trim();
      break;
    }
    pos = CompilationError.parsePos(line, null, -1);
    inf.res.errors.push(new CompilationError(inf, err, pos, desc));
  }
  return cb();
};
