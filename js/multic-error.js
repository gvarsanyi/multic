// Generated by CoffeeScript 1.9.1
var MulticError, fs, intify, path,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

fs = require('fs');

path = require('path');

intify = function(n) {
  if (String(n) !== String(n).replace(/[^0-9]/, '')) {
    return;
  }
  return n = Number(n);
};

MulticError = (function(superClass) {
  extend(MulticError, superClass);

  MulticError.prototype.column = null;

  MulticError.prototype.file = null;

  MulticError.prototype.line = null;

  MulticError.prototype.sourceLines = null;

  MulticError.prototype.title = null;

  function MulticError(inf, err, pos, description, title) {
    var column, column_n, errfile, from, i, j, len1, line, line_literal, line_n, orig_name, override_source, ref, ref1, source, sourcelines;
    if (Array.isArray(pos)) {
      line = pos[0], column = pos[1];
    } else {
      line = pos;
    }
    if (err && typeof err === 'object') {
      orig_name = err != null ? (ref = err.constructor) != null ? ref.name : void 0 : void 0;
      if (String(orig_name).toLowerCase() === 'error') {
        orig_name = null;
      }
    }
    this.title = title || orig_name || this.constructor.name;
    this.file = inf.options.file;
    if (inf.options.file && (errfile = (err != null ? err.file : void 0) || (err != null ? err.path : void 0)) && (errfile = path.resolve(errfile)) !== inf.options.file) {
      this.file = errfile;
      try {
        override_source = fs.readFileSync(errfile, {
          encoding: 'utf8'
        });
      } catch (_error) {
        line = column = null;
      }
    }
    if ((line_n = intify(line)) != null) {
      this.line = line_n;
      if ((column_n = intify(column)) != null) {
        this.column = column_n;
      }
      source = override_source || inf.source;
      from = Math.max(0, line_n - 5);
      if ((ref1 = (sourcelines = source != null ? source.split('\n').slice(from, +(line_n + 5) + 1 || 9e9) : void 0)) != null ? ref1.length : void 0) {
        for (i = j = 0, len1 = sourcelines.length; j < len1; i = ++j) {
          line_literal = sourcelines[i];
          (this.sourceLines != null ? this.sourceLines : this.sourceLines = {})[from + i] = line_literal;
        }
      }
    }
    this.message = description || (err != null ? err.message : void 0) || (err ? String(err) : '');
    MulticError.__super__.constructor.call(this, this.message);
  }

  MulticError.parsePos = function(line, column, line_off, column_off) {
    var column_n, line_n;
    if (line_off == null) {
      line_off = 0;
    }
    if (column_off == null) {
      column_off = 0;
    }
    if ((line_n = intify(line)) != null) {
      line_n += line_off;
      if ((column_n = intify(column)) != null) {
        column_n += column_off;
      }
      return [line_n, column_n];
    }
    return null;
  };

  MulticError.posByIndex = function(lines, col) {
    var len, line;
    line = 0;
    while ((lines[line] != null) && col > (len = lines[line].length)) {
      col -= len + 1;
      line += 1;
    }
    return [line, col];
  };

  return MulticError;

})(Error);

module.exports = MulticError;
