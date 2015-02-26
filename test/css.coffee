
multic = require '../js/multic'
test   = require '../simple-test'


code = """

BODY {
  color: #fff;
  margin: 0;
}

"""


opts = file: 'src/test.css'


test
  'min': (cb) ->
    multic(code, opts).css.min (err, res) ->
      if err
        cb err
      if res.minified.indexOf('  ') > 1 or res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()

  'warning handling': (cb) ->
    code2 = code + '\nxx {\n  width: 10px;\n  _width: 20px; }\n'
    multic(code2, opts).css.min (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) and
      warn.sourceLines?[warn.line]?.substr(warn.column, 6) is '_width'
        cb 'Warning code snippet is not a match:', warn
      cb()

  'error handling': (cb) ->
    code2 = code + '\nx@@@x\n\n'
    multic(code2, opts).css.min (err, res) ->
      unless err
        cb 'Missing error'
      unless err.sourceLines?[err.line]?.substr(err.column, 2) is '@@'
        cb 'Error code snippet is not a match:', err
      cb()
