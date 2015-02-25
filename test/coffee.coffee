
fs     = require 'fs'
mkdirp = require 'mkdirp'
multic = require '../js/multic'
test   = require '../simple-test'


code = """
x = (a) ->
  a + 1
"""


opts = file: 'src/test.coffee'


test
  'js': (cb) ->
    multic(code, opts).coffee.js (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('->') > 1
        cb 'Compilation error'
      if res.compiled.split('\n').length < 3
        cb 'Not pretty'
      cb()

  'js.min': (cb) ->
    multic(code, opts).coffee.js.min (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('->') > 1
        cb 'Compilation error'
      if res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()

  'error warning (from lint)': (cb) ->
    code2 = code + '\ny = () ->\n'
    multic(code2, opts).coffee.js (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) and
      warn.sourceLines?[warn.line].indexOf('y = ()') > -1
        cb 'Warning code snippet is not a match:', warn
      cb()

  'error handling': (cb) ->
    code2 = code + '\n  x = <-\n'
    multic(code2, opts).coffee.js (err, res) ->
      unless err
        cb 'Missing error'
      unless err.sourceLines?[err.line].indexOf('x = <-') > 1
        cb 'Error code snippet is not a match:', err
      cb()

  'from file': (cb) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      if err
        cb err

      fs.writeFile 'tmp/code.coffee', code, (err) ->
        if err
          cb err

        multic('tmp/code.coffee', opts).file.coffee.js (err, res) ->
          if err
            cb err
          if res.compiled.indexOf('->') > 1
            cb 'Compilation error'
          if res.compiled.split('\n').length < 3
            cb 'Not pretty'
          cb()

  'lint from file': (cb) ->
    code2 = code + '\ny = () ->\n'
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      if err
        cb err

      fs.writeFile 'tmp/code.coffee', code2, (err) ->
        if err
          cb err

        multic('tmp/code.coffee', opts).file.coffee (err, res) ->
          if err
            cb err
          unless (warn = res.warnings[0]) and
          warn.sourceLines?[warn.line].indexOf('y = ()') > -1
            cb 'Warning code snippet is not a match:', warn
          cb()
