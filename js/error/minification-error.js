// Generated by CoffeeScript 1.9.3
var MinificationError, MulticError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

MulticError = require('../multic-error');

MinificationError = (function(superClass) {
  extend(MinificationError, superClass);

  function MinificationError() {
    return MinificationError.__super__.constructor.apply(this, arguments);
  }

  return MinificationError;

})(MulticError);

module.exports = MinificationError;
