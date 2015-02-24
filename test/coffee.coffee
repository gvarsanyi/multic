
multic = require '../js/multic'
test   = require '../simple-test'


code = """
x = (a) ->
  a + 1
"""


opts = file: 'src/test.coffee'


test
  'js': (cb) ->
    multic.coffee(code).js opts, (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('->') > 1
        cb 'Compilation error'
      if res.compiled.split('\n').length < 3
        cb 'Not pretty'
      cb()

  'js.min': (cb) ->
    multic.coffee(code).js.min opts, (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('->') > 1
        cb 'Compilation error'
      if res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()
