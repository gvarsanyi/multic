
multic = require '../js/multic'
test   = require '../simple-test'


code = """
function x (a) {
   return a + 1;
}
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

  'error handling': (cb) ->
    code2 = code + '\n  x = <-\n'
    multic(code2, opts).js.min (err, res) ->
      unless err
        cb 'Missing error'
      unless err.sourceLines?[err.line].indexOf('x = <-') > 1
        cb 'Error code snippet is not a match:', err
      cb()
