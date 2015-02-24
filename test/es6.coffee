
multic = require '../js/multic'
test   = require '../simple-test'


code = """
var x = (a) => {
   return a + 1;
}
"""


opts = file: 'src/test.es6'


test
  'js': (cb) ->
    multic.es6(code).js opts, (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('=>') > 1
        cb 'Compilation error'
      if res.compiled.split('\n').length < 3
        cb 'Not pretty'
      cb()

  'js.min': (cb) ->
    multic.es6(code).js.min opts, (err, res) ->
      if err
        cb err
      if res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()
