
multic = require '../js/multic'
test   = require '../simple-test'


code = """
"use strict";

var x = (a) => {
   return a + 1;
};
"""


opts = file: 'src/test.es6'


test
  'js': (cb) ->
    multic(code, opts).es6.js (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('=>') > 1
        cb 'Compilation error'
      if res.compiled.split('\n').length < 3
        cb 'Not pretty'
      cb()

  'js.min': (cb) ->
    multic(code, opts).es6.js.min (err, res) ->
      if err
        cb err
      if res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()

  'warning handling (linter: unused)': (cb) ->
    code2 = code.split '\n'
    code2.push 'if (true)', '  x = 1;'
    multic(code2.join('\n'), opts).es6.js.min (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0])? and
      warn.sourceLines?[warn.line].substr(warn.column, 3) is 'x ='
        cb 'Warning code snippet is not a match', warn
      cb()

  'error handling': (cb) ->
    code2 = code + '\nvar x = -> {}\n'
    multic(code2, opts).es6.js (err, res) ->
      unless err
        cb 'Missing error'
      unless err.sourceLines?[err.line].indexOf('x = ->') > 1
        cb 'Error code snippet is not a match:', err
      cb()
