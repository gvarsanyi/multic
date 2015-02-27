
multic = require '../js/multic'
test   = require '../simple-test'


code = """
x = (a) ->
  a + 1
"""


opts = file: 'src/test.coffee'


test
  'eof': (cb) ->
    multic(code, opts).coffee.js (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) and
      warn.sourceLines?[warn.line]?.substr(warn.column - 1) is '1'
        cb 'Warning code snippet is not a match:', warn
      code += '\n'
      cb()

  'eofx': (cb) ->
    multic(code + '\n\n', opts).coffee.js (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) and
      warn.sourceLines?[warn.line] is '' and warn.column is 0
        cb 'Warning code snippet is not a match:', warn
      cb()

  'eol': (cb) ->
    multic(code.split('\n').join('\r\n'), opts).coffee.js (err, res) ->
      unless err
        cb 'Error was expected'
      unless err.sourceLines?[err.line]?.substr(err.column) is '\r'
        cb 'Warning code snippet is not a match:', err
      cb()

  'wsln': (cb) ->
    multic('   \n' + code, opts).coffee.js (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) and
      warn.sourceLines?[warn.line] is '   ' and warn.column is 0
        cb 'Warning code snippet is not a match:', warn
      cb()

  'eolws': (cb) ->
    multic(code.replace('\n', '   \n'), opts).coffee.js (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) and
      warn.sourceLines?[warn.line]?.substr(warn.column) is '   '
        cb 'Warning code snippet is not a match:', warn
      cb()

  'maxln': (cb) ->
    xxl = '# this is a very long line that wont fit the maxlen requirement' +
          'hence it will trigger a lint warning\n'
    opts.max_line_length = true # translates to 80
    multic(code + xxl, opts).coffee.js (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) and warn.column is 80 and
      warn.sourceLines?[warn.line]?.substr(warn.column, 5) is 'gger '
        cb 'Warning code snippet is not a match:', warn
      cb()
