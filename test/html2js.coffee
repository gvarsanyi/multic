
multic = require '../js/multic'
test   = require '../simple-test'


code = """
<div id='id1' class='class1'>
  <h1>Hello</h1>
</div>
"""


opts = file: 'src/test.script.html'


test
  'js': (cb) ->
    multic.html(code).js opts, (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('h1 Hello') > 1
        cb 'Compilation error'
      if res.compiled.split('\n').length < 3
        cb 'Not pretty'
      cb()

  'js.min': (cb) ->
    multic.html(code).js.min opts, (err, res) ->
      if err
        cb err
      if res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()
