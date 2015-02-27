
multic = require '../js/multic'
test   = require '../simple-test'


code = """
"use strict";

function x (a) {
  return a + 1;
}

x();
"""


opts = file: 'src/test.js'


test
  'min': (cb) ->
    multic(code, opts).js.min (err, res) ->
      if err
        cb err
      if res.minified.indexOf('+1}') < 0 or res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()

  'warning handling (linter: unused)': (cb) ->
    code2 = code.split '\n'
    code2.push 'if (true)', '  ' + code2.pop()
    multic(code2.join('\n') + '\n', opts).js.min (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0])? and
      warn.sourceLines?[warn.line].substr(warn.column, 3) is 'x()'
        cb 'Warning code snippet is not a match', warn
      cb()

  'error handling (linter)': (cb) ->
    code2 = code + '\n  x = <-\n'
    multic(code2, opts).js.min (err, res) ->
      unless err
        cb 'Missing error'
      unless err.sourceLines?[err.line].substr(err.column, 2) is '<-'
        cb 'Error code snippet is not a match', err
      cb()

  'error handling (minifier)': (cb) ->
    code2 = code + '\n  x = <-\n'
    multic(code2, {file: opts.file, lint: false}).js.min (err, res) ->
      unless err
        cb 'Missing error'
      unless err.sourceLines?[err.line].substr(err.column, 2) is '<-'
        cb 'Error code snippet is not a match', err
      cb()
