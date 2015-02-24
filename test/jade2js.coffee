
multic = require '../js/multic'
test   = require '../simple-test'


code = """
#id1.class1
  h1 Hello
"""


opts = file: 'src/test.script.jade'


test
  'js': (cb) ->
    multic(code, opts).jade.js (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('h1 Hello') > 1
        cb 'Compilation error'
      if res.compiled.split('\n').length < 3
        cb 'Not pretty'
      cb()

  'js.min': (cb) ->
    multic(code, opts).jade.js.min (err, res) ->
      if err
        cb err
      if res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()
