
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
    multic.js(code).min opts, (err, res) ->
      if err
        cb err
      if res.minified.indexOf('+1}') < 0 or res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()
