
multic = require '../js/multic'
test   = require '../simple-test'


code = """
<div id='id1' class='class1'>
  <h1>Hello</h1>
</div>
"""


opts = file: 'src/test.html'


test
  'min': (cb) ->
    multic(code, opts).html.min (err, res) ->
      if err
        cb err
      if res.minified.indexOf('  ') > 1 or res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()
