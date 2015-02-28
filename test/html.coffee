
multic = require '../js/multic'
test   = require '../simple-test'


code = """
<div id='id1' class='class1'>
  <h1>Hello</h1>
  <h2>Hi</h2>
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

  'lint warning': (cb) ->
    code2 = code.replace '<h2>', '<h2 xxx>'
    opts.no_implicit_attribute_value = true
    multic(code2, opts).html (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0])? and
      warn.sourceLines?[warn.line].substr(warn.column, 6) is '<h2 xx'
        cb 'Warning code snippet is not a match', warn
      cb()
